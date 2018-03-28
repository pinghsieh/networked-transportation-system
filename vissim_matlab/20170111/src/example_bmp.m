clear;
format compact;
vissim_com=actxserver('VISSIM.vissim');
%vissim_com.LoadNet('C:\Users\jiaojian\Desktop\JAN\timevar_pattern.inp');
vissim_com.LoadNet('C:\Users\jiaojian\Desktop\JAN\2800_net.inp');
vissim_com.LoadLayout('C:\Users\jiaojian\Desktop\JAN\vissim.ini');
sim=vissim_com.simulation;
timestep=1;
sim.Resolution=timestep;
eval=vissim_com.Evaluation;
eval.set('AttValue', 'netperformance', '0');
vnet=vissim_com.net;
vehins=vnet.VehicleInputs;
%datapoints=vnet.DataCollections;
%datapoint_1=datapoints.GetDataCollectionByNumber(1);


%% Instantiate VISSIM COM signal objects 
scs=vnet.signalcontrollers;
N_sc = 6;
N_sgs = 4;
sc = cell(N_sc,1);
sgs = cell(N_sc, N_sgs);

for j=1:N_sc
    sc{j}=scs.GetSignalControllerByNumber(j);
    sgs_temp=sc{j}.signalgroups;
    for m=1:N_sgs
        sgs{j, m} = sgs_temp.GetSignalGroupByNumber((j-1)*N_sgs+m);      
    end
end

%% Instantiate VISSIM COM link objects
simT = 1800;
N_links = 48;
N_intersections = 6;
amber_length = 3;
allred_length = 2;
sat_flow = 1;
Ts = amber_length + allred_length; % switchover delay
vissim_links = cell(N_links, 1);
links = vnet.links;
qlen_vector = zeros(N_links, 1);
pressure_vector = zeros(N_links, 1);
weighted_pressure_vector = zeros(N_links, 1);
%weight_vector = ones(N_links, 1);
amber_counter = zeros(N_intersections, 1);
allred_counter = zeros(N_intersections, 1);
current_phase = ones(N_intersections, 1);
phase_to_be_scheduled = zeros(N_intersections, 1); 
switchover_state = zeros(N_intersections, 1);
total_qlen = zeros(simT, 1);

%% Specify parameters for BMP/MP/VFMP policy
alpha = 0.01;  
beta_1 = 0.99;
beta_2 = 0.9;
superframe_end = 0;
scaling = 2;  % not in use
%policy = 'BMP';
policy = 'MP';
%policy = 'VFMP';
%policy = 'VFMW';
%policy = 'Mixed';
%policy_vec = {'BMP', 'BMP', 'BMP', 'Fixed-Time', 'Fixed-Time', 'Fixed-Time'};
policy_vec = {'MP', 'MP', 'MP', 'Fixed-Time', 'Fixed-Time', 'Fixed-Time'};
tau_k =1;
frame_count = zeros(N_intersections, 1);
updated_frame_count = 0;
as_default = 0;

%% create link objects and intersection objects in Matlab
[all_links, all_intersections, mapObj, total_arrival_rate, service_count, qlen_weight] = init_smart_network_vissim(sat_flow, scaling, policy);

for k=1:N_links
    vissim_links{k}=links.GetLinkByNumber(all_links{k}.link_id);
end

