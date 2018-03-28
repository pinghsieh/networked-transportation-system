function decision = exhaustive(current_location, pressure)
%% Implement Exhaustive Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
    if current_location > 0
        if pressure(current_location) > 0
            decision = current_location; 
        else
            [val, decision] = max(pressure);
            if val == 0
                decision = -1;
            end
        end
    else
        [val, decision] = max(pressure);
        if val == 0
            decision = -1;
        end 
    end
