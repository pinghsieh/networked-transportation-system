function [decision, frame_next] = VFMW_TSLSx(current_location, pressure, frame_remained, average_rate, current_TSLS, gamma)
%% Implement Variable Frame-Based Max-Weight Scheduling Policy
% pressure: pressure matrix of dimension nLink-by-1
% Frame size depends only on the queue length of active flows
    power = 0.9;
    leading_factor = 1;
    frame_next = 0;
    if current_location > 0
        if frame_remained > 0
            decision = current_location;
            frame_next = frame_remained;
        else
            [val, decision] = max(average_rate.*(pressure + gamma*current_TSLS).*(pressure > 0));
            if pressure == 0
                decision = -1;
            else
                frame_next = floor(leading_factor*((pressure(decision))^power)); % Determine frame size
            end
        end
    else
        [val, decision] = max(average_rate.*(pressure + gamma*current_TSLS).*(pressure > 0));
        if pressure == 0
            decision = -1;
        else
            frame_next = floor(leading_factor*((pressure(decision))^power)); % Determine frame size 
        end 
    end
