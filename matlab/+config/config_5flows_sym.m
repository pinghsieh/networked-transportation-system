%% Configuration
% 5 flows, 1 movement in each schedule
N_flows = 5;
N_schedules = 5;
N_arrivals = 50000;
simT = 10000;
nRun = 1;
Age_default = 5;

arrival_type = "Bernoulli";
arrival_rate = 0.199;
arg{1} = arrival_rate*ones(N_flows, 1);
penetration_ratio = 0.1;

policy = 'max-hol-age';
%policy = 'max-queue-length';