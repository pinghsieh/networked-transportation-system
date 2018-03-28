function [val, nid] = max_age_scheduling(marked_hol_age)
    [val, id] = max(marked_hol_age);
    % Random tie-breaking
    nid_vec = find(marked_hol_age == val);
    nid_vec_perm = randperm(length(nid_vec));
    nid = nid_vec(nid_vec_perm(1));
end