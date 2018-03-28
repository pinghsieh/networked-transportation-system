%%   Intelligent Signalized Intersection Project   
%    network_fair.m | An isolated intersection with multilpe entry links
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
simT = 20000;
iteration = 1;
currentT = 0;
nLink = 4;
%nLink = 2;
%prob_arrival = [0.12375; 0.12375; 0.12375; 0.12375];
%prob_arrival = [0.1225; 0.1225; 0.1225; 0.1225];
%prob_arrival = [0.25; 0.125; 0.0625; 0.05];
%prob_arrival = [0.5; 0.25; 0.125; 0.1];
%prob_arrival = [0.3; 0.3; 0.15; 0.15];
prob_arrival = [0.4; 0.3; 0.15; 0.05];
%prob_arrival = [0.123; 0.123; 0.123; 0.123];
%prob_arrival = [0.2; 0.2; 0.04; 0.04];
%prob_arrival = [0.245; 0.245];
%prob_arrival = [0.9; 0.09];
%prob_arrival = [0.49; 0.49];
IDLE_MAX = 1;
IDLE_ON = 0; % Flag for IDLE mode
CODE_IDLE = 0; % 0 for IDLE_MAX; 1 for increasing, concave function
gamma = 1; % For TSLS
%beta = [1; 1]; % For MW & Weighted VFMW
%beta = [1; 1; 1; 1]; % For MW & Weighted VFMW
beta = [1; 1; 1; 1]; % For MW & Weighted VFMW
%lambda = [1; 1]; % For max-HoL-age policy
lambda = [1; 1; 1; 1]; % For max-HoL-age policy
% i.i.d. ON/OFF channel model
%prob_on_channel = [0.5; 0.5; 0.5; 0.5];
prob_on_channel = [1; 1; 1; 1];
%prob_on_channel = [0.5; 0.5];
%prob_on_channel = [1; 1];

% Gilbert-Elliot Markovian channel model


% Assume initially empty
init_jobs = [0; 0; 0; 0];
%init_jobs = [0; 0];

% Record average statistics
history_jobs_average = zeros(nLink, simT);
switching_count_average = zeros(nLink, simT);
cumulative_service_average = zeros(nLink, simT);
history_mean_jobs_average = zeros(nLink, simT);
history_wasted_slots_average = zeros(1, simT);
history_TSLS_average = zeros(nLink, simT);
history_mean_TSLS_average = zeros(nLink, simT);
history_HoL_age_average = zeros(nLink, simT);
history_mean_HoL_age_average = zeros(nLink, simT);

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
    current_TSLS = zeros(nLink, 1);
    history_jobs = zeros(nLink, simT);
    history_location = zeros(1, simT);
    history_mean_jobs = zeros(nLink, simT);
    history_frame_remained = zeros(1, simT);
    history_wasted_slots = zeros(1, simT);
    history_TSLS = zeros(nLink, simT);
    history_mean_TSLS = zeros(nLink, simT);
    % For Head-of-Line simulation
    timestamp_of_arriving_jobs = zeros(nLink, simT); % May have overflow problem?
    HoL_pointer = ones(nLink, 1);
    HoL_age = zeros(nLink, 1); % If no job in the queue, HoL_age = 0
    cumulative_arrival = zeros(nLink, 1);
    history_HoL_age = zeros(nLink, simT);
    history_mean_HoL_age = zeros(nLink, simT);
    
    for t = 1:simT
        currentT = t;
        % Update channel conditions
        current_service_rate = (prob_on_channel >= (unifrnd(0, 1, nLink, 1)));
             
        % Update HoL age
        for j=1:nLink
            HoL_age(j,1) = (timestamp_of_arriving_jobs(j, HoL_pointer(j,1)) > 0)*(t - timestamp_of_arriving_jobs(j, HoL_pointer(j,1)));
            %HoL_age(j,1) = HoL_age(j,1) - 1*(timestamp_of_arriving_jobs(j, HoL_pointer(j,1)) == 0);
        end
        history_HoL_age(:,t) = HoL_age;
        
        if t > 1
            history_mean_HoL_age(:,t) = (history_mean_HoL_age(:,t-1)*(t-1) + HoL_age)/t;
        else
            history_mean_HoL_age(:,t) = HoL_age/t;
        end
        
        % Scheduling decision
        %decision = maxWeight(current_service_rate, current_jobs, beta);
        %decision = maxHoLage(current_service_rate, HoL_age, lambda);
        %decision = exhaustive(server_location, current_jobs);
        %decision = Max_TSLS_Ex(server_location, current_jobs, current_TSLS);
        %[decision, frame_remained] = VFMW(server_location, current_jobs, frame_remained, prob_on_channel, beta);
        [decision, frame_remained] = maxHoLage_Frame(server_location, current_jobs, frame_remained, prob_on_channel, HoL_age, lambda);
        %[decision, frame_remained] = VFMWx(server_location, current_jobs, frame_remained, prob_on_channel, beta);
        %[decision, frame_remained] = VFMW_TSLS(server_location, current_jobs, frame_remained, prob_on_channel, current_TSLS, gamma);
        %[decision, frame_remained] = VFMW_TSLSx(server_location, current_jobs, frame_remained, prob_on_channel, current_TSLS, gamma);

        % Update time since last service
        current_TSLS = current_TSLS + ones(nLink, 1);
        
        history_frame_remained(1, t) = frame_remained;
        if t > 1
            switching_count(:, t) = switching_count(:, t-1); 
            history_location(1, t) = history_location(1, t-1);
            history_wasted_slots(1, t) = history_wasted_slots(1, t-1);
        end
        if idle == 0
            if decision > 0
                if (server_location ~= decision) && (IDLE_ON == 1)
                    idle = getIDLE(IDLE_MAX, current_jobs(decision, 1), CODE_IDLE) - 1;
                    switching_count(decision, t) = switching_count(decision, t) + 1;
                else
                    if (server_location ~= decision)
                        switching_count(decision, t) = switching_count(decision, t) + 1;
                    end
                    % Debugging
                    history_wasted_slots(1, t) = history_wasted_slots(1, t-1) + (current_jobs(decision, 1) == 0);

                    % Update HoL pointer
                    HoL_pointer(decision,1) = HoL_pointer(decision,1) + min(current_jobs(decision, 1), current_service_rate(decision, 1));
                    
                    cumulative_service(decision, 1) = cumulative_service(decision, 1) + current_service_rate(decision, 1);
                    current_jobs(decision , 1) = max(current_jobs(decision, 1) - current_service_rate(decision, 1),0);
                    frame_remained = max(frame_remained - 1, 0);
                end
                server_location = decision;
                history_location(1, t) = server_location;
                current_TSLS(decision, 1) = 0;
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
        

    end
    % Collecting data in current iteration
    switching_count_average = switching_count_average + switching_count;
    cumulative_service_average = cumulative_service_average + cumulative_service;
    history_jobs_average = history_jobs_average + history_jobs;
    history_mean_jobs_average = history_mean_jobs_average + history_mean_jobs;
    history_wasted_slots_average = history_wasted_slots_average + history_wasted_slots;
    history_TSLS_average = history_TSLS_average + history_TSLS;
    history_mean_TSLS_average = history_mean_TSLS_average + history_mean_TSLS;
    history_HoL_age_average = history_HoL_age_average + history_HoL_age;
    history_mean_HoL_age_average = history_mean_HoL_age_average + history_mean_HoL_age;
