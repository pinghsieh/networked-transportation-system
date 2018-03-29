%%   Intelligent Signalized Intersection Project   
%    network_adhoc2.m | An isolated intersection with multilpe entry links
%    modeled as an ad-hoc network
%
%    Instructions
%    ------------
% 
%    This file contains code that helps you conduct simulation for an
%    isolated intersection with general arrival and servicce processes.
%    You will need to provide the following parameters
%
%    nLink: number of links pointing to the intersection 
%    cdf_interArrival: Distribution of inter-arrival times (nLink x 1)
%    cdf_interService: Distribution of inter-service times (nLink x 1)
%    capQueue: Capacity of each queues
%    simT: total simulation time
%
%    Remark:
%    1. Discrete vs continuous
%    2. Single vs multiple server
%    3. Policy
%    4. Channel
%    5. Conflict graph

%%   Design Guidelines
%    Here are the main functions:
%


%% =========== Part 1: Setup an isolated intersection =============
clear;
% Corresponds to single-server case

% System-wise parameters
simT = 50000;
iteration = 2;
currentT = 0;

%% Cell arrays for feasible phases
%{
% Setting #1
nLink = 8; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
prob_arrival = [0.2; 0.3; 0.3; 0.4; 0.1; 0.2; 0.1; 0.2];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}

