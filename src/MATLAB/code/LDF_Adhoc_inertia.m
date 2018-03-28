function [decision, frame_next] = LDF_Adhoc_inertia(nPhase, feasible_phase, current_location, current_debt, beta)
%% Implement Largest Debt First Scheduling Policy with inertia
% Policy: max Q_i > (1+alpha)Q_current
    alpha = 1;  % Inertia
    weight = zeros(nPhase, 1);
    frame_next = 0;
    
    for i=1:nPhase
        weight(i) = sum(current_debt(feasible_phase{i}).*beta(feasible_phase{i}));        
    end

    if current_location > 0
        weight(current_location) = (1 + alpha)*weight(current_location);      
    end
    
    [val, decision] = max(weight);
    %if (sum(current_debt(feasible_phase{decision})) == 0)
        %decision = -1;       
    %end
        
end