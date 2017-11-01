function decision = maxHoLage_Ex_Adhoc(nPhase, feasible_phase, current_location, current_jobs, age, lambda)
%% Implement Variable Frame-Based Max HoL Age Scheduling Exhaustive Policy
% pressure: pressure matrix of dimension nLink-by-1
    weight = zeros(nPhase, 1);
    for i=1:nPhase
        weight(i) = sum(age(feasible_phase{i}).*lambda(feasible_phase{i}));
    end

    if current_location > 0
        if prod(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location; 
        else
        % If one of the active flows becomes empty, make a new decision (Is this correct?)
            %[val, decision] = max((average_rate.*age).*lambda);
            [val, decision] = max(weight);
            if weight(decision) == 0
                decision = -1;
            end
        end
    else
        %[val, decision] = max((average_rate.*age).*lambda);
        [val, decision] = max(weight);
        if weight(decision) == 0
            decision = -1;
        end 
    end    