% Setting #2
%{
nLink = 8; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
%prob_arrival = [0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
prob_arrival = [0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
%beta = [5; 1; 5; 2.5; 5; 1; 5; 2.5];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}

% Setting #3
%{
nLink = 8; 
nPhase = 8;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
feasible_phase{7} = [1 6];
feasible_phase{8} = [2 5];
prob_arrival = [0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
%prob_arrival = [0.15; 0.5; 0.1; 0.2; 0.1; 0.55; 0.1; 0.2];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
%beta = [5; 1; 5; 2.5; 5; 1; 5; 2.5];
%{
beta_matrix{1} = [1; 1];
beta_matrix{2} = [1; 1];
beta_matrix{3} = [1; 1];
beta_matrix{4} = [1; 1];
beta_matrix{5} = [1; 1];
beta_matrix{6} = [1; 1];
beta_matrix{7} = 2;
beta_matrix{8} = 2;
%}

lambda_matrix{1} = [1; 1];
lambda_matrix{2} = [1; 1];
lambda_matrix{3} = [1; 1];
lambda_matrix{4} = [1; 1];
lambda_matrix{5} = [1; 1];
lambda_matrix{6} = [1; 1];
lambda_matrix{7} = 1;
lambda_matrix{8} = 1;

lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}
%}

% Setting #4
%{
nLink = 3; 
nPhase = 2;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
prob_arrival = [0.01; 0.995; 0.01];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}
% Setting #5
%{
nLink = 4;
nPhase = 3;
feasible_phase{1} = [1 2];
feasible_phase{2} = 3;
feasible_phase{3} = 4;
%feasible_phase{4} = 4;
prob_arrival = [0.3; 0.3; 0.3; 0.3];
beta = [1; 1; 1; 1];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
%}

% Setting #6
%{
nLink = 4;
nPhase = 4;
feasible_phase{1} = 1;
feasible_phase{2} = 2;
feasible_phase{3} = 3;
feasible_phase{4} = 4;
prob_arrival = [0.5; 0.3; 0.15; 0.05];
beta = [1; 1; 1; 1];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
%}

% Setting #7
%{
nLink = 4; 
nPhase = 4;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [1 4]; 
prob_arrival = [0.65; 0.9; 0.35; 0.1];
beta = [1; 1; 1; 1];
%beta = [5; 1; 5; 2.5];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
%}
% Setting #8
%{
nLink = 4; 
nPhase = 4;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [2 4]; 
feasible_phase{4} = [1 4]; 
prob_arrival = [0.65; 0.95; 0.3; 0.1];
beta = [1; 1; 1; 1];
%beta = [5; 1; 5; 2.5];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
%}

% Setting #9
%{
nLink = 8; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
prob_arrival = [0.03; 0.48; 0.15; 0.3; 0.06; 0.51; 0.12; 0.27];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
%beta = [5; 1; 5; 2.5; 5; 1; 5; 2.5];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}

% Setting #9
%{
nLink = 3; 
nPhase = 2;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
prob_arrival = [0.1; 0.995; 0.1];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}
% Setting #10
%{
nLink = 3; 
nPhase = 3;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [1 3];
prob_arrival = [0.3; 0.75; 0.85];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}
% Setting #11
%{
nLink = 3; 
nPhase = 3;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [1 3];
prob_arrival = [0.02; 0.94; 0.94];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}
% Setting #12
%{
nLink = 3; 
nPhase = 3;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [1 3];
prob_arrival = [0.64; 0.64; 0.64];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}
% Setting #13
%{
nLink = 3; 
nPhase = 2;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
prob_arrival = [0.1; 0.98; 0.1];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}

% Setting #14
%{
nLink = 3; 
nPhase = 3;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 3]; 
feasible_phase{3} = [1 3];
prob_arrival = (99/96)*[0.06; 0.93; 0.93];
beta = [1; 1; 1];
lambda = [1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1];
init_jobs = [0; 0; 0];
%}


% Setting #15
%{
nLink = 8; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
%prob_arrival = [0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
prob_arrival = (19/18)*[0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
%beta = [5; 1; 5; 2.5; 5; 1; 5; 2.5];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}
% Setting #16
%{
nLink = 8; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 4]; 
feasible_phase{4} = [4 8]; 
feasible_phase{5} = [5 6]; 
feasible_phase{6} = [7 8];
%prob_arrival = [0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
prob_arrival = (99/90)*[0.1; 0.5; 0.1; 0.2; 0.1; 0.5; 0.1; 0.2];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
%beta = [5; 1; 5; 2.5; 5; 1; 5; 2.5];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
%}
% Setting #17
%{
nLink = 4; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [1 3]; 
feasible_phase{3} = [1 4]; 
feasible_phase{4} = [2 3]; 
feasible_phase{5} = [2 4]; 
feasible_phase{6} = [3 4];
prob_arrival = (96/96)*[0.06; 0.62; 0.62; 0.62];
beta = [1; 1; 1; 1];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
%}

% Setting #18

nLink = 4; 
nPhase = 6;
feasible_phase{1} = [1 2]; 
feasible_phase{2} = [1 3]; 
feasible_phase{3} = [1 4]; 
feasible_phase{4} = [2 3]; 
feasible_phase{5} = [2 4]; 
feasible_phase{6} = [3 4];
prob_arrival = (96/96)*[0.03; 0.63; 0.63; 0.63];
beta = [1; 1; 1; 1];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];

% Setting #19
%{
nLink = 8; 
nPhase = 4;
feasible_phase{1} = [1 5]; 
feasible_phase{2} = [2 6]; 
feasible_phase{3} = [3 7]; 
feasible_phase{4} = [4 8]; 
prob_arrival = 0.9*[0.125; 0.375; 0.125; 0.375; 0.125; 0.375; 0.125; 0.375];
beta = [1; 1; 1; 1; 1; 1; 1; 1];
lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];
init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];
cycle = 48; % For fixed-time scheduling
split = [6; 24; 30; 48]; %For fixed-time scheduling
%}
% Setting #20
%{
nLink = 4; 
nPhase = 4;
feasible_phase{1} = 1; 
feasible_phase{2} = 2; 
feasible_phase{3} = 3; 
feasible_phase{4} = 4; 
prob_arrival = 0.85*[0.125; 0.375; 0.125; 0.375];
beta = [1; 1; 1; 1];
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
prob_on_channel = [1; 1; 1; 1];
init_jobs = [0; 0; 0; 0];
cycle = 48; % For fixed-time scheduling
split = [6; 24; 30; 48]; %For fixed-time scheduling
%}

