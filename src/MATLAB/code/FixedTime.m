function decision = FixedTime (nPhase, cycle, split, current_tid)
%% Produce fixed-time schedules
% cycle: cycle length (switchover not included)
% split: # of slots for each phase (N-by-1 array)
% current_cid: the current time id in the cycle (starts from 1)
% Example:  cycle = 48
%           split = [6 24 30 48]
    tid = mod(current_tid, cycle);
    decision = 0;
    for i=1:nPhase
        if tid < split(i)
            decision = i; 
            break;
        end
    end
end 