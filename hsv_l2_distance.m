%
% hsv_l2_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using L2 distance metric and HSV images, comparing each individual
%   pixel on the H S and V scales.

function D = hsv_l2_distance(images)
    num = size(images, 1);
    
    D = zeros(num);
    [h,w] = size(images{1}(:,:,1));
    
    % Frame-to-frame distance calculation
    % Convert to greyscale, find euclidean distance between histograms
    for i = 1:num
        im1 = rgb2hsv(images{i});
        for j = i:num
            if i == j
                D(i, j) = 0;
                D(j, i) = 0;
            else
                im2 = rgb2hsv(images{j});
                sum_h = 0;
                sum_s = 0;
                sum_v = 0;
                
                for r = 1:h
                    for c = 1:w
                        sum_h = sum_h + (im1(r, c, 1) - im2(r, c, 1))^2;
                        sum_s = sum_s + (im1(r, c, 2) - im2(r, c, 2))^2;
                        sum_v = sum_v + (im1(r, c, 3) - im2(r, c, 3))^2;
                    end
                end
                % Can try weighting them differently if desired
                dist = sqrt(sum_h + sum_s + sum_v);
                D(i, j) = dist;
                D(j, i) = dist;
            end
        end    
    end