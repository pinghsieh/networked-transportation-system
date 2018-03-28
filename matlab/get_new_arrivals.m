function output = get_new_arrivals(N_flows, arrival_type, arg)
    switch arrival_type
        case "Bernoulli"
            % arg{1}: arrival rate vector    
            output = rand(N_flows, 1) < arg{1};
        case "One"
            output = ones(N_flows, 1);
    end
end