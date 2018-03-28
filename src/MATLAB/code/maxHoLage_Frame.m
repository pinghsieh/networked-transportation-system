function [decision, frame_next] = maxHoLage_Frame(current_location, pressure, frame_remained, average_rate, age, lambda)
%% Implement Variable Frame-Based Max-Weight Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
    power = 0.9;
    leading_factor = 1;
    frame_next = 0;
    if current_location > 0
        if frame_remained > 0
            decision = current_location;
            frame_next = frame_remained;
        else
            [val, decision] = max((average_rate.*age).*lambda);
            if val == 0
                decision = -1;
            else
                frame_next = floor(leading_factor*((pressure(decision))^power)); % Determine frame size
            end
        end
    else
        [val, decision] = max((average_rate.*age).*lambda);
        if val == 0
            decision = -1;
        else
            frame_next = floor(leading_factor*((pressure(decision))^power)); % Determine frame size 
        end 
    end
