function exo_arrival = get_exo_arrival(prob_arrival)
%% Get the number of exogenous arrivals in the current time slot
% exo_arrival is a nQueue-by-1 vector
% 1. Bernoulli arrival process 
    nQueue = length(prob_arrival);
    exo_arrival = (prob_arrival >= (unifrnd(0, 1, nQueue, 1)));

end