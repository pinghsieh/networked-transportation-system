function is_connected = initialize_is_connected(N_flows, N_arrivals, penetration_ratio)
    is_connected = rand(N_flows, N_arrivals) < penetration_ratio;
end