%% Arrival processes
%prob_arrival = [0.12375; 0.12375; 0.12375; 0.12375];
%prob_arrival = [0.1225; 0.1225; 0.1225; 0.1225];
%prob_arrival = [0.25; 0.125; 0.0625; 0.05];
%prob_arrival = [0.5; 0.25; 0.125; 0.1];
%prob_arrival = [0.3; 0.3; 0.15; 0.15];
%prob_arrival = [0.4; 0.3; 0.15; 0.05];
%prob_arrival = [0.123; 0.123; 0.123; 0.123];
%prob_arrival = [0.2; 0.2; 0.04; 0.04];
%prob_arrival = [0.245; 0.245];
%prob_arrival = [0.9; 0.09];
%prob_arrival = [0.49; 0.49];
%prob_arrival = [0.1; 0.1; 0.1; 0.1; 0.1; 0.1; 0.1; 0.1];
IDLE_MAX = 1;
IDLE_ON = 1; % Flag for IDLE mode
CODE_IDLE = 0; % 0 for IDLE_MAX; 1 for increasing, concave function
gamma = 1; % For TSLS
%beta = [1; 1]; % For MW & Weighted VFMW
%beta = [1; 1; 1; 1]; % For MW & Weighted VFMW
%beta = [1; 1; 1; 1]; % For MW & Weighted VFMW
%beta = [1; 1; 1; 1; 1; 1; 1; 1]; % For MW & Weighted VFMW
%lambda = [1; 1]; % For max-HoL-age policy
%lambda = [1; 1; 1; 2]; % For max-HoL-age policy
%lambda = [1; 1; 1; 1; 1; 1; 1; 1]; % For max-HoL-age policy

% i.i.d. ON/OFF channel model
%prob_on_channel = [0.5; 0.5; 0.5; 0.5];
%prob_on_channel = [1; 1; 1; 1];
%prob_on_channel = [0.5; 0.5];
%prob_on_channel = [1; 1];
%prob_on_channel = [1; 1; 1; 1; 1; 1; 1; 1];

% Gilbert-Elliot Markovian channel model


% Assume initially empty
%init_jobs = [0; 0; 0; 0];
%init_jobs = [0; 0];
%init_jobs = [0; 0; 0; 0; 0; 0; 0; 0];

% Record average statistics
history_jobs_average = zeros(nLink, simT);
switching_count_average = zeros(nLink, simT);
switching_count_phase_average = zeros(nPhase, simT);
cumulative_service_average = zeros(nLink, 1);
history_mean_jobs_average = zeros(nLink, simT);
history_wasted_slots_average = zeros(1, simT);
history_wasted_service_average = zeros(1, simT);
history_TSLS_average = zeros(nLink, simT);
history_mean_TSLS_average = zeros(nLink, simT);
history_HoL_age_average = zeros(nLink, simT);
history_mean_HoL_age_average = zeros(nLink, simT);
history_HoL_age_average_phase = zeros(nPhase, simT);
history_jobs_phase_average = zeros(nPhase, simT);
history_frame_remained_average = zeros(1, simT);
history_debt_average = zeros(nLink, simT);

