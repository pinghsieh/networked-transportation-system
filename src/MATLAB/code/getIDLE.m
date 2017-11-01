function idle_time = getIDLE(IDLE_MAX, Q_length, CODE)
%% Calculate Idle time
% CODE = 0: idle_time = IDLE_MAX
% CODE = 1: idle_time = increasing concave function of queue length
idle_time = 0;
power = 0.3;
if CODE == 0
   idle_time = IDLE_MAX; 
    
else if CODE == 1
        idle_time = max(floor((Q_length)^power), 1);
    end
end