end

%% =========== Part 3: Post-Processing =============
% 
    switching_count_average = switching_count_average/iteration;
    cumulative_service_average = cumulative_service_average/iteration;
    history_jobs_average = history_jobs_average/iteration;
    history_mean_jobs_average = history_mean_jobs_average/iteration;
    history_mean_TSLS_average = history_mean_TSLS_average/iteration;
    history_TSLS_average = history_TSLS_average/iteration;
    history_wasted_slots_average = history_wasted_slots_average/iteration;
    history_HoL_age_average = history_HoL_age_average/iteration;
    history_mean_HoL_age_average = history_mean_HoL_age_average/iteration;
    
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
    %createfigure_single(time, history_location);    
    %createfigure_single(time, history_frame_remained);  
    createfigure_single(time, history_wasted_slots_average);
    createfigure3(time, history_mean_TSLS_average);
    createfigure4(time, history_HoL_age_average);
    %createfigure4(time, history_mean_HoL_age_average);
    %createfigure3(time, history_TSLS_average);
    
    for i=1:nLink
        fprintf('Answer %d: (%d, %d, %d, %d) \n', i, history_mean_jobs_average(i, simT), switching_count_average(i, simT), history_mean_TSLS_average(i, simT), history_mean_HoL_age_average(i, simT));
        %fprintf('Answer 2: (%d, %d, %d) \n', history_mean_jobs_average(2, simT), switching_count_average(2, simT), history_mean_TSLS_average(2, simT));
        %fprintf('Answer 3: (%d, %d, %d) \n', history_mean_jobs_average(3, simT), switching_count_average(3, simT), history_mean_TSLS_average(3, simT));
        %fprintf('Answer 4: (%d, %d, %d) \n', history_mean_jobs_average(4, simT), switching_count_average(4, simT), history_mean_TSLS_average(4, simT));
    end
    fprintf('Answer 0: (%d, %d, %d) \n', sum(history_mean_jobs_average(:, simT))/nLink, sum(switching_count_average(:, simT))/nLink, sum(history_mean_TSLS_average(:, simT))/nLink);
%    
%% End of file   