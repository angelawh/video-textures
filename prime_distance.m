
%
% l2_distance.m
%   Creates prime distance matrices between pairs of images from D matrix.
%   D - Distance matrix
%   m_weight - dynamics kernel weight. Should be 1 or 2
%   p - some transition something
%   alpha - related to future cost
%   pp_thresh - the threshold for D'' that determines when to stop
%    iterating/when the matrix indices have stabilized
%   Each return value is a num_images X num_images matrix

function [D_prime, D_prime_prime] = prime_distance(D, m_weight, p, ...
                                                   alpha, pp_thresh)
    %% Subsequence matching to preserve dynamics
    s = m_weight * 2;
    w = zeros(1, s);
    for i=1:s
        w(1, i) = nchoosek(s-1,i-1);
    end
    
    w = w./ sum(w);
    
    for i = 1:num
        for j = 1:num
            sum_weights = 0;
            for k = -m_weight:m_weight-1
                w_index = k + m_weight + 1;
                % Check for D out of bounds - if out of bounds,
                % don't include that weight
                if (i+k < 1) || (j+k < 1) || (i+k > num) || (j+k> num)
                    weight = 0;
                else 
                    weight = w(w_index) * D(i+k, j+k);
                end
                sum_weights = sum_weights + weight;
            end
            D_prime(i,j) = sum_weights;
        end
    end
    
    %% Avoiding dead ends and anticipating the future
    D_prime_prime = D_prime;
    D_pp_prev = D_prime;
    
    diff = pp_thresh;
    diff_prev = pp_thresh;

    while diff >= pp_thresh && diff_prev >= diff
        for i=num:-1:1
            for j=1:num
                mj = Inf;
                for k=1:num
                    if j ~= k && D_prime_prime(j,k) < mj
                        mj = D_prime_prime(j,k);
                    end
                end
               D_prime_prime(i,j) = D_prime(i,j)^p + alpha * mj;
            end  
        end
        diff = sumabs(D_prime_prime - D_pp_prev);
        diff_prev = diff;
        D_pp_prev = D_prime_prime;
    end

end