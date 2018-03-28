function decision = MaxWeight_Ex_Adhoc(nPhase, feasible_phase, current_location, current_jobs, average_rate, beta)
%% Implement Max-TSLS Exhaustive Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
% TSLS: time-since-last-service matrix of dimension nLink-by-1
    weight = zeros(nPhase, 1);
    for i=1:nPhase
        weight(i) = sum(current_jobs(feasible_phase{i}).*beta(feasible_phase{i}));
    end
    
    if current_location > 0
        if prod(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location; 
        else
            [val, decision] = max(weight);
            if sum(current_jobs(feasible_phase{decision})) == 0
                decision = -1;
            end
        end
    else
        [val, decision] = max(weight);
        if sum(current_jobs(feasible_phase{decision})) == 0
            decision = -1;
        end 
    end
