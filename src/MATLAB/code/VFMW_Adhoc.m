function [decision, frame_next] = VFMW_Adhoc(nPhase, feasible_phase, current_location, current_jobs, frame_remained, average_rate, beta, power)
%% Implement Variable Frame-Based Max-Weight Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
    leading_factor = 1;
    frame_next = 0;
    
    weight = zeros(nPhase, 1);
    for i=1:nPhase
        weight(i) = sum((current_jobs(feasible_phase{i}).*average_rate(feasible_phase{i})).*beta(feasible_phase{i}));
    end
    if current_location > 0
        if frame_remained > 0
        %if frame_remained > 0 && prod(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location;
            frame_next = frame_remained;
        else
            [val, decision] = max(weight);
            if sum(current_jobs(feasible_phase{decision})) == 0
                decision = -1;
            else
                frame_next = floor(leading_factor*((sum(current_jobs))^power)); % Determine frame size
                %frame_next = floor(leading_factor*((sum(current_jobs((feasible_phase{decision})))^power)));% Determine frame size
            end
        end
    else
        [val, decision] = max(weight);
        if sum(current_jobs(feasible_phase{decision})) == 0
            decision = -1;
        else
            frame_next = floor(leading_factor*((sum(current_jobs))^power)); % Determine frame size 
            %frame_next = floor(leading_factor*((sum(current_jobs((feasible_phase{decision})))^power))); 
        end 
    end
