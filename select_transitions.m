%
% select_transitions.m
%   Select which set of transitions will be used.
%   Takes in a set of all transitions (primitive loops) to be used and 
%   length of loop to schedule (in number of seconds).
%   Primitive loops in the structure of [i j cost] where i >= j.
%   Returns a list of all transitions i -> j in order.

function [transitions] = select_transitions(primitive_loops, length)
    num_loops = size(primitive_loops, 1);
    
    % Take primitive loops and find information about which other loops it
    % overlaps with (ranges of primitive loops overlap)
    primitive_loops = sortrows(primitive_loops, 2);
    primitive_loops = sortrows(primitive_loops, 1);
    
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
    
    % Initialize struct array. Prev and other are pointers cells of
    % the two compound loops that will be combined.
    loop_table = repmat(struct('prev', NaN, 'other', NaN, 'cost', -1), ...
        length, num_loops);
    
    % For each cell starting from the top row, find the combination of
    % compound loops before it with equal the length of the current row
    % and have the smallest cost
    for i = 1:length
        for j = 1:num_loops
            best_primitive_loop = [0 0];
            best_other_loop = [0 0];
            lowest_cost = Inf;
            for r = i - 1:-1:1
                other_r = i - r;
                columns = [loop_ranges{j}, j];
                for c = 1:size(columns, 2)
                    cost_other = loop_table(other_r, columns(c)).cost;
                    cost_prev = loop_table(r, j).cost;
                    if cost_other >= 0 && cost_prev >= 0 && ...
                            cost_other + cost_prev < lowest_cost
                        lowest_cost = cost_other + cost_prev;
                        best_primitive_loop = [r j];
                        best_other_loop = [other_r columns(c)];
                    end
                end
            end
            % If found a valid compound loop
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
    best_col = 0;
    lowest_cost = Inf;
    for col = 1:num_loops
        loop_cell = loop_table(length, col);
        if loop_cell.cost > 0 && loop_cell.cost < lowest_cost
            best_col = col;
            lowest_cost = loop_cell.cost;
        end
    end
    
    % Trace back to get lowest cost combination of loops
    transitions = get_transitions([length, best_col], loop_table);
end

function [transitions] = get_transitions(prev, loop_table)
    % If cost ~= -1 and other is NaN then it is 
    % the first one and the information of the actual column's transition
    % can be found in the prev
    loop_cell = loop_table(prev(1), prev(2));
    if loop_cell.cost ~= -1 && isnan(loop_cell.other(1))
        transitions = loop_cell.prev;
    else
        transitions = [get_transitions(loop_cell.prev, loop_table);...
                       get_transitions(loop_cell.other, loop_table)];
    end
end
