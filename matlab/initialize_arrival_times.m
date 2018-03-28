function arrival_time = initialize_arrival_times(N_flows, N_arrivals, arrival_type, arg)
    arrival_time = zeros(N_flows, N_arrivals);
    switch arrival_type
        case "Bernoulli" 
            % arg{1}: arrival rate vector
            for n=1:N_flows
                arrival_time(n,:) = geornd(arg{1}(n), 1, N_arrivals) + 1; 
            end
            arrival_time = cumsum(arrival_time, 2);
        case "One"
            arrival_time = ones(N_flows,1)*(1:1:N_arrivals);
    end
end