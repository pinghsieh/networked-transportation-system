function eol_ptr = update_eol_ptr(t, arrival_time, N_arrivals)
    temp_matrix = (t < arrival_time);
    [val, id] = max(temp_matrix, [], 2);
    eol_ptr = (N_arrivals+1)*(val == 0) + (id - 1).*(val == 1);
end