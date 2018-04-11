classdef my_matlab_intersection < matlab.mixin.SetGet
    %% Properties
    % links_in: a cell of the indices of links incident at the intersection 
    % phases: a cell of sets of link indices indicating feasible phases
    % Note: phase corresponds to a group in VISSIM
    properties
        links_in 
        phases
        phase_state
        N_links
        N_phases
        RED
        AMBER
        GREEN
        green_start
        green_end
        cycle
        offset
        Frame_Size
    end
    methods
        %% Constructor
        function obj = my_matlab_intersection(links_in,phases, green_start, green_end, cycle, offset)
            obj.RED = 1;
            obj.AMBER = 2;
            obj.GREEN = 3;
            obj.links_in = links_in; 
            obj.phases = phases;
            obj.N_links = length(links_in); % Get number of links
            sz = size(phases);
            obj.N_phases = sz(2); % Get number of phases
            obj.phase_state = obj.RED*ones(obj.N_phases, 1); % Initialize phase states
            obj.phase_state(1) = obj.GREEN;
            obj.green_start = green_start;
            obj.green_end = green_end;
            obj.cycle = cycle;
            obj.offset = offset;
            obj.Frame_Size = 0;
        end
        
        %% Biased Max-Pressure policy
        % qlen_vector is a N_link-by-1 vector of queue length of each link
        function [phase_id, scheduled_phase, weighted_pressure, F] = bmp(obj, qlen_vector, all_links, mapObj, pressure, weight, current_phase, weighted_pressure, Ts, alpha, superframe_end)
            %weighted_pressure = zeros(length(pressure),1);
            pressure_per_phase = zeros(obj.N_phases,1);
            biased_pressure_per_phase = zeros(obj.N_phases,1);
            weighted_qlen_vector = qlen_vector.*weight;
            for i=1:obj.N_links
                current_link_matlab_id = cell2mat(values(mapObj,{obj.links_in(i)}));
                current_link = all_links{current_link_matlab_id};
                ds_links = get(current_link,'downstream_links');
                x = weighted_qlen_vector(cell2mat(values(mapObj,{obj.links_in(i)}))) - (transpose(get(current_link,'routing_ratio'))*weighted_qlen_vector(cell2mat(values(mapObj,ds_links))));
                pressure(current_link_matlab_id) = x;
                weighted_pressure(current_link_matlab_id) = x*current_link.capacity;
            end

            links_matlab_id = cell2mat(values(mapObj,num2cell(obj.links_in)));
            %F = 1;  % assume F is constant, to be modified
            C0 = 10;
            F = max(1, power(max(0,sum(weighted_pressure(links_matlab_id))), alpha));
            for j=1:obj.N_phases
                pressure_per_phase(j) = sum(weighted_pressure(cell2mat(values(mapObj,num2cell(obj.phases{j}))))); 
                biased_pressure_per_phase(j) = (1 + (current_phase == j)*Ts*C0/F)*(max(0.1,pressure_per_phase(j)));
            end

            % Check superframe
            if superframe_end == 0
                [val, phase_id] = max(biased_pressure_per_phase);
            else
                [val, phase_id] = max(pressure_per_phase);   
            end
            scheduled_phase = obj.phases{phase_id};            

        end
        
        %% Variable-Frame Max-Pressure
        function [phase_id, scheduled_phase, weighted_pressure, updated_frame_count] = vfmp(obj, qlen_vector, all_links, mapObj, pressure, weight, current_phase, weighted_pressure, Ts, beta_2, frame_count, superframe_end)
            links_matlab_id = cell2mat(values(mapObj,num2cell(obj.links_in)));
            pressure_per_phase = zeros(obj.N_phases,1);
            weighted_qlen_vector = qlen_vector.*weight;
            for i=1:obj.N_links
                current_link_matlab_id = cell2mat(values(mapObj,{obj.links_in(i)}));
                current_link = all_links{current_link_matlab_id};
                ds_links = get(current_link,'downstream_links');
                x = weighted_qlen_vector(cell2mat(values(mapObj,{obj.links_in(i)}))) - (transpose(get(current_link,'routing_ratio'))*weighted_qlen_vector(cell2mat(values(mapObj,ds_links))));
                pressure(current_link_matlab_id) = x;
                weighted_pressure(current_link_matlab_id) = x*current_link.capacity;
            end
            for j=1:obj.N_phases
                pressure_per_phase(j) = sum(weighted_pressure(cell2mat(values(mapObj,num2cell(obj.phases{j}))))); 
            end
            if superframe_end == 1
                obj.Frame_Size = Ts + floor(power(sum(qlen_vector(links_matlab_id)),beta_2));
            end
            if frame_count <= 0
                updated_frame_count = obj.Frame_Size;           
                [val, phase_id] = max(pressure_per_phase); 
                scheduled_phase = obj.phases{phase_id}; 
            else
                phase_id = current_phase;
                scheduled_phase = obj.phases{phase_id};
                updated_frame_count = frame_count - 1;
            end
        end 
        %% Variable-Frame Max-Weight
        function [phase_id, scheduled_phase, weighted_pressure, updated_frame_count] = vfmw(obj, qlen_vector, all_links, mapObj, pressure, weight, current_phase, weighted_pressure, Ts, beta_2, frame_count, superframe_end)
            links_matlab_id = cell2mat(values(mapObj,num2cell(obj.links_in)));
            pressure_per_phase = zeros(obj.N_phases,1);
            weighted_qlen_vector = qlen_vector.*weight;
            for i=1:obj.N_links
                current_link_matlab_id = cell2mat(values(mapObj,{obj.links_in(i)}));
                current_link = all_links{current_link_matlab_id};
                %ds_links = get(current_link,'downstream_links');
                x = weighted_qlen_vector(cell2mat(values(mapObj,{obj.links_in(i)})));
                pressure(current_link_matlab_id) = x;
                weighted_pressure(current_link_matlab_id) = x*current_link.capacity;
            end
            for j=1:obj.N_phases
                pressure_per_phase(j) = sum(weighted_pressure(cell2mat(values(mapObj,num2cell(obj.phases{j}))))); 
            end
            %if superframe_end == 1
             %   obj.Frame_Size = Ts + floor(power(sum(qlen_vector(links_matlab_id)),beta_2));
            %end
            if frame_count <= 0
                obj.Frame_Size = Ts + floor(power(sum(qlen_vector(links_matlab_id)),beta_2));
                updated_frame_count = obj.Frame_Size;           
                [val, phase_id] = max(pressure_per_phase); 
                scheduled_phase = obj.phases{phase_id}; 
                
            else
                phase_id = current_phase;
                scheduled_phase = obj.phases{phase_id};
                updated_frame_count = frame_count - 1;
            end
        end
		
        %% Fixed-Time Policy
        function [phase_id, scheduled_phase, switchover] = fixed_time(obj, currentT)
            remainder = mod(currentT + obj.offset, obj.cycle);
            phase_id = 1;
            scheduled_phase = obj.phases{phase_id};
            switchover = 0;
            for i=1:obj.N_phases
                if i == obj.N_phases
                    next_phase_green_start = 1;
                else
                    next_phase_green_start = obj.green_start(i+1);
                end
                
                if (remainder >= obj.green_start(i)) && (remainder <= obj.green_end(i))
                    phase_id = i;
                    scheduled_phase = obj.phases{phase_id};
                    switchover = 0;
                    break
                else if (remainder > obj.green_end(i)) && remainder <= next_phase_green_start
                        if i == obj.N_phases
                            phase_id = 1;  % Go back to phase 1
                        else
                            phase_id = i+1;  % Go to next phase
                        end
                        scheduled_phase = obj.phases{phase_id};
                        switchover = 1;
                        break
                    end
                end
                
            end
        end
        %% Max-Pressure policy
        % qlen_vector is a N_link-by-1 vector of queue length of each link
        function [phase_id, scheduled_phase, weighted_pressure] = mp(obj, qlen_vector, all_links, mapObj, pressure, weight, current_phase, weighted_pressure, Ts, alpha)
            %weighted_pressure = zeros(length(pressure),1);
            pressure_per_phase = zeros(obj.N_phases,1);
            for i=1:obj.N_links
                current_link_matlab_id = cell2mat(values(mapObj,{obj.links_in(i)}));
                current_link = all_links{current_link_matlab_id};
                ds_links = get(current_link,'downstream_links');
                x = qlen_vector(cell2mat(values(mapObj,{obj.links_in(i)}))) - (transpose(get(current_link,'routing_ratio'))*qlen_vector(cell2mat(values(mapObj,ds_links))));
                %disp(['Size of x is ' num2str(size(x))]);
                %disp(['x is ' num2str(x)]);
                pressure(current_link_matlab_id) = x;
                weighted_pressure(current_link_matlab_id) = x*current_link.capacity;
            end
            %links_matlab_id = cell2mat(values(mapObj,num2cell(obj.links_in)));
            for j=1:obj.N_phases
                pressure_per_phase(j) = sum(weighted_pressure(cell2mat(values(mapObj,num2cell(obj.phases{j}))))); 
            end
            
            [val, phase_id] = max(pressure_per_phase);
            scheduled_phase = obj.phases{phase_id};
        end
        %% g-Adaptive Max-Weight policy
        % qlen_vector is a N_link-by-1 vector of queue length of each link
        % Under this policy, pressure = queue length
        function [phase_id, scheduled_phase, weighted_qlen_vector] = gAdaptiveMW(obj, qlen_vector, all_links, mapObj, pressure, weight, current_phase, weighted_pressure, gamma, delta)        
            pressure_per_phase = zeros(obj.N_phases,1);
            %links_matlab_id = cell2mat(values(mapObj,num2cell(obj.links_in)));
            weighted_qlen_vector = qlen_vector.*weight;
            for i=1:obj.N_links
                current_link_matlab_id = cell2mat(values(mapObj,{obj.links_in(i)}));
                current_link = all_links{current_link_matlab_id};
                x = weighted_qlen_vector(cell2mat(values(mapObj,{obj.links_in(i)})));
                pressure(current_link_matlab_id) = x;
                weighted_pressure(current_link_matlab_id) = x*current_link.capacity; % TODO: Do we still need this?
            end
            for j=1:obj.N_phases
                pressure_per_phase(j) = sum(weighted_pressure(cell2mat(values(mapObj,num2cell(obj.phases{j}))))); 
            end
            [max_pressure_per_phase, phase_id] = max(pressure_per_phase);
            delta_weight_per_phase = max_pressure_per_phase - pressure_per_phase(current_phase);
            if delta_weight_per_phase < gfunc(gamma, delta, max_pressure_per_phase)
                phase_id = current_phase;
            end
            scheduled_phase = obj.phases{phase_id};
        end
    end
end