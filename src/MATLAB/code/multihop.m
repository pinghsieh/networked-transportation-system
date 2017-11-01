%%   Intelligent Signalized Intersection Project   
%    multihop.m | A network of connected intersections with multilpe entry links
%
%    Instructions
%    ------------
% 
%    This file contains code that helps you conduct simulation for
%    connected intersection with general arrival and service processes.
%    You will need to provide the following parameters
%
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
%%  Part I: Initialization
% 1. Register all intersections
% 2. Setup feasible phases for each intersection
% 3. Assign initial conditions
clear;

% System-wise parameters
simT = 100000;
iteration = 10;
currentT = 0;
IDLE_MAX = 1;
IDLE_ON = 1; % Flag for IDLE mode
CODE_IDLE = 0; % 0 for IDLE_MAX; 1 for increasing, concave function


%% Testbench #1
%{
nJunction = 2;
nLink = 7;
nQueue = 16;

% Specify initial number of jibs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [1, -1];
Endpoint_link{5} = [2, -1];
Endpoint_link{6} = [2, -1];
Endpoint_link{7} = [2, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3, 4];
Links_at_junction{2} = [3, 5, 6, 7];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 2 -1 -1 -1];
ID_map(2,:) = [3 -1 -1 4 -1 -1 -1];
ID_map(3,:) = [5 6 -1 -1 -1 9 10];
ID_map(4,:) = [-1 7 8 -1 -1 -1 -1];
ID_map(5,:) = [-1 -1 11 -1 -1 -1 12];
ID_map(6,:) = [-1 -1 13 -1 14 -1 -1];
ID_map(7,:) = [-1 -1 -1 -1 15 16 -1];

% ID of queues in each junction
ID_in_junction{1} = [1; 2; 3; 4; 5; 6; 7; 8];
ID_in_junction{2} = [9; 10; 11; 12; 13; 14; 15; 16];

% Specify the Bernoulli parameter of service process of each queue
prob_ON_channel = ones(nQueue, 1);

% turn_ratio specifies the probability of choosing (i->j) turn
turn_ratio = zeros(nLink, nLink);
turn_ratio(1,:) = [0 0 0.5 0.5 0 0 0];
turn_ratio(2,:) = [0.5 0 0 0.5 0 0 0];
turn_ratio(3,:) = [0.5 0.5 0 0 0 0.5 0.5];
turn_ratio(4,:) = [0 0.5 0.5 0 0 0 0];
turn_ratio(5,:) = [0 0 0.5 0 0 0 0.5];
turn_ratio(6,:) = [0 0 0.5 0 0.5 0 0];
turn_ratio(7,:) = [0 0 0 0 0.5 0.5 0];

% routing probability
routing_cdf = cell(nQueue);
routing_cdf{1} = [9 0.5; 10 1];
routing_cdf{8} = [9 0.5; 10 1];
routing_cdf{11} = [5 0.5; 6 1];
routing_cdf{13} = [5 0.5; 6 1];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.5; 0.5; 0.5; 0.5; 0; 0; 0.5; 0.5; 0; 0; 0.5; 0.5; 0.5; 0.5; 0.5; 0.5];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [[2; 1] [1; 5] [3; 4] [4; 7] [6; 5] [8; 7]];
feasible_phase{2} = [[10; 9] [9; 13] [11; 12] [12; 15] [14; 13] [16; 15]];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);
%}

%% Testbench 2
%{
nJunction = 2;
nLink = 6;
nQueue = 5;

% Specify initial number of jobs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [2, -1];
Endpoint_link{5} = [2, -1];
Endpoint_link{6} = [2, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3];
Links_at_junction{2} = [3, 4, 5, 6];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 -1 -1 -1];
ID_map(2,:) = [-1 -1 2 -1 -1 -1];
ID_map(3,:) = [-1 -1 -1 -1 3 4];
ID_map(4,:) = [-1 -1 -1 -1 5 -1];
ID_map(5,:) = [-1 -1 -1 -1 -1 -1];
ID_map(6,:) = [-1 -1 -1 -1 -1 -1];

% Specify the Bernoulli parameter of service process of each queue
prob_ON_channel = ones(nQueue, 1);

% ID of queues in each junction
ID_in_junction{1} = [1; 2];
ID_in_junction{2} = [3; 4; 5];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.4; 0.4; 0; 0; 0.15];

% routing probability
routing_cdf = cell(nQueue);
routing_cdf{1} = [3 0.5; 4 1];
routing_cdf{2} = [3 0.5; 4 1];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [1 2];
feasible_phase{2} = [3 4 5];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);