%% =========== Part 2: Run Simulation =============
for i = 1:iteration
    % Initialization
    current_service_rate = zeros(nLink, 1);
    %switching_count = zeros(nLink, simT);
    switching_count_phase = zeros(nPhase, simT);
    cumulative_service = zeros(nLink, 1);
    server_location = 0;
    idle = 0;
    frame_remained = 0;
    power = 0.9;
    action = 1; % 1 means incrementing "power" and -1 means decrementing "power"
    % Record current jobs
    current_jobs = init_jobs;
    current_TSLS = zeros(nLink, 1);
    current_debt = init_jobs;
    history_jobs = zeros(nLink, simT);
    history_location = zeros(1, simT);
    history_mean_jobs = zeros(nLink, simT);
    history_frame_remained = zeros(1, simT);
    history_wasted_slots = zeros(1, simT);
    history_wasted_service = zeros(1, simT);
    history_TSLS = zeros(nLink, simT);
    history_mean_TSLS = zeros(nLink, simT);
    history_debt = zeros(nLink, simT);
    % For Head-of-Line simulation
    timestamp_of_arriving_jobs = zeros(nLink, simT); % May have overflow problem?
    HoL_pointer = ones(nLink, 1);
    HoL_age = zeros(nLink, 1); % If no job in the queue, HoL_age = 0
    HoL_age_prev = zeros(nLink, 1); % If no job in the queue, HoL_age = 0
    cumulative_arrival = zeros(nLink, 1);
    history_HoL_age = zeros(nLink, simT);
    history_mean_HoL_age = zeros(nLink, simT);
    
    % For Ad-Hoc networks: initialization
    current_jobs_phase = zeros(nPhase, 1);
    history_jobs_phase = zeros(nPhase, simT);
    
    % For maximum frame size
    frame_count = 0;
    history_frame_count = zeros(1, simT);
    
    % For fixed-time scheduling
    history_current_tid = zeros(1, simT);
    current_tid = 1;
    
    % Added field
    frame_track = 0;
    
    for m=1:nPhase
        current_jobs_phase(m, 1) = sum(init_jobs(feasible_phase{m}));
    end
        
    for t = 1:simT
        currentT = t;
        % Update channel conditions
        current_service_rate = (prob_on_channel >= (unifrnd(0, 1, nLink, 1)));
             
        % Update HoL age
        HoL_age_prev = HoL_age;
        for j=1:nLink
            HoL_age(j,1) = (timestamp_of_arriving_jobs(j, HoL_pointer(j,1)) > 0)*(t - timestamp_of_arriving_jobs(j, HoL_pointer(j,1)));
            %HoL_age(j,1) = HoL_age(j,1) - 1*(timestamp_of_arriving_jobs(j, HoL_pointer(j,1)) == 0);
        end
        history_HoL_age(:,t) = HoL_age;
        
        % Update HoL age history: count/not count slots with empty queue
        if t > 1
            %history_mean_HoL_age(:,t) = (history_mean_HoL_age(:,t-1)*(t-1) + HoL_age)/t;
            history_mean_HoL_age(:,t) = (history_mean_HoL_age(:,t-1)*(t-1) + HoL_age)./((t-1) + (HoL_age > 0));
        else
            history_mean_HoL_age(:,t) = HoL_age/t;
        end
        
        % Update current tid
        history_current_tid(1,t) = current_tid; 
        
       
        % Scheduling decision: "decision" is a set of links
        %decision = maxWeight(current_service_rate, current_jobs, beta);
        %decision = maxHoLage(current_service_rate, HoL_age, lambda);
        %decision = exhaustive(server_location, current_jobs);
        %decision = MaxWeight_Ex(server_location, current_jobs, prob_on_channel, beta);
        %decision = Max_TSLS_Ex(server_location, current_jobs, current_TSLS, lambda);
        %[decision, frame_remained] = VFMW(server_location, current_jobs, frame_remained, prob_on_channel, beta);
        %[decision, frame_remained] = maxHoLage_Frame(server_location, current_jobs, frame_remained, prob_on_channel, HoL_age, lambda);
        %decision = maxHoLage_Ex_Adhoc(nPhase, feasible_phase, server_location, current_jobs, HoL_age, lambda);
        %decision = MaxWeight_Ex_Adhoc(nPhase, feasible_phase, server_location, current_jobs, prob_on_channel, beta);
        %decision = MaxTSLS_Ex_Adhoc(nPhase, feasible_phase, server_location, current_jobs, current_TSLS, beta);
        %[decision, frame_remained] = VFTSLS_Adhoc(nPhase, feasible_phase, server_location, current_jobs, frame_remained, current_TSLS, lambda);
        %[decision, frame_remained] = VFMW_Adhoc(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta);
        %decision = MaxWeight_Adhoc(nPhase, feasible_phase, server_location, current_jobs, prob_on_channel, beta);       
        %[decision, frame_remained] = VFMW_Adhoc_diff(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta, IDLE_ON, IDLE_MAX);
        %[decision, frame_remained] = VFMW_Adhoc_ext(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta_matrix);
        %[decision, frame_remained] = VFMaxHoL_Adhoc(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda, IDLE_ON);
        %[decision, frame_remained] = VFMaxHoL_Adhoc_diff(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda, IDLE_ON, IDLE_MAX);
        %[decision, frame_remained] = VFMaxHoL_Adhoc_small(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda, IDLE_ON, IDLE_MAX);
        %[decision, frame_remained, action, power] = VFMaxHoL_Adhoc_adapt(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda, power, action, HoL_age_prev);
        %[decision, frame_remained] = VFMaxHoL_Adhoc_ext(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda_matrix);
        %[decision, frame_remained] = VFMWx(server_location, current_jobs, frame_remained, prob_on_channel, beta);
        %[decision, frame_remained] = VFMW_TSLS(server_location, current_jobs, frame_remained, prob_on_channel, current_TSLS, gamma);
        %[decision, frame_remained] = VFMW_TSLSx(server_location, current_jobs, frame_remained, prob_on_channel, current_TSLS, gamma);
        %[decision, frame_remained] = MW_Adhoc_inertia(nPhase, feasible_phase, server_location, current_jobs, beta);
        %[decision, frame_remained] = MWLA_Adhoc(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta, IDLE_ON, IDLE_MAX);
        %[decision, frame_remained] = LDF_Adhoc_inertia(nPhase, feasible_phase, server_location, current_debt, beta);
        %[decision, frame_remained] = MaxHoL_Adhoc_inertia(nPhase, feasible_phase, server_location, current_jobs, HoL_age, lambda);
        %decision = FixedTime(nPhase, cycle, split, current_tid);
        %[decision, frame_remained, frame_track] = VFMW_Adhoc_diff_lim(nPhase, feasible_phase, server_location, current_jobs, frame_remained, HoL_age, lambda, IDLE_ON, IDLE_MAX, frame_count);
        %[decision, frame_remained, frame_track] = MaxWeight_Adhoc_lim(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta, frame_count);
        [decision, frame_remained] = gAdaptiveMW(nPhase, feasible_phase, server_location, current_jobs, frame_remained, prob_on_channel, beta, IDLE_ON, IDLE_MAX);
        
        % Count the length of the current schedule
        frame_count = frame_track;
 
        % Update frame count
        history_frame_count(1,t) = frame_count;
        
        % Update time since last service
        current_TSLS = current_TSLS + ones(nLink, 1);
        
        history_frame_remained(1, t) = frame_remained;
        if t > 1
            switching_count_phase(:, t) = switching_count_phase(:, t-1); 
            history_location(1, t) = history_location(1, t-1);
            history_wasted_slots(1, t) = history_wasted_slots(1, t-1);
            % Debugging
            history_wasted_service(1, t) = history_wasted_service(1, t-1);
        end
        if idle == 0
            if decision > 0
                if (server_location ~= decision) && (IDLE_ON == 1)
                    idle = getIDLE(IDLE_MAX, current_jobs_phase(decision, 1), CODE_IDLE) - 1;
                    switching_count_phase(decision, t) = switching_count_phase(decision, t) + 1;
                    current_debt = subplus(current_debt);
                else
                    if (server_location ~= decision)
                        switching_count_phase(decision, t) = switching_count_phase(decision, t) + 1;
                        current_debt = subplus(current_debt);
                    end
                    % Debugging
                    history_wasted_slots(1, t) = history_wasted_slots(1, t-1) + (prod(current_jobs(feasible_phase{decision})) == 0);
                    history_wasted_service(1, t) = history_wasted_service(1, t-1) + sum((current_jobs(feasible_phase{decision})) == 0);

                    % Update HoL pointer
                    HoL_pointer(feasible_phase{decision}) = HoL_pointer(feasible_phase{decision}) + min(current_jobs(feasible_phase{decision}), current_service_rate(feasible_phase{decision}));
                    
                    cumulative_service(feasible_phase{decision}) = cumulative_service(feasible_phase{decision}) + current_service_rate(feasible_phase{decision});
                    current_jobs(feasible_phase{decision}) = max(current_jobs(feasible_phase{decision}) - current_service_rate(feasible_phase{decision}),0);
                    frame_remained = max(frame_remained - 1, 0);
                    
                    % Update debt
                    current_debt(feasible_phase{decision}) = current_debt(feasible_phase{decision}) - current_service_rate(feasible_phase{decision});
                    
                    % Update current_tid for fixed-time scheduling
                    current_tid = current_tid + 1;
                end
                server_location = decision;
                history_location(1, t) = server_location;
                current_TSLS(feasible_phase{decision}) = 0;
            end
        else
            idle = idle - 1;
        end
        
        % Update TSLS history
        history_TSLS(:, t) = current_TSLS; 
        if t > 1
            history_mean_TSLS(:,t) = (history_mean_TSLS(:,t-1)*(t-1) + current_TSLS)/t;
        else
            history_mean_TSLS(:,t) = current_TSLS/t;
        end
        
        % New arrivals
        arrival_in_this_slot = (prob_arrival >= (unifrnd(0, 1, nLink, 1)));
        cumulative_arrival = cumulative_arrival + arrival_in_this_slot; 
        current_jobs = current_jobs + arrival_in_this_slot;
        history_jobs(:,t) = current_jobs; 
        current_debt = current_debt + arrival_in_this_slot;
        history_debt(:,t) = current_debt; 
       
        % Add timestamp of the new arrival
        for k=1:nLink
            if (cumulative_arrival(k,1) > 0) && (timestamp_of_arriving_jobs(k, cumulative_arrival(k,1)) == 0)
                timestamp_of_arriving_jobs(k, cumulative_arrival(k,1)) = t;
            end
        end
        
        if t > 1
            history_mean_jobs(:,t) = (history_mean_jobs(:,t-1)*(t-1) + current_jobs)/t;
        else
            history_mean_jobs(:,t) = current_jobs/t;
        end

        % Update current jobs of a phase
        for m=1:nPhase
            current_jobs_phase(m, 1) = sum(current_jobs(feasible_phase{m}));
        end
        
        history_jobs_phase(:,t) = current_jobs_phase;

    end
    % Collecting data in current iteration
    switching_count_phase_average = switching_count_phase_average + switching_count_phase;
    cumulative_service_average = cumulative_service_average + cumulative_service;
    history_jobs_average = history_jobs_average + history_jobs;
    history_mean_jobs_average = history_mean_jobs_average + history_mean_jobs;
    history_wasted_slots_average = history_wasted_slots_average + history_wasted_slots;
    history_wasted_service_average = history_wasted_service_average + history_wasted_service;
    history_TSLS_average = history_TSLS_average + history_TSLS;
    history_mean_TSLS_average = history_mean_TSLS_average + history_mean_TSLS;
    history_HoL_age_average = history_HoL_age_average + history_HoL_age;
    history_mean_HoL_age_average = history_mean_HoL_age_average + history_mean_HoL_age;
    history_jobs_phase_average = history_jobs_phase_average + history_jobs_phase;
    history_frame_remained_average = history_frame_remained_average + history_frame_remained;
    history_debt_average = history_debt_average + history_debt;
