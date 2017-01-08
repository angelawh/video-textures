%
% prune.m
%   Prunes transitions.
%   D_prime - filtered distance matrix
%   thresh - threshold to deterine how many transitions to keep
%   Returns transitions, a list of the transitions from i -> j

function [transitions] = prune(D_prime, thresh)
    
    
    % Select only local maxima in the transition matrix for a 
    % given source and/or destination frame
    % !!!~~!! what does transition matrix mean? D or P? assuming D
    % the later it says distance matrix but WHICH D 
        
    %idk
        
    % Prune all transitions that are not local minima in the distance 
    % matrix
    
    local_maxima = 1; % make it sequence of [i,j] values
        
    for i = 1:size(D,1)
        for j = 1:size(D,1)
        end
    end
    
    % Compute the average cost for each transition
        for a = 1:size(local_maxima,2)
            i = local_maxima{a}(1);
            j = local_maxima{a}(2);
            if P(i, j) > thresh
            end
        end
     
    % Compare and keep only the best few
end