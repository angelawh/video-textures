%
% select_transitions.m
%   Select which set of transitions will be used.
%   Takes in a set of all transitions (primitive loops) to be used and 
%   length of loop to schedule (in number of seconds).
%   Primitive loops in the structure of [i j cost] where i >= j.
%   Returns a list of all transitions i -> j in order.

function [transitions] = select_transitions(primitive_loops, length)
    % Create 
    num_loops = size(primitive_loops, 1);
    
    %Take primitive loops and get information about:
    % Range=[i j], cost
    primitive_loops = sortrows(primitive_loops, 2);
    primitive_loops = sortrows(primitive_loops, 1);
    
    % Num_loops x 1 column vector
    loop_ranges = cell(num_loops, 1);
    for i = num_loops:-1:1
        j = i - 1;
        while j >= 1 && primitive_loops(i,2) <= primitive_loops(j,1)
            size_i = size(loop_ranges{i}, 2);
            size_j = size(loop_ranges{j}, 2);
            loop_ranges{i}(size_i + 1) = j;
            loop_ranges{j}(size_j + 1) = i;
            j = j - 1;
        end
    end
    
    % Initialize struct array
    loop_table = repmat(struct('prev', NaN, 'other', NaN, 'cost', -1), ...
        length, num_loops);
    
    for i = 1:length
        for j = 1:num_loops
            best_primitive_loop = [0 0];
            best_other_loop = [0 0];
            lowest_cost = Inf;
            for r = i - 1:-1:1
                other_r = length - r;
                columns = loop_ranges{j};
                for c = 1:size(columns, 2)
                    cost_other = loop_table(other_r, columns(c)).cost;
                    cost_prev = loop_table(r, j).cost;
                    if cost_other >= 0 && cost_prev > 0 && ...
                            cost_other + cost_prev < lowest_cost
                        lowest_cost = cost_other + cost_prev;
                        best_primitive_loop = [r j];
                        best_other_loop = [other_r columns(c)];
                    end
                end
            end
            if lowest_cost ~= Inf
                loop_table(i, j).cost = lowest_cost;
                loop_table(i, j).prev = best_primitive_loop;
                loop_table(i, j).other = best_other_loop;
            % If primitive loop length of column is equal to current length
            elseif (primitive_loops(j,1) - primitive_loops(j,2) + 1) == i
                % First entry, so save actual transition information (i, j)
                % in prev
                loop_table(i, j).cost = primitive_loops(j, 3);
                loop_table(i, j).prev = primitive_loops(j,1:2);
            end
        end
    end
    
    % Find lowest cost entry
    prev_loop = [0 0];
    other_loop = [0 0];
    lowest_cost = Inf;
    for col = 1:num_loops
        if loop_table(length, col).cost < lowest_cost
            prev_loop = loop_table(length, col).prev;
            other_loop = loop_table(length, col).other;
        end
    end
    
    % Trace back to get lowest cost combination of loops
    transitions = get_transitions(prev_loop, loop_table);
    transitions = [transitions; get_transitions(other_loop, loop_table)];
end

function [transitions] = get_transitions(prev, loop_table)
    % on tracing back afterwards, if cost ~= -1 and other is NaN then it is
    % the first one and the information can be found in prev
    cell = loop_table(prev(1), prev(2));
    
    if cell.cost ~= -1 && isnan(cell.other)
        transitions = cell.prev;
    else
        transitions = [get_transitions(cell.prev, loop_table);...
                       get_transitions(cell.other, loop_table)];
    end
end
%on tracing back afterwards, if cost ~= -1 and other is NaN then it is the 
% first one and the information can be found in prev
% 

%loop_table(i,j).prev = [i,j] location of where the prev is from
%loop_table(i,j).other = 
%loop_table(i,j).cost = 
%struct('prev',NaN,'other',NaN,'cost',-1)