end

%% =========== Part 3: Post-Processing =============
% 
    switching_count_average = switching_count_average/iteration;
    switching_count_phase_average = switching_count_phase_average/iteration;
    cumulative_service_average = cumulative_service_average/iteration;
    history_jobs_average = history_jobs_average/iteration;
    history_jobs_phaseaverage = history_jobs_phase_average/iteration;
    history_mean_jobs_average = history_mean_jobs_average/iteration;
    history_mean_TSLS_average = history_mean_TSLS_average/iteration;
    history_TSLS_average = history_TSLS_average/iteration;
    history_wasted_slots_average = history_wasted_slots_average/iteration;
    history_wasted_service_average = history_wasted_service_average/iteration;
    history_HoL_age_average = history_HoL_age_average/iteration;
    history_mean_HoL_age_average = history_mean_HoL_age_average/iteration;
    history_frame_remained_average = history_frame_remained_average/iteration;
    history_debt_average = history_debt_average/iteration;
    for h=1:nPhase
        history_HoL_age_average_phase(h,:) = sum(history_HoL_age_average(feasible_phase{h},:)); 
    end
    
    time = 1:simT;
    createfigure(time, history_mean_jobs_average);
    createfigure2(time, switching_count_phase_average);

%{
    figure; hold on;    
    for i = 1:nLink
        plot(time, history_jobs_average(i,:), 'LineWidth', 3);
    end
    hold off;
    figure; hold on;
    for i = 1:nLink
        plot(time, switching_count_average(i,:), 'LineWidth', 3);
    end
    hold off;
    figure; hold on;
    for i = 1:nLink
        plot(time, history_mean_jobs_average(i,:), 'LineWidth', 3);
    end
%}
%{    
    hold off;
    figure; hold on;
    plot(time, history_location_average(1,:), ' ');
%}
  
