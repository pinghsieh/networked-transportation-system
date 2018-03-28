function [val, nid] = max_queue_length_scheduling(queue_length)
    [val, id] = max(queue_length);
    % Random tie-breaking
    nid_vec = find(queue_length == val);
    nid_vec_perm = randperm(length(nid_vec));
    nid = nid_vec(nid_vec_perm(1));

end