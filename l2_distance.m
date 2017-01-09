%
% l2_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using L2 distance metric.
%   name - String of folder name
%   m_weight - dynamics kernel weight. Should be 1 or 2
%   p - some transition something
%   alpha - related to future cost
%   pp_thresh - the threshold for D'' that determines when to stop
%    iterating/when the matrix indices have stabilized
%   Each return value is a num_images X num_images matrix

function [D, D_prime, D_prime_prime] = l2_distance(name, m_weight, p, ...
                                                   alpha, pp_thresh)
    cd(fullfile('./images/', name));
    curDir = pwd();
    
    % Count number of images
    files = dir(curDir);
    num = size(files);
    num = num(1) - 2;
    
    D = zeros(num);
    D_prime = zeros(num);
    D_prime_prime = zeros(num);
    
    %% Frame-to-frame distance calculation
    % Convert to greyscale, find euclidean distance between histograms
    for i = 1:num
        im1 = imread(fullfile(curDir, [sprintf('%03d', i) '.jpg']));
        im1 = rgb2gray(im1);
        hist1 = imhist(im1)./numel(im1);
        for j = i:num
            if i == j
                D(i, j) = 0;
                D(j, i) = 0;
            else
                im2 = imread(fullfile(curDir, [sprintf('%03d',j ) '.jpg']));
                im2 = rgb2gray(im2);
                hist2 = imhist(im2)./numel(im2);
                dist = norm(hist1 - hist2);
                D(i, j) = dist;
                D(j, i) = dist;
            end
        end    
    end
    
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
    
    % Change the directory back
    cd('../..');
end