function [decision, frame_next] = VFTSLS_Adhoc(nPhase, feasible_phase, current_location, current_jobs, frame_remained, TSLS, lambda)
%% Implement Variable Frame-Based Max-Weight Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
    power = 0.9;
    leading_factor = 1;
    frame_next = 0;
    
    weight = zeros(nPhase, 1);
    %mean_weight = zeros(nPhase, 1);
    for i=1:nPhase
        weight(i) = sum(TSLS(feasible_phase{i}).*lambda(feasible_phase{i}));
        %weight(i) = max(TSLS(feasible_phase{i}).*lambda(feasible_phase{i}));
        %weight(i) = min(TSLS(feasible_phase{i}).*lambda(feasible_phase{i}));
        %weight(i) = prod(TSLS(feasible_phase{i}).*lambda(feasible_phase{i}) + 1);
        %weight(i) = sum(sqrt(TSLS(feasible_phase{i}).*lambda(feasible_phase{i})));
        %{
        TSLS_lambda = TSLS(feasible_phase{i}).*lambda(feasible_phase{i});
        mean_weight(i) = mean(TSLS_lambda);
        TSLS_lambda_ofs = TSLS_lambda - mean_weight(i);
        weight(i) = sum(TSLS_lambda) - sum(abs(TSLS_lambda_ofs));
        %}
    end
    if current_location > 0
        %if frame_remained > 0
        if frame_remained > 0 && prod(current_jobs(feasible_phase{current_location})) > 0
            decision = current_location;
            frame_next = frame_remained;
        else
            [val, decision] = max(weight);
            if sum(current_jobs(feasible_phase{decision})) == 0
                decision = -1;
            else
                frame_next = floor(leading_factor*((sum(current_jobs))^power)); % Determine frame size
                %frame_next = floor(leading_factor*((sum(current_jobs((feasible_phase{decision})))^power)));% Determine frame size
            end
        end
    else
        [val, decision] = max(weight);
        if sum(current_jobs(feasible_phase{decision})) == 0
            decision = -1;
        else
            frame_next = floor(leading_factor*((sum(current_jobs))^power)); % Determine frame size 
            %frame_next = floor(leading_factor*((sum(current_jobs((feasible_phase{decision})))^power))); 
        end 
    end
