function [connected_hol_ptr_next, out_of_range] = find_next_connected(connected_hol_ptr, is_connected_vec)
    temp = find(is_connected_vec(connected_hol_ptr+1:end));
    if isempty(temp)
        out_of_range = 1;
        connected_hol_ptr_next = length(is_connected_vec) + 1;
    else
        connected_hol_ptr_next = connected_hol_ptr + temp(1);
        out_of_range = 0;
    end
end