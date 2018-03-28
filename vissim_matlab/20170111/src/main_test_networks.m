%%------------------------------------------------------ 
% Project: A MATLAB Simulator for smart intersections
% Author: Ping-Chun Hsieh
% Date: 12/28/2016
%
%-------------------------------------------------------
clear;

%% Initialize link and intersection objects
simT = 100;
N_links = 4;
N_intersections = 2;
amber_length = 1;
allred_length = 1;
Ts = amber_length + allred_length; % switchover delay
saturation_flow = 3;  % assume saturation flow
arrival_mode = 10;  % deterministic arrival process
arrival_rate_scaling = 1; % arrival rate scaling factor
qlen_vector = zeros(N_links, 1);
Delta_qlen_vector = zeros(N_links, 1);
pressure_vector = zeros(N_links, 1);
weighted_pressure_vector = zeros(N_links, 1);
weight_vector = ones(N_links, 1);
amber_counter = zeros(N_intersections, 1);
allred_counter = zeros(N_intersections, 1);
current_phase = ones(N_intersections, 1);
phase_to_be_scheduled = ones(N_intersections, 1); 
switchover_state = zeros(N_intersections, 1);
switchover_count = zeros(N_intersections, 1);
tau_k = 1;
superframe_end = 0;
frame_count = zeros(N_intersections, 1);
updated_frame_count = 0;

%% Specify scheduling policy
%policy = 'BMP';
%policy = 'Fixed-Time';
%policy = 'VFMP';
policy = 'MP';
%policy = 'VFMW';
%policy = 'Mixed';
policy_vec = {'BMP', 'BMP', 'BMP', 'Fixed-Time', 'Fixed-Time', 'Fixed-Time'};
alpha = 0.01;
beta_1 = 0.99;
beta_2 = 0.9;

%% Initialize recording vectors
total_qlen = zeros(simT, 1);
qlen_vector_trace = zeros(simT, N_links);
time_vec = 1:1:simT;

%% create link objects and intersection objects in Matlab
[all_links, all_intersections, mapObj, total_arrival_rate, service_count, qlen_weight] = init_test_network(saturation_flow, arrival_rate_scaling, policy);



