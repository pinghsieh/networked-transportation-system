function [all_links, all_intersections, mapObj, total_arrival_rate, service_count, qlen_weight] = init_smart_network_vissim(sf, scaling, policy)
%% Some parameters
N_link = 48;
N_intersection = 6;
all_intersections = cell(N_intersection, 1);
all_links = cell(N_link, 1);
service_count = cell(N_intersection, 1);
sat_flow_major = 3*sf;
sat_flow_minor = 1*sf;
arrival_rates = zeros(N_link, 1);
arrival_rates(1:8, 1)  = [0 0 0.1 0 0 0.1 0.05 0];
arrival_rates(9:16, 1) = [0 0.05 0 0 0.05 0.05 0.4 0];
arrival_rates(17:24, 1)= [0.4 0 0.2 0.2 0.2 0.2 0.2 0.2];
arrival_rates(25:32, 1)= [0.4 0 0 0.4 0 0 0 0.05];
arrival_rates(33:40, 1)= [0 0 0 0.1 0 0 0.1 0];
arrival_rates(41:48, 1)= [0 0 0 0 0 0 0 0.05];
arrival_rates = scaling*arrival_rates;
total_arrival_rate = sum(arrival_rates);
qlen_weight = ones(N_link,1);

%% Initialize links
% Usage: my_matlab_link(link_id, downstream_links, routing_ratio, intersection_id, is_entry, arrival_rate, capacity) 
% Example: all_links{1} = my_matlab_link(1, {2; 4},[0.5 0.5], 1, 1, 0.1, 1);
all_links{1}  = my_matlab_link(22, {50, 74},[0.2; 0.8], 3, 0, arrival_rates(1), sat_flow_minor);
all_links{2}  = my_matlab_link(24, {49, 70},[0.2; 0.8], 2, 0, arrival_rates(2), sat_flow_minor);
all_links{3}  = my_matlab_link(26, {47, 66},[0.2; 0.8], 1, 1, arrival_rates(3), sat_flow_minor);
all_links{4}  = my_matlab_link(42, {54, 68},[0.2; 0.8], 4, 0, arrival_rates(4), sat_flow_minor);
all_links{5}  = my_matlab_link(44, {55, 72},[0.2; 0.8], 5, 0, arrival_rates(5), sat_flow_minor);
all_links{6}  = my_matlab_link(45, {58, 76},[0.2; 0.8], 6, 1, arrival_rates(6), sat_flow_minor);
all_links{7}  = my_matlab_link(48, {43, 78},[0.2; 0.8], 4, 1, arrival_rates(7), sat_flow_minor);
all_links{8}  = my_matlab_link(49, {42, 79},[0.2; 0.8], 5, 0, arrival_rates(8), sat_flow_minor);
all_links{9}  = my_matlab_link(50, {44, 81},[0.2; 0.8], 6, 0, arrival_rates(9), sat_flow_minor);
all_links{10} = my_matlab_link(52, {46, 80},[0.2; 0.8], 5, 1, arrival_rates(10), sat_flow_minor);
all_links{11} = my_matlab_link(54, {24, 60},[0.2; 0.8], 1, 0, arrival_rates(11), sat_flow_minor);
all_links{12} = my_matlab_link(55, {22, 61},[0.2; 0.8], 2, 0, arrival_rates(12), sat_flow_minor);
all_links{13} = my_matlab_link(56, {25, 64},[0.2; 0.8], 2, 1, arrival_rates(13), sat_flow_minor);
all_links{14} = my_matlab_link(57, {23, 63},[0.2; 0.8], 3, 1, arrival_rates(14), sat_flow_minor);
all_links{15} = my_matlab_link(59, {24, 60},[0.2; 0.8], 1, 1, arrival_rates(15), sat_flow_major);
all_links{16} = my_matlab_link(60, {22, 61},[0.2; 0.8], 2, 0, arrival_rates(16), sat_flow_major);
all_links{17} = my_matlab_link(62, {23, 63},[0.2; 0.8], 3, 1, arrival_rates(17), sat_flow_major);
all_links{18} = my_matlab_link(63, {25, 64},[0.2; 0.8], 2, 0, arrival_rates(18), sat_flow_major);
all_links{19} = my_matlab_link(65, {47, 66},[0.2; 0.8], 1, 1, arrival_rates(19), sat_flow_major);
all_links{20} = my_matlab_link(67, {54, 68},[0.2; 0.8], 4, 1, arrival_rates(20), sat_flow_major);
all_links{21} = my_matlab_link(69, {49, 70},[0.2; 0.8], 2, 1, arrival_rates(21), sat_flow_major);
all_links{22} = my_matlab_link(71, {55, 72},[0.2; 0.8], 5, 1, arrival_rates(22), sat_flow_major);
all_links{23} = my_matlab_link(73, {50, 74},[0.2; 0.8], 3, 1, arrival_rates(23), sat_flow_major);
all_links{24} = my_matlab_link(75, {58, 76},[0.2; 0.8], 6, 1, arrival_rates(24), sat_flow_major);
all_links{25} = my_matlab_link(77, {43, 78},[0.2; 0.8], 4, 1, arrival_rates(25), sat_flow_major);
all_links{26} = my_matlab_link(78, {46, 80},[0.2; 0.8], 5, 0, arrival_rates(26), sat_flow_major);
all_links{27} = my_matlab_link(81, {42, 79},[0.2; 0.8], 5, 0, arrival_rates(27), sat_flow_major);
all_links{28} = my_matlab_link(82, {44, 81},[0.2; 0.8], 6, 1, arrival_rates(28), sat_flow_major);
all_links{29} = my_matlab_link(25, {44, 81},[0; 0], 1, 0, arrival_rates(29), sat_flow_minor);
all_links{30} = my_matlab_link(64, {44, 81},[0; 0], 1, 0, arrival_rates(30), sat_flow_major);
all_links{31} = my_matlab_link(68, {44, 81},[0; 0], 1, 0, arrival_rates(31), sat_flow_major);
all_links{32} = my_matlab_link(53, {44, 81},[0; 0], 1, 1, arrival_rates(32), sat_flow_minor);
all_links{33} = my_matlab_link(23, {44, 81},[0; 0], 2, 0, arrival_rates(33), sat_flow_minor);
all_links{34} = my_matlab_link(72, {44, 81},[0; 0], 2, 0, arrival_rates(34), sat_flow_major);
all_links{35} = my_matlab_link(61, {44, 81},[0; 0], 3, 0, arrival_rates(35), sat_flow_major);
all_links{36} = my_matlab_link(21, {44, 81},[0; 0], 3, 1, arrival_rates(36), sat_flow_minor);
all_links{37} = my_matlab_link(58, {44, 81},[0; 0], 3, 0, arrival_rates(37), sat_flow_minor);
all_links{38} = my_matlab_link(76, {44, 81},[0; 0], 3, 0, arrival_rates(38), sat_flow_major);
all_links{39} = my_matlab_link(41, {44, 81},[0; 0], 4, 1, arrival_rates(39), sat_flow_minor);
all_links{40} = my_matlab_link(47, {44, 81},[0; 0], 4, 0, arrival_rates(40), sat_flow_minor);
all_links{41} = my_matlab_link(66, {44, 81},[0; 0], 4, 0, arrival_rates(41), sat_flow_major);
all_links{42} = my_matlab_link(79, {44, 81},[0; 0], 4, 0, arrival_rates(42), sat_flow_major);
all_links{43} = my_matlab_link(43, {44, 81},[0; 0], 5, 0, arrival_rates(43), sat_flow_minor);
all_links{44} = my_matlab_link(70, {44, 81},[0; 0], 5, 0, arrival_rates(44), sat_flow_major);
all_links{45} = my_matlab_link(46, {44, 81},[0; 0], 6, 0, arrival_rates(45), sat_flow_minor);
all_links{46} = my_matlab_link(80, {44, 81},[0; 0], 6, 0, arrival_rates(46), sat_flow_major);
all_links{47} = my_matlab_link(74, {44, 81},[0; 0], 6, 0, arrival_rates(47), sat_flow_major);
all_links{48} = my_matlab_link(51, {44, 81},[0; 0], 6, 1, arrival_rates(48), sat_flow_minor);



