%
% hsv_l2_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using L2 distance metric and HSV images, comparing each individual
%   pixel on the H S and V scales.

function D = hsv_l2_distance(images)
    num = size(images, 1);
    
    D = zeros(num);
    
    hsv_images = images;
    
    % Frame-to-frame distance calculation
    % Convert to greyscale, find euclidean distance between histograms
    for i = 1:num
        i
        if i == 1
            hsv_images{i} = rgb2hsv(images{i});
        end
        im1 = hsv_images{i};
        for j = i:num
            if i == j
                D(i, j) = 0;
                D(j, i) = 0;
            else
                if i == 1
                    hsv_images{j} = rgb2hsv(images{j});
                end
                im2 = hsv_images{j};
                dist = sqrt(sum(sum((im1(:,:,1) - im2(:,:,1)).^2)) + ...
                            sum(sum((im1(:,:,2) - im2(:,:,2)).^2)) + ...
                            sum(sum((im1(:,:,3) - im2(:,:,3)).^2)));
                D(i, j) = dist;
                D(j, i) = dist;
            end
        end
    end
end