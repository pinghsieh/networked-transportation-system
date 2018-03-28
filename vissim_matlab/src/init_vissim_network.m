function [all_links, all_intersections, mapObj] = init_vissim_network
%% Some parameters
N_link = 48;
N_intersection = 6;
all_intersections = cell(N_intersection, 1);
all_links = cell(N_link, 1);

%% Initialize links
% Usage: my_vissim_link(link_id, downstream_links, routing_ratio, intersection_id) 
% Example: all_links{1} = my_vissim_link(1, {2; 4},[0.5 0.5], 1);
all_links{1}  = my_vissim_link(22, {50, 74},[0.2; 0.8], 3);
all_links{2}  = my_vissim_link(24, {49, 70},[0.2; 0.8], 2);
all_links{3}  = my_vissim_link(26, {47, 66},[0.2; 0.8], 1);
all_links{4}  = my_vissim_link(42, {54, 68},[0.2; 0.8], 4);
all_links{5}  = my_vissim_link(44, {55, 72},[0.2; 0.8], 5);
all_links{6}  = my_vissim_link(45, {58, 76},[0.2; 0.8], 6);
all_links{7}  = my_vissim_link(48, {43, 78},[0.2; 0.8], 4);
all_links{8}  = my_vissim_link(49, {42, 79},[0.2; 0.8], 5);
all_links{9}  = my_vissim_link(50, {44, 81},[0.2; 0.8], 6);
all_links{10} = my_vissim_link(52, {46, 80},[0.2; 0.8], 5);
all_links{11} = my_vissim_link(54, {24, 60},[0.2; 0.8], 1);
all_links{12} = my_vissim_link(55, {22, 61},[0.2; 0.8], 2);
all_links{13} = my_vissim_link(56, {25, 64},[0.2; 0.8], 2);
all_links{14} = my_vissim_link(57, {23, 63},[0.2; 0.8], 3);
all_links{15} = my_vissim_link(59, {24, 60},[0.2; 0.8], 1);
all_links{16} = my_vissim_link(60, {22, 61},[0.2; 0.8], 2);
all_links{17} = my_vissim_link(62, {23, 63},[0.2; 0.8], 3);
all_links{18} = my_vissim_link(63, {25, 64},[0.2; 0.8], 2);
all_links{19} = my_vissim_link(65, {47, 66},[0.2; 0.8], 1);
all_links{20} = my_vissim_link(67, {54, 68},[0.2; 0.8], 4);
all_links{21} = my_vissim_link(69, {49, 70},[0.2; 0.8], 2);
all_links{22} = my_vissim_link(71, {55, 72},[0.2; 0.8], 5);
all_links{23} = my_vissim_link(73, {50, 74},[0.2; 0.8], 3);
all_links{24} = my_vissim_link(75, {58, 76},[0.2; 0.8], 6);
all_links{25} = my_vissim_link(77, {43, 78},[0.2; 0.8], 4);
all_links{26} = my_vissim_link(78, {46, 80},[0.2; 0.8], 5);
all_links{27} = my_vissim_link(81, {42, 79},[0.2; 0.8], 5);
all_links{28} = my_vissim_link(82, {44, 81},[0.2; 0.8], 6);
all_links{29} = my_vissim_link(25, {44, 81},[0; 0], 1);
all_links{30} = my_vissim_link(64, {44, 81},[0; 0], 1);
all_links{31} = my_vissim_link(68, {44, 81},[0; 0], 1);
all_links{32} = my_vissim_link(53, {44, 81},[0; 0], 1);
all_links{33} = my_vissim_link(23, {44, 81},[0; 0], 2);
all_links{34} = my_vissim_link(72, {44, 81},[0; 0], 2);
all_links{35} = my_vissim_link(61, {44, 81},[0; 0], 3);
all_links{36} = my_vissim_link(21, {44, 81},[0; 0], 3);
all_links{37} = my_vissim_link(58, {44, 81},[0; 0], 3);
all_links{38} = my_vissim_link(76, {44, 81},[0; 0], 3);
all_links{39} = my_vissim_link(41, {44, 81},[0; 0], 4);
all_links{40} = my_vissim_link(47, {44, 81},[0; 0], 4);
all_links{41} = my_vissim_link(66, {44, 81},[0; 0], 4);
all_links{42} = my_vissim_link(79, {44, 81},[0; 0], 4);
all_links{43} = my_vissim_link(43, {44, 81},[0; 0], 5);
all_links{44} = my_vissim_link(70, {44, 81},[0; 0], 5);
all_links{45} = my_vissim_link(46, {44, 81},[0; 0], 6);
all_links{46} = my_vissim_link(80, {44, 81},[0; 0], 6);
all_links{47} = my_vissim_link(74, {44, 81},[0; 0], 6);
all_links{48} = my_vissim_link(51, {44, 81},[0; 0], 6);


%% Map from original VISSIM link number to ordered link numbers
keySet = {22, 24, 26, 42, 44, 45, 48, 49, 50, 52, 54, 55 ,56, 57, 59, 60 ,62, 63, 65, 67, 69, 71, 73, 75, 77, 78, 81, 82, 25, 64, 68, 53, 23, 72, 61, 21, 58, 76, 41, 47, 66, 79, 43, 70, 46, 80, 74, 51};
valueSet = 1:1:N_link;
mapObj = containers.Map(keySet, valueSet);

%% Initialize intersections
% Usage: my_vissim_intersection(links_in, phases)
% Example: all_intersections{1} = my_vissim_intersection([1; 3; 6; 10; 15;
% 18; 27; 33], {[1 15],[3 27],[6 33],[10 18]});
all_intersections{1} = my_vissim_intersection([26; 25; 59; 64; 53; 54; 65; 68], {[26; 25],[59; 64],[53; 54],[65; 68]});
all_intersections{2} = my_vissim_intersection([24; 23; 60; 63; 55; 56; 69; 72], {[24; 23],[60; 63],[55; 56],[69; 72]});
all_intersections{3} = my_vissim_intersection([21; 22; 61; 62; 57; 58; 73; 76], {[21; 22],[61; 62],[57; 58],[73; 76]});
all_intersections{4} = my_vissim_intersection([41; 42; 77; 79; 47; 48; 66; 67], {[41; 42],[77; 79],[47; 48],[66; 67]});
all_intersections{5} = my_vissim_intersection([43; 44; 78; 81; 52; 49; 70; 71], {[43; 44],[78; 81],[52; 49],[70; 71]});
all_intersections{6} = my_vissim_intersection([45; 46; 80; 82; 50; 51; 74; 75], {[45; 46],[80; 82],[50; 51],[74; 75]});

end