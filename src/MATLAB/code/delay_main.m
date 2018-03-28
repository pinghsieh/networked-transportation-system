%% delay_main.m
clear;
%load = [0.84; 0.82; 0.8; 0.75; 0.7; 0.65; 0.6; 0.55; 0.5; 0.4; 0.3; 0.2; 0.1];
%load = [0.7; 0.65; 0.6; 0.55; 0.5; 0.4; 0.3; 0.2; 0.1];
%load = [0.54; 0.53; 0.52; 0.51; 0.48; 0.45; 0.35; 0.25; 0.15];
load = [0.93];
for i=1:length(load)
   network_adhoc_func(load(i), 'VFMW_adhoc_diff_lim'); 
   %network_adhoc_func(load(i), 'MaxWeight_Adhoc_lim'); 
   %network_adhoc_func(load(i), 'Fixed_Time');
end


