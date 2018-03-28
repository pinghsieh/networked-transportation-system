function [decision, frame_next] = SCB_Adhoc(nPhase, feasible_phase, current_location, current_jobs, frame_remained, average_rate, beta, IDLE_ON, IDLE_MAX, power)
%% Implement Switching-Curve Based Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
    leading_factor = 1;
    frame_next = 0;
    weight = zeros(nPhase, 1);
    extra = (leading_factor*((sum(current_jobs))^power));    
    for i=1:nPhase
        %extra = (leading_factor*((sum(current_jobs(feasible_phase{i})))^power));  
        if i == current_location 
            weight(i) = extra + (sum(current_jobs(feasible_phase{i}).*beta(feasible_phase{i})));
        else
            weight(i) = (sum(current_jobs(feasible_phase{i}).*beta(feasible_phase{i})));
        end
    end
    if current_location > 0
        %if frame_remained > 0
        %if frame_remained > 0 && prod(current_jobs(feasible_phase{current_location})) > 0
        if frame_remained > 0 && sum(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location;
            frame_next = frame_remained;
        else
            [val, decision] = max(weight);
            if sum(current_jobs(feasible_phase{decision})) == 0
                decision = -1;
            else
                if (IDLE_ON == 1)
                    frame_next = 1;
                else
                    frame_next = 0;    
                end
            end
        end
    else
        [val, decision] = max(weight);
        if sum(current_jobs(feasible_phase{decision})) == 0
            decision = -1;
        else
            if (IDLE_ON == 1)
                frame_next = 1;
            else
                frame_next = 0;
            end
        end 
    end
end
