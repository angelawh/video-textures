%
% schedule_transitions.m
%   Schedules order of transitions to be used.
%   Takes in a set of all transitions to be used (even if multiples)
%   Returns a list of all transitions i -> j in order.

function [ordered_transitions] = schedule_transitions(transitions)
    % Sort the transitions
    transitions = sortrows(transitions, 2);
    transitions = sortrows(transitions, 1);
    
    ordered_transitions = transitions;
    num_placed = 1;
    
    % Schedule transitions by starting at the last transition and finding
    % the earliest loop that overlaps with its range
    i = size(transitions, 1);
    while i > 1
        transition_beg = transitions(i,2);
        ordered_transitions(num_placed, :) = transitions(i, :);
        num_placed = num_placed + 1;
        transitions(i, :) = [];
        % Find the loop with overlapping range
        j = i - 1;
        while j >= 1 && transition_beg <= transitions(j,1)
            j = j - 1;
        end
        i = j + 1; 
    end
    
    % Put all remaining transitions in list from top to bottom.
    ordered_transitions(num_placed:size(ordered_transitions, 1), :) = ...
        transitions;
end