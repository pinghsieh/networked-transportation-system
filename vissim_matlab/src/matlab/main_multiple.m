%% Main for multiple runs
clear;
clc;
tic;
simT = 30000;
amber_length = 3;
allred_length = 2;
policy = 'BMP';
%policy = 'MP';
%policy = 'VFMP';
%policy = 'Mixed';
%policy = 'Fixed-Time';
%policy = 'gAdaptiveMW';
alpha = 0.01;
beta_1 = 0.99;
beta_2 = 0.5;

%% For gAdaptiveMW only
gamma = 0.1;
delta = 0.01;

%arrival_rate_scaling = [0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5];
%arrival_rate_scaling = [1.6, 1.7, 1.8, 1.9, 2, 2.1];
arrival_rate_scaling = 2.5;
%arrival_rate_scaling = [2.4, 2.5];
%arrival_rate_scaling = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5];
%arrival_rate_scaling = [2.3, 2.4];
%arrival_rate_scaling = 2.5;
for i=1:length(arrival_rate_scaling)
    %func_smart_networks(simT, amber_length, allred_length, arrival_rate_scaling(i), policy, alpha, beta_1, beta_2); 
    %func_smart_networks_v2(simT, amber_length, allred_length, arrival_rate_scaling(i), policy, alpha, beta_1, beta_2);    
    func_smart_networks_v3(simT, amber_length, allred_length, arrival_rate_scaling(i), policy, alpha, beta_1, beta_2, gamma, delta);
end
toc;