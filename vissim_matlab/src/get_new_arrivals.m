function num_arrivals = get_new_arrivals(rate, mode)

switch mode
    case 1
        % Bernoulli process
        num_arrivals = 0;
        if rand(1) <= rate
            num_arrivals = 1;
        end
    case 2
        % Uniform with outcome = 0, 1, ..., N and mean = rate
        % Prob(x=1)= Prob(x=2)= ... = Prob(x=N) = 2*rate/(N*(N+1))
        % rate <= (N+1)/2
        N = 3;
        num_arrivals = 0;
        rate_in = min((N+1)/2, rate);
        p = 2*rate_in/(N*(N+1));
        rn = rand(1);
        for i=1:N
            if rn <= p*i
                num_arrivals = i;
                break
            end
        end
    case 10
        % deterministic process
        num_arrivals = floor(rate);
        
    otherwise
        % Bernoulli process
        num_arrivals = 0;
        if rand(1) <= rate
            num_arrivals = 1;
        end
end
end