%}

%% Testbench 3
%{
nJunction = 2;
nLink = 6;
nQueue = 5;

% Specify initial number of jobs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [2, -1];
Endpoint_link{5} = [2, -1];
Endpoint_link{6} = [2, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3];
Links_at_junction{2} = [3, 4, 5, 6];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 -1 -1 -1];
ID_map(2,:) = [-1 -1 2 -1 -1 -1];
ID_map(3,:) = [-1 -1 -1 -1 3 4];
ID_map(4,:) = [-1 -1 -1 -1 5 -1];
ID_map(5,:) = [-1 -1 -1 -1 -1 -1];
ID_map(6,:) = [-1 -1 -1 -1 -1 -1];

% Specify the Bernoulli parameter of service process of each queue
prob_ON_channel = ones(nQueue, 1);

% ID of queues in each junction
ID_in_junction{1} = [1; 2];
ID_in_junction{2} = [3; 4; 5];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.4; 0.4; 0; 0; 0.15];

% routing probability
routing_cdf = cell(nQueue);
routing_cdf{1} = [3 0.5; 4 1];
routing_cdf{2} = [3 0.5; 4 1];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [1 2];
feasible_phase{2} = [[3; 4] [4; 5]];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);

%}

%% Testbench 4
%{
nJunction = 2;
nLink = 5;
nQueue = 4;

% Specify initial number of jobs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [2, -1];
Endpoint_link{5} = [2, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3];
Links_at_junction{2} = [3, 4, 5];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 -1 -1];
ID_map(2,:) = [-1 -1 -1 -1 -1];
ID_map(3,:) = [-1 4 -1 2 -1];
ID_map(4,:) = [-1 -1 -1 -1 -1];
ID_map(5,:) = [-1 -1 3 -1 -1];

% Specify the Bernoulli parameter of service process of each queue
%prob_ON_channel = ones(nQueue, 1);
prob_ON_channel = [1; 0.5; 1; 0.5];

% ID of queues in each junction
ID_in_junction{1} = [1; 4];
ID_in_junction{2} = [2; 3];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.3; 0; 0.3; 0];

% routing probability
routing_cdf = cell(nQueue);
routing_cdf{1} = [2 1];
routing_cdf{3} = [4 1];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [1 4];
feasible_phase{2} = [2 3];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);

%}
%% Testbench 5
%{
nJunction = 2;
nLink = 7;
nQueue = 6;

% Specify initial number of jobs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [2, -1];
Endpoint_link{5} = [2, -1];
Endpoint_link{6} = [2, -1];
Endpoint_link{7} = [1, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3, 7];
Links_at_junction{2} = [3, 4, 5, 6];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 -1 -1 -1 -1];
ID_map(2,:) = [-1 -1 2 -1 -1 -1 -1];
ID_map(3,:) = [-1 -1 -1 3 -1 -1 6];
ID_map(4,:) = [-1 -1 -1 -1 -1 -1 -1];
ID_map(5,:) = [-1 -1 4 -1 -1 -1 -1];
ID_map(6,:) = [-1 -1 5 -1 -1 -1 -1];
ID_map(7,:) = [-1 -1 -1 -1 -1 -1 -1];

% Specify the Bernoulli parameter of service process of each queue
%prob_ON_channel = ones(nQueue, 1);
prob_ON_channel = [0.5; 0.5; 0.5; 0.5; 0.5; 0.5];

% ID of queues in each junction
ID_in_junction{1} = [1; 4];
ID_in_junction{2} = [2; 3];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.45; 0.03; 0; 0.45; 0.03; 0];

% routing probability (cdf)
routing_cdf = cell(nQueue);
routing_cdf{1} = [3 1]; % [to which queue, cdf]
routing_cdf{2} = [3 1];
routing_cdf{4} = [6 1];
routing_cdf{5} = [6 1];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [[1; 6] [2; 6]];
feasible_phase{2} = [[3; 4] [3; 5]];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);
%}

%% Testbench 6
nJunction = 3;
nLink = 10;
nQueue = 14;

% Specify initial number of jobs in each queue
init_jobs = zeros(nQueue, 1);

% Specify the two endpoint s of a link; -1 implies that one of the ends is
% an exit/entry
Endpoint_link{1} = [1, -1]; 
Endpoint_link{2} = [1, -1];
Endpoint_link{3} = [1, 2];
Endpoint_link{4} = [2, -1];
Endpoint_link{5} = [2, -1];
Endpoint_link{6} = [2, -1];
Endpoint_link{7} = [1, -1];

