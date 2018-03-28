%% Simulation for Partially-Connected Transportation Systems
clear;
tic;
%% Part 1: Configuration: Single-hop
config.config_5flows_sym;
feasible_schedules = cell(N_schedules, 1);
row_start_linear_id = N_arrivals*(0:1:N_flows-1);
queue_length_history = zeros(N_flows,simT);
hol_age_history = zeros(N_flows,simT);
connected_hol_age_history = zeros(N_flows,simT);

for r=1:nRun
%% Part 2: Initialization
%arrival_time = zeros(N_flows, N_arrivals);
%is_connected = zeros(N_flows, N_arrivals);
queue_length = zeros(N_flows, 1);
hol_age = zeros(N_flows, 1);
connected_hol_age = zeros(N_flows, 1);
arrival_time = (initialize_arrival_times(N_flows, N_arrivals, arrival_type, arg))';
is_connected = initialize_is_connected(N_flows, N_arrivals, penetration_ratio);

% hol_ptr: indicates the position of the HoL vehicle in the predetermined arrival
% sequence
% connected_hol_ptr: indicates the position of the HoL connected vehicle (might be a future arrival) in the predetermined arrival
% sequence
% eol_ptr: indicates the position of the latest arriving vehicle
% If there is only 1 vehicle in the queue n, then hol_ptr(n) = eol_ptr(n)
hol_ptr = ones(N_flows, 1);
connected_hol_ptr = ones(N_flows, 1);
eol_ptr = zeros(N_flows, 1);

%% Part 3: Main Operations
for t=1:simT
    %% Update state variables
    eol_ptr = update_eol_ptr(t, (arrival_time)', N_arrivals);
    if t == 1
        for j=1:N_flows
            [connected_hol_ptr(j), out_of_range] = find_next_connected(connected_hol_ptr(j), is_connected(j,:));
            if out_of_range == 1
                fprintf("Queue %d has no more connected vehicle!\n", j); 
            end
        end
    end
    % Check pointers 
    queue_length = eol_ptr - hol_ptr + ones(N_flows, 1);
    % For convenience, use 1D indexing
    hol_arriving_time = arrival_time((row_start_linear_id)' + hol_ptr);
    hol_age = max(0, t - hol_arriving_time);
    
    %if connected_hol_ptr <= eol_ptr
     %   connected_hol_age = max(0, t - arrival_time(row_start_linear_id + connected_hol_ptr));
    %else
     %   connected_hol_age = Age_default;  % might use constant or TSLS
    %end
    connected_hol_arriving_time = arrival_time((row_start_linear_id)' + connected_hol_ptr);
    connected_hol_age = (connected_hol_ptr <= eol_ptr).*(max(0, t - connected_hol_arriving_time))...
                        + (connected_hol_ptr > eol_ptr)*Age_default;
    %% Scheduling
    switch policy
        case 'max-hol-age'
        [val, nid] = max_age_scheduling(connected_hol_age);
        case 'max-queue-length'
        [val, nid] = max_queue_length_scheduling(queue_length);   
    end
    %% Update pointers
    % Note: 
    % If queue is empty, then hol_ptr = the id of the next arriving
    % job (in the future), and eol_ptr = the id of the last served job
    % If there is no connected job in the queue, then connected_hol_ptr = 
    
    % Service process
    % Assume service = 1 deterministically
    if queue_length(nid) > 0
        if connected_hol_ptr(nid) == hol_ptr(nid)
            % if hol vehicle happens to be connected
            [connected_hol_ptr(nid), out_of_range] = find_next_connected(connected_hol_ptr(nid), is_connected(nid,:));
            if out_of_range == 1
                fprintf("Queue %d has no more connected vehicle!\n", nid); 
            end
        end
        hol_ptr(nid) = hol_ptr(nid) + 1;
    end
    
    %% Update history
    queue_length_history(:,t) = queue_length;
    hol_age_history(:,t) = hol_age;
    connected_hol_age_history(:,t) = connected_hol_age;
end

end

%% Part 4: Plotting
step_size = 1;
tplot_start = 1;
taxis = tplot_start:step_size:simT;

figure;
plot(taxis, queue_length_history);
figure;
plot(taxis, hol_age_history);
figure;
plot(taxis, connected_hol_age_history);

toc;