%% File I/O
QL_Log_ID = fopen('test_queue_length_debug.log', 'w');
Pressure_Log_ID = fopen('test_pressure_debug.log', 'w');
Pressure_Log_Node1_ID = fopen('test_pressure_node1_debug.log', 'w');
QL_Log_Node1_ID = fopen('test_queue_length_node1_debug.log', 'w');
Pressure_Log_Node4_ID = fopen('test_pressure_node4_debug.log', 'w');
QL_Log_Node4_ID = fopen('test_queue_length_node4_debug.log', 'w');
Delay_Log_ID = fopen('test_Delay.log', 'a');
fprintf(QL_Log_ID, 'Time');
fprintf(Pressure_Log_ID, 'Time');
fprintf(Pressure_Log_Node1_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(QL_Log_Node1_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(Pressure_Log_Node4_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(QL_Log_Node4_ID, 'Time\t Decision\t Switchover\t Superframe-End\t Frame-Size');
fprintf(Delay_Log_ID, 'Policy: %s\t simT: %d\t Scaling: %.2f\n', policy, simT, arrival_rate_scaling);
for k=1:N_links
    fprintf(QL_Log_ID, '\t%d(%d)', k, all_links{k}.link_id); 
    fprintf(Pressure_Log_ID, '\t%d(%d)', k, all_links{k}.link_id); 
end

for k=1:length(all_intersections{1}.links_in)
    fprintf(Pressure_Log_Node1_ID, '\t %d', all_intersections{1}.links_in(k));
    fprintf(QL_Log_Node1_ID, '\t %d', all_intersections{1}.links_in(k)); 
end
%{
for k=1:length(all_intersections{4}.links_in)
    fprintf(Pressure_Log_Node4_ID, '\t %d', all_intersections{4}.links_in(k));
    fprintf(QL_Log_Node4_ID, '\t %d', all_intersections{4}.links_in(k)); 
end
%}
fprintf(QL_Log_ID, '\n');
fprintf(Pressure_Log_ID, '\n');
fprintf(Pressure_Log_Node1_ID, '\n'); 
fprintf(QL_Log_Node1_ID, '\n'); 
fprintf(Pressure_Log_Node4_ID, '\n'); 
fprintf(QL_Log_Node4_ID, '\n'); 

%% Slot-by-slot evolution
progress_count = 1;
N_points = 10;
for t=1:simT
    % Display the simulation progress
    if t >= simT*(progress_count/N_points)
        fprintf('Simulation Time: %d\n', t);
        progress_count = progress_count + 1;
    end
    % Reset Delta queue length vector
    Delta_qlen_vector = zeros(N_links, 1);

    % Debug log
    fprintf(QL_Log_ID, '%d', t);
    fprintf(Pressure_Log_ID, '%d', t);
    fprintf(Pressure_Log_Node1_ID, '%d', t);
    fprintf(QL_Log_Node1_ID, '%d', t);
    fprintf(Pressure_Log_Node4_ID, '%d', t);
    fprintf(QL_Log_Node4_ID, '%d', t);    
    % Update new arrivals to queue length vector
    for k=1:N_links
        if all_links{k}.is_entry == 1
            qlen_vector(k) = qlen_vector(k) + get_new_arrivals(all_links{k}.arrival_rate, arrival_mode);
        end
    end
    
    % Update superframe
    if t == tau_k
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
        % Manage service and routing
        for p=1:size(all_intersections{m}.phases, 2)
            if (all_intersections{m}.phase_state(p) == all_intersections{m}.GREEN)
                switchover_state(m) = 0;
                current_phase(m) = p;
                phase_temp = (all_intersections{m}.phases{p});
                for u=1:length(phase_temp)
                    link_matlab_id = cell2mat(values(mapObj,{phase_temp(u)}));
                    real_service = min(qlen_vector(link_matlab_id), all_links{link_matlab_id}.capacity); 
                    for v=1:real_service
                        next_link_id = all_links{link_matlab_id}.generate_next_route(mapObj);
                        if next_link_id > 0  % next_link_id <= 0 means the vehicle exits the network
                            Delta_qlen_vector(next_link_id) = Delta_qlen_vector(next_link_id) + 1;
                        end
                    end
                    Delta_qlen_vector(link_matlab_id) = Delta_qlen_vector(link_matlab_id) - real_service;
                end           
            end
        end

        %% Specify a scheduling policy
        switch policy
            case 'BMP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, F] = all_intersections{m}.bmp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, alpha, superframe_end);
            case 'Fixed-Time'
                [scheduled_phase_id, scheduled_phase, switchover_out] = all_intersections{m}.fixed_time(t);
            case 'MP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector] = all_intersections{m}.mp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, alpha);              
            case 'VFMP'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                frame_count(m) = updated_frame_count;
            case 'VFMW'
                [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmw(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                frame_count(m) = updated_frame_count;    
            case 'Mixed'
                if strcmp(policy_vec{m}, 'BMP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, F] = all_intersections{m}.bmp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, alpha, superframe_end);                     
                elseif strcmp(policy_vec{m}, 'Fixed-Time')
                    [scheduled_phase_id, scheduled_phase, switchover_out] = all_intersections{m}.fixed_time(t);
                elseif strcmp(policy_vec{m}, 'MP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector] = all_intersections{m}.mp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, alpha);
                elseif strcmp(policy_vec{m}, 'VFMP')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmp(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                    frame_count(m) = updated_frame_count;  
                elseif strcmp(policy_vec{m}, 'VFMW')
                    [scheduled_phase_id, scheduled_phase, weighted_pressure_vector, updated_frame_count] = all_intersections{m}.vfmw(qlen_vector, all_links, mapObj, pressure_vector, weight_vector, current_phase(m), weighted_pressure_vector, Ts, beta_2, frame_count(m), superframe_end);
                    frame_count(m) = updated_frame_count; 
                else
                    [scheduled_phase_id, scheduled_phase, switchover_out] = all_intersections{m}.fixed_time(t);
                end
            otherwise 
                [scheduled_phase_id, scheduled_phase, switchover_out] = all_intersections{m}.fixed_time(t);
        end
        if (switchover_state(m) == 0)
            phase_to_be_scheduled(m) = scheduled_phase_id;

            if current_phase(m) ~= phase_to_be_scheduled(m)
                amber_counter(m) = amber_length;
                allred_counter(m) = allred_length;
                switchover_state(m) = 1;
                switchover_count(m) = switchover_count(m) + 1;
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
                    all_intersections{m}.phase_state(n) = all_intersections{m}.AMBER;  % 3: green; 2: amber; 1: red
                else
                    all_intersections{m}.phase_state(n) = all_intersections{m}.RED;  % 3: green; 2: amber; 1: red
                end
            end
            amber_counter(m) = amber_counter(m) - 1;
        % all reds
        else if (amber_counter(m) == 0 && allred_counter(m) > 0)
            for n=1:size(all_intersections{m}.phases, 2)
                all_intersections{m}.phase_state(n) = all_intersections{m}.RED;  % 3: green; 2: amber; 1: red
            end
            allred_counter(m) = allred_counter(m) - 1;
        % green
            else
                for n=1:size(all_intersections{m}.phases, 2)
                    if n == phase_to_be_scheduled(m)  
                        all_intersections{m}.phase_state(n) = all_intersections{m}.GREEN;  % 3: green; 1: red
                    else
                        all_intersections{m}.phase_state(n) = all_intersections{m}.RED;  % 3: green; 1: red
                    end
                end 
                switchover_state(m) = 0;
                current_phase(m) = phase_to_be_scheduled(m);
                service_count{m}(current_phase(m)) = service_count{m}(current_phase(m)) + 1;
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
    %{
    for u=1:length(all_intersections{4}.links_in)
        lid = cell2mat(values(mapObj,{all_intersections{4}.links_in(u)}));
        fprintf(Pressure_Log_Node4_ID, '\t %.1f', weighted_pressure_vector(lid));  
        fprintf(QL_Log_Node4_ID, '\t %d', qlen_vector(lid));  
    end    
    %}
    fprintf(QL_Log_ID, '\n');
    fprintf(Pressure_Log_ID, '\n');
    fprintf(Pressure_Log_Node1_ID, '\n');  
    fprintf(QL_Log_Node1_ID, '\n');
    fprintf(Pressure_Log_Node4_ID, '\n');  
    fprintf(QL_Log_Node4_ID, '\n');  
    
    % Record simulation results
    total_qlen(t) = sum(qlen_vector);
    qlen_vector_trace(t,:) = qlen_vector;
    
    %% Update queue length vector with Delta queue length
    qlen_vector = max(0, qlen_vector + Delta_qlen_vector);  
   
end

%% Plotting and Outputting
%figure;
%hold on;
%plot(time_vec, total_qlen, '^-r');
%plot(time_vec, qlen_vector_trace(:,1), '^-b');
%plot(time_vec, qlen_vector_trace(:,2), '^-r');
%plot(time_vec, qlen_vector_trace(:,3), '^-g');
%plot(time_vec, qlen_vector_trace(:,4), '^-m');
createfigure_test(time_vec, qlen_vector_trace(:,1:2));
fprintf('Average Total Queue Length: %.2f\n', mean(total_qlen));
fprintf('Average Total Delay       : %.2f\n', mean(total_qlen)/total_arrival_rate);
fprintf(Delay_Log_ID, 'Average Total Queue Length: %.2f\n', mean(total_qlen));
fprintf(Delay_Log_ID, 'Average Total Delay       : %.2f\n', mean(total_qlen)/total_arrival_rate);