% Specify the links connected to each junction
Links_at_junction{1} = [1, 2, 3, 7];
Links_at_junction{2} = [3, 4, 5, 6];

% Specify Q(i,j)->Q*(ID) mapping
ID_map = zeros(nLink, nLink);
ID_map(1,:) = [-1 -1 1 -1 -1 -1 -1];
ID_map(2,:) = [-1 -1 2 -1 -1 -1 -1];
ID_map(3,:) = [-1 -1 -1 3 -1 -1 6];
ID_map(4,:) = [-1 -1 -1 -1 -1 -1 -1];
ID_map(5,:) = [-1 -1 4 -1 -1 -1 -1];
ID_map(6,:) = [-1 -1 5 -1 -1 -1 -1];
ID_map(7,:) = [-1 -1 -1 -1 -1 -1 -1];

% Specify the Bernoulli parameter of service process of each queue
%prob_ON_channel = ones(nQueue, 1);
prob_ON_channel = [0.5; 0.5; 0.5; 0.5; 0.5; 0.5];

% ID of queues in each junction
ID_in_junction{1} = [1; 4];
ID_in_junction{2} = [2; 3];

% Specify the external input probability (suppose Bernoulli arrivals)
prob_arrival = [0.45; 0.03; 0; 0.45; 0.03; 0];

% routing probability (cdf)
routing_cdf = cell(nQueue);
routing_cdf{1} = [3 1]; % [to which queue, cdf]
routing_cdf{2} = [3 1];
routing_cdf{4} = [6 1];
routing_cdf{5} = [6 1];

% Specify the non-conflicting movements in a slot for each junction
feasible_phase{1} = [[1; 6] [2; 6]];
feasible_phase{2} = [[3; 4] [3; 5]];

% Weighting factor of VFMW policy
beta = ones(nQueue, 1);

%% Part II: Control Phase
% 1. Determine scheduling decisions for all intersections
%

% Record average statistics
history_jobs_average = zeros(nQueue, simT);
switching_count_junction_average = zeros(nJunction, simT);
cumulative_service_average = zeros(nQueue, 1);
history_mean_jobs_average = zeros(nQueue, simT);
history_frame_remained_average = zeros(nJunction, simT);
history_wasted_slots_average = zeros(nJunction, simT);
history_wasted_service_average = zeros(nJunction, simT);

