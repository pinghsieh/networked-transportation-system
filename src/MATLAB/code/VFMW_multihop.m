function [decision, frame_next] = VFMW_multihop(nJunction, feasible_phase, current_location, current_jobs, frame_remained, ID_in_junction, beta)
%% Implement the Variable-frame MaxWeight scheduling policy
% Make decisions junction by junction
% decision, frame_next are both nJunction-by-1 vectors
    power = 0.5;
    leading_factor = 1;
    frame_next = zeros(nJunction, 1);
    decision = zeros(nJunction, 1);
    
    for j=1:nJunction
        pSize = size(feasible_phase{j});
        nPhase = pSize(2);
        weight = zeros(nPhase, 1);
        phase_in_junction = feasible_phase{j};
        
        for i=1:nPhase
            weight(i) = sum(current_jobs(phase_in_junction(:,i)).*beta(phase_in_junction(:,i)));
        end
        
        if current_location(j) > 0
            %if frame_remained(j) > 0
            if frame_remained(j) > 0 && sum(current_jobs(phase_in_junction(:,current_location(j)))) > 0
                decision(j) = current_location(j);
                frame_next(j) = frame_remained(j);
            else
                [val, decision(j)] = max(weight);
                if sum(current_jobs(phase_in_junction(:,decision(j)))) == 0
                    decision(j) = -1;
                else
                    frame_next(j) = floor(leading_factor*((sum(current_jobs(ID_in_junction{j})))^power)); % Determine frame size
                    %frame_next(j) = floor(leading_factor*((sum(current_jobs(phase_in_junction(:, decision(j)))))^power));% Determine frame size
                end
            end
        else
            [val, decision(j)] = max(weight);
            if sum(current_jobs(phase_in_junction(:, decision(j)))) == 0
                decision(j) = -1;
            else
                frame_next(j) = floor(leading_factor*((sum(current_jobs(ID_in_junction{j})))^power)); % Determine frame size
                %frame_next(j) = floor(leading_factor*((sum(current_jobs(phase_in_junction(:, decision(j)))))^power));% Determine frame size
            end 
        end
    end
end