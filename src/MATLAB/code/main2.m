%% Main simulation script

%% Start of the main
%power1 = [0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.92 0.94 0.95];
%power1 = [0.75 0.8 0.85 0.9 0.95];
%power1 = [0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95];
%power = [0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 0.99];
%power = [0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8];
%power = [0.2 0.3 0.4 0.5];
power = 0.99;
%power = 0.15;
%power = [0 0.01 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5];
%power = 0.15;
%power = 0.001;
%power2 = 0.9;
%power = [0.6 0.7 0.8 0.9 0.95];
%power = [0.55 0.65 0.75 0.85 0.99];
%power = 0.99;
%power = [0.15 0.2 0.25];
%power = 0.7;
simT = 200000;
run = 5;
%Ts = 1;
%Ts = [1 2 3 4 5 6 7];
Ts = 5;
logMode = 'simple'; % either 'simple' or 'foreach' or 'full'
%logMode = 'foreach';
%policy2 = 'SCB_Adhoc';
%policy = 'MWLA_Adhoc';
%policy = 'MWLAHOQ_Adhoc';
policy = 'VFMW_Adhoc';
%policy = {'MaxWeight_Adhoc'; 'MWLA_Adhoc'; 'VFMW_Adhoc'; 'SCB_Adhoc'};
fileID = fopen('swSingleHop2.log','a');
%rho = 0.9;
%rho = [0.98 0.99];
%rho = [0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97];
%rho2 = [0.85 0.88 0.9 0.92 0.95 0.99];
%rho3 = [0.86 0.87 0.89 0.91 0.93 0.94 0.96 0.97 0.98];
rho = 0.95;

%{
setup = 47;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'rho = %.3f ', rho(i));
    swSingleHop_0709(setup, simT, run, policy, power, fileID, logMode, rho(i), Ts); 
end
%}

setup = 22;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d  power: %.3f  rho: %.2f\n', setup, simT, run, power, rho);
for i=1:length(Ts)
    fprintf(fileID, 'Ts = %d ', Ts(i));
    swSingleHop_0709(setup, simT, run, policy, power, fileID, logMode, rho, Ts(i)); 
end

%{
setup = 43;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d  Ts: %d\n', setup, simT, run, Ts);
for i=1:length(power)
    fprintf(fileID, 'power = %.2f ', power(i));
    swSingleHop_0709(setup, simT, run, policy, power(i), fileID, logMode, rho, Ts); 
end
%}
%{
setup = 18;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(power)
    fprintf(fileID, 'power = %.2f ', power(i));
    swSingleHop(setup, simT, run, policy, power(i), fileID, logMode, rho, Ts); 
end
%}
%{
setup = 20;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy2);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'power = %.2f ', rho(i));
    swSingleHop(setup, simT, run, policy2, power2, fileID, logMode, rho(i)); 
end

setup = 18;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy2);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'power = %.2f ', rho(i));
    swSingleHop(setup, simT, run, policy2, power2, fileID, logMode, rho(i)); 
end



setup = 22;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy2);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'power = %.2f ', rho(i));
    swSingleHop(setup, simT, run, policy2, power2, fileID, logMode, rho(i)); 
end

setup = 23;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy2);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'rho = %.2f ', rho(i));
    swSingleHop(setup, simT, run, policy2, power2, fileID, logMode, rho(i)); 
end

setup = 24;
fprintf(fileID, 'Scheduling-Policy: %s\n', policy2);
fprintf(fileID, 'setup-number: %d  simT: %d  iterations: %d\n', setup, simT, run);
for i=1:length(rho)
    fprintf(fileID, 'rho = %.2f ', rho(i));
    swSingleHop(setup, simT, run, policy2, power2, fileID, logMode, rho(i)); 
end
%}
%{
for i=1:length(power2)
    fprintf(fileID, 'power = %.2f ', power2(i));
    swSingleHop(setup, simT, run, policy2, power2(i), fileID, logMode); 
end
%}
