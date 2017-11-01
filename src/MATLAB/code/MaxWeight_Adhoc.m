function [decision, frame_next] = MaxWeight_Adhoc(nPhase, feasible_phase, current_location, current_jobs, frame_remained, average_rate, beta)
%% Implement Max-TSLS Exhaustive Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
% TSLS: time-since-last-service matrix of dimension nLink-by-1
    weight = zeros(nPhase, 1);
    frame_min = 1;
    frame_next = 0;
    for i=1:nPhase
        weight(i) = sum(current_jobs(feasible_phase{i}).*beta(feasible_phase{i}));
    end
    if frame_remained > 0 && sum(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location;
            frame_next = frame_remained;
    else
        [val, decision] = max(weight);
        if sum(current_jobs(feasible_phase{decision})) == 0
            decision = -1;
        else
            if decision == current_location 
                frame_next  = 1;
            else
                frame_next = frame_min;
            end
        end
    end
end
