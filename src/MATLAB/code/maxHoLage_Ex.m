function decision = maxHoLage_Ex(current_location, pressure, average_rate, age, lambda)
%% Implement Variable Frame-Based Max-Weight Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1

    if current_location > 0
        if pressure(current_location) > 0
            decision = current_location; 
        else
            %[val, decision] = max((average_rate.*age).*lambda);
            [val, decision] = max(age.*lambda);
            if pressure(decision) == 0
                decision = -1;
            end
        end
    else
        %[val, decision] = max((average_rate.*age).*lambda);
        [val, decision] = max(age.*lambda);
        if pressure(decision) == 0
            decision = -1;
        end 
    end    