%% Debugging
    createfigure(time, history_jobs_average);
    %createfigure_single(time, history_location);    
    %createfigure_single(time, history_frame_remained_average);  
    createfigure_single(time, history_wasted_slots_average);
    %createfigure_single(time, history_wasted_service_average);
    %createfigure_single(time, history_current_tid);
    %createfigure_single(time, history_frame_count);
    %createfigure3(time, history_mean_TSLS_average);
    %createfigure4(time, history_HoL_age_average);
    %createfigure4(time, history_mean_HoL_age_average);
    %createfigure4(time, history_HoL_age_average_phase);
    %createfigure3(time, history_TSLS_average);
    %createfigure(time, history_jobs_phase_average);
    %createfigure(time, history_debt_average);
    
    for i=1:nLink
        fprintf('Answer %d: (%d, %d, %d, %d) \n', i, history_mean_jobs_average(i, simT), switching_count_average(i, simT), history_mean_TSLS_average(i, simT), history_mean_HoL_age_average(i, simT));
        %fprintf('Answer 2: (%d, %d, %d) \n', history_mean_jobs_average(2, simT), switching_count_average(2, simT), history_mean_TSLS_average(2, simT));
        %fprintf('Answer 3: (%d, %d, %d) \n', history_mean_jobs_average(3, simT), switching_count_average(3, simT), history_mean_TSLS_average(3, simT));
        %fprintf('Answer 4: (%d, %d, %d) \n', history_mean_jobs_average(4, simT), switching_count_average(4, simT), history_mean_TSLS_average(4, simT));
    end
    fprintf('Answer 0: (%d, %d, %d) \n', sum(history_mean_jobs_average(:, simT))/nLink, sum(switching_count_average(:, simT))/nLink, sum(history_mean_TSLS_average(:, simT))/nLink);
    fprintf('Total # switching: %d \n', sum(switching_count_phase_average(:, simT)));
    fprintf('Total average delay: %d \n', sum(history_mean_jobs_average(:,simT))/sum(prob_arrival));
%    
%% End of file   