%% Map from original VISSIM link number to ordered link numbers
keySet = {22, 24, 26, 42, 44, 45, 48, 49, 50, 52, 54, 55 ,56, 57, 59, 60 ,62, 63, 65, 67, 69, 71, 73, 75, 77, 78, 81, 82, 25, 64, 68, 53, 23, 72, 61, 21, 58, 76, 41, 47, 66, 79, 43, 70, 46, 80, 74, 51};
valueSet = 1:1:N_link;
mapObj = containers.Map(keySet, valueSet);


%% Queue length weight factor
Z = 3;
left_turns = {26,25,24,23,22,21,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58};
left_turns_matlab_id = cell2mat(values(mapObj, left_turns));
for k=1:length(left_turns_matlab_id)
    qlen_weight(left_turns_matlab_id(k)) = Z;
end


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

%if strcmp(policy, 'Fixed-Time')
all_intersections{1} = my_matlab_intersection([26; 25; 59; 64; 53; 54; 65; 68], {[26; 25],[59; 64],[53; 54],[65; 68]}, green_start{1}, green_end{1}, cycle(1), offset(1));
all_intersections{2} = my_matlab_intersection([24; 23; 60; 63; 55; 56; 69; 72], {[24; 23],[60; 63],[55; 56],[69; 72]}, green_start{2}, green_end{2}, cycle(2), offset(2));
all_intersections{3} = my_matlab_intersection([21; 22; 61; 62; 57; 58; 73; 76], {[21; 22],[61; 62],[57; 58],[73; 76]}, green_start{3}, green_end{3}, cycle(3), offset(3));
all_intersections{4} = my_matlab_intersection([41; 42; 77; 79; 47; 48; 66; 67], {[41; 42],[77; 79],[47; 48],[66; 67]}, green_start{4}, green_end{4}, cycle(4), offset(4));
all_intersections{5} = my_matlab_intersection([43; 44; 78; 81; 52; 49; 70; 71], {[43; 44],[78; 81],[52; 49],[70; 71]}, green_start{5}, green_end{5}, cycle(5), offset(5));
all_intersections{6} = my_matlab_intersection([45; 46; 80; 82; 50; 51; 74; 75], {[45; 46],[80; 82],[50; 51],[74; 75]}, green_start{6}, green_end{6}, cycle(6), offset(6));
%end
%{
if (strcmp(policy, 'BMP')) || (strcmp(policy, 'MP')) || (strcmp(policy, 'VFMP'))
all_intersections{1} = my_matlab_intersection([26; 25; 59; 64; 53; 54; 65; 68], {[26; 25],[59; 64],[53; 54],[65; 68], 26, 25, 59, 64, 53, 54, 65, 68}, green_start{1}, green_end{1}, cycle(1), offset(1));
all_intersections{2} = my_matlab_intersection([24; 23; 60; 63; 55; 56; 69; 72], {[24; 23],[60; 63],[55; 56],[69; 72], 24, 23, 60, 63, 55, 56, 69, 72}, green_start{2}, green_end{2}, cycle(2), offset(2));
all_intersections{3} = my_matlab_intersection([21; 22; 61; 62; 57; 58; 73; 76], {[21; 22],[61; 62],[57; 58],[73; 76], 21, 22, 61, 62, 57, 58, 73, 76}, green_start{3}, green_end{3}, cycle(3), offset(3));
all_intersections{4} = my_matlab_intersection([41; 42; 77; 79; 47; 48; 66; 67], {[41; 42],[77; 79],[47; 48],[66; 67], 41, 42, 77, 79, 47, 48, 66, 67}, green_start{4}, green_end{4}, cycle(4), offset(4));
all_intersections{5} = my_matlab_intersection([43; 44; 78; 81; 52; 49; 70; 71], {[43; 44],[78; 81],[52; 49],[70; 71], 43, 44, 78, 81, 52, 49, 70, 71}, green_start{5}, green_end{5}, cycle(5), offset(5));
all_intersections{6} = my_matlab_intersection([45; 46; 80; 82; 50; 51; 74; 75], {[45; 46],[80; 82],[50; 51],[74; 75], 45, 46, 80, 82, 50, 51, 74, 75}, green_start{6}, green_end{6}, cycle(6), offset(6));
end
%}

service_count{1} = zeros(all_intersections{1}.N_phases,1);
service_count{2} = zeros(all_intersections{2}.N_phases,1);
service_count{3} = zeros(all_intersections{3}.N_phases,1);
service_count{4} = zeros(all_intersections{4}.N_phases,1);
service_count{5} = zeros(all_intersections{5}.N_phases,1);
service_count{6} = zeros(all_intersections{6}.N_phases,1);
end