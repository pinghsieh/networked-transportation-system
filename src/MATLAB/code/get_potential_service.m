function service_rate = get_potential_service(prob_on_channel)
%% Get the potential service rate in the current slot
% service_rate is a nQueue-by-1 vector
% 1. ON/OFF process with certain probability
    nQueue = length(prob_on_channel);
    service_rate = (prob_on_channel >= (unifrnd(0, 1, nQueue, 1)));

end