% *************** Run simulation ***************
for i = 1:iteration
    % Step 1: Initialization
    current_service_rate = zeros(nQueue, 1);
    switching_count_junction = zeros(nJunction, simT);
    cumulative_service = zeros(nQueue, 1);
    cumulative_arrival = zeros(nQueue, 1);
    server_location = zeros(nJunction, 1);   % specify the phase of each junction
    idle = zeros(nJunction, 1);
    frame_remained = zeros(nJunction, 1); 
    current_jobs = init_jobs;
    incoming_jobs = zeros(nQueue, 1);  % To record the incoming jobs during the current slot, either due to routing or exogenous arrival
    history_jobs = zeros(nQueue, simT);
    history_location = zeros(nJunction, simT);
    history_mean_jobs = zeros(nQueue, simT);
    history_wasted_slots = zeros(nJunction, simT);
    history_wasted_service = zeros(nJunction, simT);
    history_frame_remained = zeros(nJunction, simT);
    
    for t = 1:simT
        currentT = t;
        % Update channel conditions for each queue
        current_service_rate = get_potential_service(prob_ON_channel);
                 
        % Reset incoming jobs vector
        incoming_jobs = zeros(nQueue, 1);
        
        % Determine scheduling decisions for each junction
        [decision, frame_remained] = VFMW_multihop(nJunction, feasible_phase, server_location, current_jobs, frame_remained, ID_in_junction, beta);
        
        % Record the remained frame for debugging
        history_frame_remained(:, t) = frame_remained;
        
        % Make corresponding changes based on decision and the remained frame
        % sizes
        if t > 1
            switching_count_junction(:, t) = switching_count_junction(:, t-1); 
            history_location(:, t) = history_location(:, t-1);
            history_wasted_slots(:, t) = history_wasted_slots(:, t-1);
            % Debugging
            history_wasted_service(:, t) = history_wasted_service(:, t-1);
        end
        for j=1:nJunction
            phase_in_junction = feasible_phase{j};
            if idle(j) == 0 
                if decision(j) > 0
                    if (server_location(j) ~= decision(j)) && (IDLE_ON == 1) % If switchover happens
                        idle(j) = getIDLE_multihop(IDLE_MAX, current_jobs(phase_in_junction(:, decision(j))), CODE_IDLE) - 1;
                        switching_count_junction(j, t) = switching_count_junction(j, t) + 1;
                    else
                        if (server_location(j) ~= decision(j)) % If no switchover effect
                            switching_count_junction(j, t) = switching_count_junction(j, t) + 1;
                        end
                        % Debugging
                        history_wasted_slots(j, t) = history_wasted_slots(j, t-1) + (prod(current_jobs(phase_in_junction(:, decision(j)))) == 0);
                        history_wasted_service(j, t) = history_wasted_service(j, t-1) + (sum(current_jobs(phase_in_junction(:, decision(j)))) == 0);
                        
                        actual_service = zeros(nQueue, 1);                    
                        cumulative_service(phase_in_junction(:, decision(j))) = cumulative_service(phase_in_junction(:, decision(j))) + current_service_rate(phase_in_junction(:, decision(j)));
                        actual_service(phase_in_junction(:, decision(j))) = min(current_jobs(phase_in_junction(:, decision(j))), current_service_rate(phase_in_junction(:, decision(j))));                      
                        current_jobs(phase_in_junction(:, decision(j))) = max(current_jobs(phase_in_junction(:, decision(j))) - current_service_rate(phase_in_junction(:, decision(j))), 0);
                        frame_remained(j) = max(frame_remained(j) - 1, 0);
                        
                        % Handle routing
                        nMovement = size(phase_in_junction(:, decision(j))); 
                        for k=1:nMovement(1)
                            routing_required = size(routing_cdf{phase_in_junction(k, decision(j))}); % check if routing is required for this movement
                            if (routing_required(1) > 0)
                                routing_info = routing_cdf{phase_in_junction(k, decision(j))}; % routing_info includes routes and probability
                                incoming_jobs(routing_info(:,1)) = incoming_jobs(routing_info(:,1)) + get_routing(routing_info, actual_service(phase_in_junction(k, decision(j))));
                            end
                        end
                    end
                    server_location(j) = decision(j);
                    history_location(j, t) = server_location(j);
                end
            else
                idle(j) = idle(j) -1;   
            end
        end
        
        % New exogenous arrivals
        arrival_in_this_slot = get_exo_arrival(prob_arrival);
        cumulative_arrival = cumulative_arrival + arrival_in_this_slot; 
        incoming_jobs = incoming_jobs + arrival_in_this_slot;
        current_jobs = current_jobs + incoming_jobs;
        history_jobs(:,t) = current_jobs;  
        if t > 1
            history_mean_jobs(:,t) = (history_mean_jobs(:,t-1)*(t-1) + current_jobs)/t;
        else
            history_mean_jobs(:,t) = current_jobs/t;
        end
    end
    
    % Collecting data in current iteration
    switching_count_junction_average = switching_count_junction_average + switching_count_junction;
    cumulative_service_average = cumulative_service_average + cumulative_service;
    history_jobs_average = history_jobs_average + history_jobs;
    history_mean_jobs_average = history_mean_jobs_average + history_mean_jobs;
    history_wasted_slots_average = history_wasted_slots_average + history_wasted_slots;
    history_wasted_service_average = history_wasted_service_average + history_wasted_service;
    history_frame_remained_average = history_frame_remained_average + history_frame_remained;
end


%% Part III: Plot the simulation results

    switching_count_junction_average = switching_count_junction_average/iteration;
    cumulative_service_average = cumulative_service_average/iteration;
    history_jobs_average = history_jobs_average/iteration;
    history_mean_jobs_average = history_mean_jobs_average/iteration;
    history_wasted_slots_average  = history_wasted_slots_average/iteration;
    history_wasted_service_average = history_wasted_service_average/iteration;
    history_frame_remained_average = history_frame_remained_average/iteration;

    time = 1:simT;
    createfigure_multi(time, history_mean_jobs_average);
    createfigure2(time, switching_count_junction_average);    

%% Part IV: Debugging 

    createfigure(time, history_jobs_average);
    createfigure_single(time, history_location); 
    createfigure_single(time, history_frame_remained_average);  
    createfigure_single(time, history_wasted_slots_average);
    createfigure_single(time, history_wasted_service_average);

    for i=1:nQueue
        fprintf('Queue %d: (%d) \n', i, history_mean_jobs_average(i, simT));
    end    

    for j=1:nJunction
        fprintf('Total # switching of junction %d: %d \n', j, switching_count_junction_average(j, simT));
    end
    
%% End of file 