function decision = MaxWeight_Ex(current_location, pressure, average_rate, beta)
%% Implement Max-TSLS Exhaustive Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
% TSLS: time-since-last-service matrix of dimension nLink-by-1
    weight = (average_rate.*pressure).*beta;
    if current_location > 0
        if pressure(current_location) > 0
            decision = current_location; 
        else
            [val, decision] = max(weight);
            if pressure(decision) == 0
                decision = -1;
            end
        end
    else
        [val, decision] = max(weight);
        if pressure(decision) == 0
            decision = -1;
        end 
    end
