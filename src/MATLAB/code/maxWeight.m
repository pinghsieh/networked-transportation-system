function decision = maxWeight(current_rate, pressure, beta)
%% Implement Max-Weight Scheduling Policy
% current_rate: rate matrix of dimension nLink-by-1
% pressure: pressure matrix of dimension nLink-by-1

    %weight = (current_rate.*pressure) - (current_rate == 0) - (pressure == 0);
    weight = (current_rate.*pressure).*beta - (current_rate == 0) - (pressure == 0);
    [val, decision] = max(weight);
    if val < 0
        decision = -1;
    end
