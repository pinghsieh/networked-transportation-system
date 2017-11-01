%%   Intelligent Signalized Intersection Project   
%    network_cont.m | An continuous-time isolated intersection with multilpe entry links
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

% System-wise parameters
simT = 1000;
Nsteps = 100;
sizeStep = simT/Nsteps;
iteration = 1;
currentT = 0;
nLink = 2;
rate_arrival = [0.5; 0.5];
mean_inter_arrival = 1./rate_arrival;
IDLE_MAX = 1;

% i.i.d. inter-Service time model
rate_service = [1; 1];
mean_service_time = 1./rate_service;
% Assume initially empty
init_jobs = [0; 0];

% Record average statistics
history_jobs_average = zeros(nLink, Nsteps);
switching_count_average = zeros(nLink, Nsteps);
cumulative_service_average = zeros(nLink, Nsteps);
history_mean_jobs_average = zeros(nLink, Nsteps);

%% =========== Part 2: Run Simulation =============
for i = 1:iteration
    % Initialization
    switching_count = zeros(nLink, Nsteps);
    cumulative_service = zeros(nLink, Nsteps);
    server_location = 0;
    time_to_idle_completion = 0;
    time_to_next_arrival = zeros(nLink, 1);
    time_to_service_completion = zeros(nLink, 1);
    frame_remained = 0;
    % Record current jobs
    current_jobs = init_jobs;
    history_jobs = zeros(nLink, Nsteps);
    history_location = zeros(1, Nsteps);
    history_mean_jobs = zeros(nLink, Nsteps);
    history_frame_remained = zeros(1, Nsteps);
    
    while t < simT
        currentT = t;
        
        if t == 0
            time_to_next_arrival = exprnd(mean_inter_arrival);
            time_to_service_completion = (init_jobs > 0).*exprnd(mean_service_time);
        end
        % Find next upcoming event: new arrival/ new service completion/
        % or a new idling completion 
        [min_next_arrival, id_next_arrival] = min(time_to_next_arrival);
        [min_service_completion, id_serv = min(time_to_service_completion);

        if (min_next_arrival <= min_service_completion)
            if (min_next_arrival <= time_to_idle_completion) && (time_to_idle_completion > 0)
        % 1. Next event is an arrival
                t = t + min_next_arrival;
            end
            
        end
        % 2. Next event is a service completion
        
        % 3. Next event is an idling completion
        
        % Update channel conditions
        current_service_rate = (prob_on_channel >= (unifrnd(0, 1, nLink, 1)));
   
        % Scheduling decision
        %decision = maxWeight(current_service_rate, current_jobs);
        decision = exhaustive(server_location, current_jobs);
        %[decision, frame_remained] = VFMW(server_location, current_jobs, frame_remained, prob_on_channel, idle);
        history_frame_remained(1, t) = frame_remained;
        if t > 1
            switching_count(:, t) = switching_count(:, t-1); 
            history_location(1, t) = history_location(1, t-1);
        end
        if idle == 0
            if decision > 0
                if server_location ~= decision
                    idle = IDLE_MAX;
                    switching_count(decision, t) = switching_count(decision, t) + 1;
                else
                    cumulative_service(decision, 1) = cumulative_service(decision, 1) + current_service_rate(decision, 1);
                    current_jobs(decision , 1) = max(current_jobs(decision, 1) - current_service_rate(decision, 1),0);

                end
                server_location = decision;
                history_location(1, t) = server_location;
            end
        else
            idle = idle - 1;
        end
        % New arrivals
        current_jobs = current_jobs + (prob_arrival >= (unifrnd(0, 1, nLink, 1)));
        history_jobs(:,t) = current_jobs; 
        if t > 1
            history_mean_jobs(:,t) = (history_mean_jobs(:,t-1)*(t-1) + current_jobs)/t;
        else
            history_mean_jobs(:,t) = current_jobs/t;
        end

    end
    % Collecting data in current iteration
    switching_count_average = switching_count_average + switching_count;
    cumulative_service_average = cumulative_service_average + cumulative_service;
    history_jobs_average = history_jobs_average + history_jobs;
    history_mean_jobs_average = history_mean_jobs_average + history_mean_jobs;
end
