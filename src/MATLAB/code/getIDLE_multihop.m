function idle_time = getIDLE_multihop(IDLE_MAX, Q_length, CODE)
%% Calculate Idle time
% CODE = 0: idle_time = IDLE_MAX
% CODE = 1: idle_time = increasing concave function of queue length
    idle_time = 0;
    power = 0.5;
    if CODE == 0
        idle_time = IDLE_MAX;     
    else
        if CODE == 1
            idle_time = max(floor((sum(Q_length))^power), 1);
        end
    end
end
