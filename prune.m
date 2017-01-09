%
% prune.m
%   Prunes transitions.
%   D_prime - filtered distance matrix
%   thresh - threshold to deterine how many transitions to keep
%   Returns transitions, a list of the transitions from i -> j

function [transitions] = prune(D_dist, D_cost, local_size, thresh)
    
    
    % Select only local maxima in the transition matrix for a 
    % given source and/or destination frame
    % !!!~~!! what does transition matrix mean? D or P? assuming D
    % the later it says distance matrix but WHICH D 
        
    %idk
        
    % Prune all transitions that are not local minima in the distance 
    % matrix
    num_minima = 0;
    for i = 1:size(D_dist,1)
        for j = 1:size(D_dist,1)
            min = D_dist(i,j);
            min_loc = [i,j];
            for k = i:i+local_size
                for l = j:j+local_size
                    if k > 0 && k <= size(D_dist,1) && ...
                       j > 0 && j <= size(D_dist,1)
                        if D_dist(k,l) < min
                            min = D_dist(k,l);
                            min_loc = [k,l];
                        end
                    end
                end
            end
            if min_loc(1) ~= i || min_loc(2) ~= j
                D_dist(i,j) = Inf;
            else 
                num_minima = num_minima + 1;
            end
        end
    end
    
    minima = zeros(num_minima, 3);
    p = 1; % To keep track of where to put the minima
    
    % Put all minima into a list
    for i = 1:size(D_dist,1)
        for j = 1:size(D_dist,1)
            if D_dist(i,j) ~= Inf
                minima(p, 1:2) = [i,j];
                minima(p, 3) = D_cost(i ,j);
                p = p + 1;
            end
        end
    end
    
    minima = sortrows(minima, 3);   
    
    % Somehow prune by cost
    
    
     % Somehow prune more using P'' or D''
    
    
    % Take only the top X of them sorted by cost

end