function output = gfunc(gamma, delta, Wt)
% Define the g-adaptive function
    output = (max(0,(1 - gamma)))*power(max(0,Wt),(1-delta));

end