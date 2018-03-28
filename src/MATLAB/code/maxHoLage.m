function decision = maxHoLage(current_rate, age, lambda)
%% Implement Max-Head-of-Line Age Scheduling Policy
% age: age matrix of dimension nLink-by-1
% lambda: lambda factor matrix of dimension nLink-by-1
% current_rate: current_rate matrix of dimension nLink-by-1

    %weight = (lambda.*age) - (age == 0);
    weight = ((current_rate.*age).*lambda) - (age == 0);
    [val, decision] = max(weight);
    if val <= 0
        decision = -1;
    end