%% File I/O
QL_Log_ID = fopen('queue_length_debug.log', 'w');
Pressure_Log_ID = fopen('pressure_debug.log', 'w');
Pressure_Log_Node1_ID = fopen('pressure_node1_debug.log', 'w');
QL_Log_Node1_ID = fopen('queue_length_node1_debug.log', 'w');
Total_QL_Log_ID = fopen('total_queue_length.log', 'w');
Pressure_Log_Node4_ID = fopen('pressure_node4_debug.log', 'w');
QL_Log_Node4_ID = fopen('queue_length_node4_debug.log', 'w');
fprintf(QL_Log_ID, 'Time');
fprintf(Total_QL_Log_ID, 'Time\t Total-Queue-Length');
fprintf(Pressure_Log_ID, 'Time');
fprintf(Pressure_Log_Node1_ID, 'Time\t Decision \t Switchover');
fprintf(QL_Log_Node1_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(Pressure_Log_Node4_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(QL_Log_Node4_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');


for k=1:N_links
    fprintf(QL_Log_ID, '\t %d(%d)', k, all_links{k}.link_id); 
    fprintf(Pressure_Log_ID, '\t %d(%d)', k, all_links{k}.link_id); 
end

for k=1:length(all_intersections{1}.links_in)
    fprintf(Pressure_Log_Node1_ID, '\t %d', all_intersections{1}.links_in(k));
    fprintf(QL_Log_Node1_ID, '\t %d', all_intersections{1}.links_in(k)); 
end
for k=1:length(all_intersections{4}.links_in)
    fprintf(Pressure_Log_Node4_ID, '\t %d', all_intersections{4}.links_in(k));
    fprintf(QL_Log_Node4_ID, '\t %d', all_intersections{4}.links_in(k)); 
end
fprintf(QL_Log_ID, '\n');
fprintf(Total_QL_Log_ID, '\n');
fprintf(Pressure_Log_ID, '\n');
fprintf(Pressure_Log_Node1_ID, '\n'); 
fprintf(QL_Log_Node1_ID, '\n'); 
fprintf(Pressure_Log_Node4_ID, '\n'); 
fprintf(QL_Log_Node4_ID, '\n'); 

%% Slot-by-slot evolution   
for i=1:simT
    sim.RunSingleStep;
    state=sgs{1,2}.get('State');
    disp(['Simulation Time: ' num2str(i)]);

    fprintf(QL_Log_ID, '%d', i);
    fprintf(Total_QL_Log_ID, '%d', i);
    fprintf(Pressure_Log_ID, '%d', i);
    fprintf(Pressure_Log_Node1_ID, '%d', i);
    fprintf(QL_Log_Node1_ID, '%d', i);
    fprintf(Pressure_Log_Node4_ID, '%d', i);
    fprintf(QL_Log_Node4_ID, '%d', i);    
    % Update queue length vector
    for k=1:N_links
        % Use density and link length to get queue length
        %a = (vissim_links{k}.GetSegmentResult('density', 0, -1.0))*vissim_links{k}.AttValue('length'); 
        a = vissim_links{k}.GetSegmentResult('density', 0, -1.0); 
        link_length = 300*0.3048/1000;  % unit: kilometer
        qlen_vector(k) = a(1,2)*link_length;
    end
    density_77 = vissim_links{25}.GetSegmentResult('density', 0, -1.0); 
    density_82 = vissim_links{28}.GetSegmentResult('density', 0, -1.0); 
   % disp(['Simulation Time: ' num2str(i) ' Density 77: ' num2str(density_77(1,2)) ' Density 82: ' num2str(density_82(1,2))]);
    
    % Update superframe
    if i == tau_k
        superframe_end = 1;
        Tk = Ts + floor(power(sum(qlen_vector), beta_1));
        tau_k = tau_k + Tk;
        fprintf('Tk: %d\n', Tk);
    else
        superframe_end = 0;
    end
    
    for m=1:N_intersections
        % Check if the intersection is in switchover
        % If there is one phase in green, then switchover = 0
        for p=1:size(all_intersections{m}.phases, 2)
            if strcmp(sgs{m,p}.get('State'),'Green') 
                switchover_state(m) = 0;
                current_phase(m) = p;
            end
        end
        % For debug
        if m == 1
            fprintf(Pressure_Log_Node1_ID, '\t %d\t %d', current_phase(1), switchover_state(1));  
        end

        
        % Specify a scheduling policy
        switch policy
            case 'BMP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, F] = all_intersections{m}.bmp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, alpha, superframe_end);
                as_default = 0;
            case 'MP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector] = all_intersections{m}.mp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, alpha);            
                as_default = 0;
            case 'VFMP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                frame_count(m) = updated_frame_count;
                as_default = 0;
            case 'VFMW'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmw(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                frame_count(m) = updated_frame_count;
                as_default = 0;    
            case 'Mixed'
                if strcmp(policy_vec{m}, 'BMP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, F] = all_intersections{m}.bmp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, alpha, superframe_end);                     
                    as_default = 0;
                elseif strcmp(policy_vec{m}, 'MP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector] = all_intersections{m}.mp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, alpha);
                    as_default = 0;
                elseif strcmp(policy_vec{m}, 'VFMP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmp(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                    frame_count(m) = updated_frame_count; 
                    as_default = 0;
                elseif strcmp(policy_vec{m}, 'VFMW')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmw(qlen_vector, all_links, mapObj, pressure_vector, qlen_weight, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                    frame_count(m) = updated_frame_count; 
                    as_default = 0;                    
                elseif strcmp(policy_vec{m}, 'Fixed-Time')
                    as_default = 1;
                end                
        end
        if as_default == 0
            if switchover_state(m) == 0
 
                phase_to_be_scheduled(m) = scheduled_phase_id;
                if current_phase(m) ~= phase_to_be_scheduled(m)
                    amber_counter(m) = amber_length;
                    allred_counter(m) = allred_length;
                    switchover_state(m) = 1;
                else
                    amber_counter(m) = 0;
                    allred_counter(m) = 0;
                    switchover_state(m) = 0;                
                end         
            else
                if (superframe_end == 1)
                    % change "phase_to_be_scheduled", but leave amber_counter and
                    % allred_counter as they were
                    phase_to_be_scheduled(m) = scheduled_phase_id; 
                end
            end
        
            %% Decrement amber counter or allred counter
            % yellow
            if (amber_counter(m) > 0) 
                for n=1:size(all_intersections{m}.phases, 2)
                    if n == current_phase(m)
                        sgs{m,n}.set('AttValue','State',2);  % 3: green; 2: amber; 1: red
                    else
                        sgs{m,n}.set('AttValue','State',1);  % 3: green; 2: amber; 1: red
                    end
                end
                amber_counter(m) = amber_counter(m) - 1;
            % all reds
            else if (amber_counter(m) == 0 && allred_counter(m) > 0)
                for n=1:size(all_intersections{m}.phases, 2)
                    sgs{m,n}.set('AttValue','State',1);  % 3: green; 2: amber; 1: red
                end
                allred_counter(m) = allred_counter(m) - 1;
            % green
                else
                    for n=1:size(all_intersections{m}.phases, 2)
                        if n == phase_to_be_scheduled(m)  
                            sgs{m,n}.set('AttValue','State',3);  % 3: green; 1: red
                        else
                            sgs{m,n}.set('AttValue','State',1);  % 3: green; 1: red
                        end
                    end 
                    switchover_state(m) = 0;
                    current_phase(m) = phase_to_be_scheduled(m);
                end 
            end
        
            % For debug
            if m == 1
                fprintf(Pressure_Log_Node1_ID, '\t %d\t %d\t %d\t %d', current_phase(1), switchover_state(1), superframe_end, updated_frame_count);  
                fprintf(QL_Log_Node1_ID, '\t %d\t %d\t %d\t %d', current_phase(1), switchover_state(1), superframe_end, updated_frame_count);  
            end
            if m == 4
                fprintf(Pressure_Log_Node4_ID, '\t %d\t %d\t %d\t %d', current_phase(4), switchover_state(4), superframe_end, updated_frame_count);  
                fprintf(QL_Log_Node4_ID, '\t %d\t %d\t %d\t %d', current_phase(4), switchover_state(4), superframe_end, updated_frame_count);  
            end
        end
    end
    %disp(['Simulation Time: ' num2str(i) ' Pressure 77: ' num2str(pressure_vector(25)) ' Pressure 82: ' num2str(pressure_vector(28))]);
   

    % Output data to debug logs
    for u=1:N_links
        fprintf(QL_Log_ID, '\t %d', qlen_vector(u));
        fprintf(Pressure_Log_ID, '\t %.1f', weighted_pressure_vector(u));
    end
    for u=1:length(all_intersections{1}.links_in)
        lid = cell2mat(values(mapObj,{all_intersections{1}.links_in(u)}));
        fprintf(Pressure_Log_Node1_ID, '\t %.1f', weighted_pressure_vector(lid));  
        fprintf(QL_Log_Node1_ID, '\t %d', qlen_vector(lid));  
    end
    for u=1:length(all_intersections{4}.links_in)
        lid = cell2mat(values(mapObj,{all_intersections{4}.links_in(u)}));
        fprintf(Pressure_Log_Node4_ID, '\t %.1f', weighted_pressure_vector(lid));  
        fprintf(QL_Log_Node4_ID, '\t %d', qlen_vector(lid));  
    end
    fprintf(QL_Log_ID, '\n');
    fprintf(Pressure_Log_ID, '\n');
    fprintf(Pressure_Log_Node1_ID, '\n'); 
    fprintf(QL_Log_Node1_ID, '\n');
    fprintf(Pressure_Log_Node4_ID, '\n');  
    fprintf(QL_Log_Node4_ID, '\n');
    %if rem(i,10)==0
    %volume=link_1.GetSegmentResult('volume', 0, 0.0,1,0);
    %disp(['volume: ' num2str(volume)]);
    
    % Record simulation results
    total_qlen(i) = sum(qlen_vector);
    fprintf(Total_QL_Log_ID, '\t%d\n', total_qlen(i));
    
end
disp(['Simulation Time: ' num2str(i)]);

%% Plotting
spacing = 20;
N_points = floor(simT/spacing);
time_index = spacing*(1:1:N_points);
createfigure([0, time_index], [0; total_qlen(time_index)]);
fclose(QL_Log_ID);
fclose(Pressure_Log_ID);
fclose(Pressure_Log_Node1_ID);
