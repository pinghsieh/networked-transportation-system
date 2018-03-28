function routed_jobs = get_routing(routing_info, total)
%% Decide how the served jobs are routed to the successive routes
% 1. I.I.D Bernoulli routing
%{
    nRoutes = size(routing_info);
    routed_jobs = zeros(nRoutes(1), 1);
    rnd = unifrnd(0, 1, total, 1);
    for i=1:total
        [val, choice] = max(routing_info(:,2) >= rnd(i));
        routed_jobs(choice) = routed_jobs(choice) + 1;
    end
%}    
% 2. Batch routing
    nRoutes = size(routing_info);
    routed_jobs = zeros(nRoutes(1), 1);
    rnd = unifrnd(0, 1);
    [val, choice] = max(routing_info(:,2) >= rnd);
    routed_jobs(choice) = routed_jobs(choice) + total;
    
end