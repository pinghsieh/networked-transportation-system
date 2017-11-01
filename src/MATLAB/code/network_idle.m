%%   Intelligent Signalized Intersection Project   
%    network.m | An isolated intersection with multilpe entry links
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
simT = 200000;
iteration = 10;
currentT = 0;
nLink = 2;
prob_arrival = [0.242; 0.242];
IDLE_MAX = 1;
% i.i.d. ON/OFF channel model
prob_on_channel = [0.5; 0.5];

% Gilbert-Elliot Markovian channel model


% Assume initially empty
init_jobs = [0; 0];

% Record average statistics
history_jobs_average = zeros(nLink, simT);
switching_count_average = zeros(nLink, simT);
cumulative_service_average = zeros(nLink, simT);
history_mean_jobs_average = zeros(nLink, simT);
history_wasted_slots_average = zeros(1, simT);

%% =========== Part 2: Run Simulation =============
for i = 1:iteration
    % Initialization
    current_service_rate = zeros(nLink, 1);
    switching_count = zeros(nLink, simT);
    cumulative_service = zeros(nLink, simT);
    server_location = 0;
    idle = 0;
    frame_remained = 0;
    % Record current jobs
    current_jobs = init_jobs;
    history_jobs = zeros(nLink, simT);
    history_location = zeros(1, simT);
    history_mean_jobs = zeros(nLink, simT);
    history_frame_remained = zeros(1, simT);
    history_wasted_slots = zeros(1, simT);
    for t = 1:simT
        currentT = t;
        % Update channel conditions
        current_service_rate = (prob_on_channel >= (unifrnd(0, 1, nLink, 1)));
   
        % Scheduling decision
        %decision = maxWeight(current_service_rate, current_jobs);
        %decision = exhaustive(server_location, current_jobs);
        [decision, frame_remained] = VFMW2(server_location, current_jobs, frame_remained, prob_on_channel);
        history_frame_remained(1, t) = frame_remained;
        if t > 1
            switching_count(:, t) = switching_count(:, t-1); 
            history_location(1, t) = history_location(1, t-1);
            history_wasted_slots(1, t) = history_wasted_slots(1, t-1);
        end
        if idle == 0
            if decision > 0
                if server_location ~= decision
                    idle = IDLE_MAX - 1;
                    switching_count(decision, t) = switching_count(decision, t) + 1;
                else
                    % Debugging
                    history_wasted_slots(1, t) = history_wasted_slots(1, t-1) + (current_jobs(decision, 1) == 0);

                    cumulative_service(decision, 1) = cumulative_service(decision, 1) + current_service_rate(decision, 1);
                    current_jobs(decision , 1) = max(current_jobs(decision, 1) - current_service_rate(decision, 1),0);
                    frame_remained = max(frame_remained - 1, 0);

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
    history_wasted_slots_average = history_wasted_slots_average + history_wasted_slots;
end

%% =========== Part 3: Post-Processing =============
% 
    switching_count_average = switching_count_average/iteration;
    cumulative_service_average = cumulative_service_average/iteration;
    history_jobs_average = history_jobs_average/iteration;
    history_mean_jobs_average = history_mean_jobs_average/iteration;
    
    time = 1:simT;
    createfigure(time, history_mean_jobs_average);
    createfigure2(time, switching_count_average);



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
    createfigure_single(time, history_location);    
    %createfigure_single(time, history_frame_remained);  
    createfigure_single(time, history_wasted_slots_average);
%    
%% End of file   