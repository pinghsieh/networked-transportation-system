classdef my_matlab_link < matlab.mixin.SetGet
    %% downstream_links: a cell of the indices of downstream links
    properties
        link_id = 0
        downstream_links
        routing_ratio
        intersection_id = 0
        is_entry
        arrival_rate
        capacity
        %queue_length = 0
    end
    methods
        % Constructor
        function obj = my_matlab_link(lid, ds, rr, iid, ise, ar, cap)
            obj.link_id = lid;
            obj.downstream_links = ds;
            obj.routing_ratio = rr;
            obj.intersection_id = iid;
            obj.is_entry = ise;
            obj.arrival_rate = ar;
            obj.capacity = cap;
            %obj.queue_length = ql;
        end
        
        function next_route = generate_next_route(obj, mapObj)
            rn = rand(1);  % generate a random number between 0 and 1
            next_route = -1;  % -1 means there is no possible next route
            for i=1:length(obj.routing_ratio)
                if rn <= sum(obj.routing_ratio(1:i))
                    next_route = cell2mat(values(mapObj,{obj.downstream_links{i}}));
                    break
                end
            end
        end
    end
end