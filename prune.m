%
% prune.m
%   Prunes transitions.
%   D_dist - The D matrix we want to use to prune by minima
%   D_cost - The D matrix we want to use to get cost of all pruned
%    transitions
%   local_size - The size N of 2N+1x2N+1 neighborhood around the pixel that
%    we want to check it is a local minima of
%   cost_thresh - The cost threshold that all transitions must be under or
%    equal to.
%   num_transitions - The maximum number of transitions to keep
%   Optional parameters:
%       P_prime_prime - The P'' matrix that has the probability of
%        transitions after considering anticipated future cost
%       p_thresh - The threshold to apply to the P'' value of each pruned
%        transition. All values must be greater than or equal to p_thresh.
%   Returns transitions, a set of the transitions to consider, structured
%    [row, col, cost].

function [transitions] = prune(D_dist, D_cost, local_size, cost_thresh, ...
                               num_transitions, P_prime_prime, p_thresh)
    % Prune all transitions that are not local minima in the distance 
    % matrix
    num_minima = 0;
    for i = 1:size(D_dist,1)
        for j = 1:size(D_dist,1)
            min_dist = D_dist(i,j);
            min_loc = [i,j];
            for k = i-local_size:1:i+local_size
                for l = j-local_size:1:j+local_size
                    if k > 0 && k <= size(D_dist,1) && ...
                       l > 0 && l <= size(D_dist,1)
                        if D_dist(k,l) < min_dist
                            min_dist = D_dist(k,l);
                            min_loc = [k,l];
                        end
                    end
                end
            end
            if min_loc(1) ~= i || min_loc(2) ~= j || i <= j
                D_dist(i,j) = Inf;
            else 
                num_minima = num_minima + 1;
            end
        end
    end
    
    minima = zeros(num_minima, 3);
    p = 1; % To keep track of where to put the minima
    
    % Put all minima into a list and change the transition to be
    % i-1, j so that we make the transition from i-1 -> j when i is
    % similar to j
    for i = 1:size(D_dist,1)
        for j = 1:size(D_dist,1)
            if D_dist(i,j) ~= Inf
                minima(p, 1:2) = [i - 1,j];
                minima(p, 3) = D_cost(i ,j);
                p = p + 1;
            end
        end
    end
    
    minima = sortrows(minima, 3);   
    
    % Prune by cost
    i = size(minima,1);
    while minima(i, 3) > cost_thresh
        minima(i, :) = [];
        i = i - 1;
    end
    
    % Prune by P'' if parameters given
    if nargin > 5
        for i = size(minima,1):-1:1
            if P_prime_prime(minima(i,1), minima(i,2)) < p_thresh
                minima(i, :) = [];
            end
        end
    end
    
    % Take only the top num_transitions of them sorted by cost
    num_return = min(num_transitions, size(minima, 1));
    transitions = minima(1:num_return, :);
end