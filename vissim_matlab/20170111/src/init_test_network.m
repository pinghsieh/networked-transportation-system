function [all_links, all_intersections, mapObj, total_arrival_rate, service_count, qlen_weight] = init_test_network(sf, scaling, policy)
%% Some parameters
N_link = 4;
N_intersection = 2;
all_intersections = cell(N_intersection, 1);
all_links = cell(N_link, 1);
service_count = cell(N_intersection, 1);
sat_flow = sf;
arrival_rates = zeros(N_link, 1);
arrival_rates(1:4, 1)  = [1 1 0 1];
arrival_rates = scaling*arrival_rates;
total_arrival_rate = sum(arrival_rates);
qlen_weight = ones(N_link,1);

%% Initialize links
% Usage: my_matlab_link(link_id, downstream_links, routing_ratio, intersection_id, is_entry, arrival_rate, capacity) 
% Example: all_links{1} = my_matlab_link(1, {2; 4},[0.5 0.5], 1, 1, 0.1, 1);
all_links{1} = my_matlab_link(1, {3}, 1, 1, 1, arrival_rates(1), sat_flow);
all_links{2} = my_matlab_link(2, {3}, 0, 1, 1, arrival_rates(2), sat_flow);
all_links{3} = my_matlab_link(3, {1}, 0, 2, 0, arrival_rates(3), sat_flow);
all_links{4} = my_matlab_link(4, {1}, 0, 2, 1, arrival_rates(4), sat_flow);



%% Map from original VISSIM link number to ordered link numbers
keySet = {1, 2, 3, 4};
valueSet = 1:1:N_link;
mapObj = containers.Map(keySet, valueSet);


%% Queue length weight factor
%{
Z = 3;
left_turns = {26,25,24,23,22,21,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58};
left_turns_matlab_id = cell2mat(values(mapObj, left_turns));
for k=1:length(left_turns_matlab_id)
    qlen_weight(left_turns_matlab_id(k)) = Z;
end
%}

%% Initialize intersections
% Usage: my_matlab_intersection(links_in, phases)
% Example: all_intersections{1} = my_matlab_intersection([1; 3; 6; 10; 15;
% 18; 27; 33], {[1 15],[3 27],[6 33],[10 18]});

cycle = [100; 100; 100; 100; 100; 100];
offset = [10; 45; 98; 59; 3; 57];
green_start{1} = [0; 24; 58; 75];
green_end{1} = [19; 53; 70; 95];
green_start{2} = [0; 26; 59; 74];
green_end{2} = [21; 54; 69; 95];
green_start{3} = [0; 24; 56; 71];
green_end{3} = [19; 51; 66; 95];
green_start{4} = [0; 23; 56; 75];
green_end{4} = [18; 51; 70; 95];
green_start{5} = [0; 25; 57; 75];
green_end{5} = [20; 52; 70; 95];
green_start{6} = [0; 24; 58; 75];
green_end{6} = [19; 53; 70; 95];


all_intersections{1} = my_matlab_intersection([1; 2], {1, 2}, green_start{1}, green_end{1}, cycle(1), offset(1));
all_intersections{2} = my_matlab_intersection([3; 4], {3, 4}, green_start{2}, green_end{2}, cycle(2), offset(2));


service_count{1} = zeros(all_intersections{1}.N_phases,1);
service_count{2} = zeros(all_intersections{2}.N_phases,1);

end