%
% im_euclid_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using 

function D = im_euclid_distance(images)
    num = size(images, 1);
    
    D = zeros(num);
    
    im_h = size(images{1}, 1);
    im_w = size(images{1}, 2);
    
    gray_images = images;
    
%     G = zeros(im_h, im_w);
%     for m = 1:im_h
%         for n = 1:im_w
%             G(m,n) = exp(-norm(m - n)^2/2) / (2 * pi);
%         end
%    	end
    
    % Frame-to-frame distance calculation
    % Convert to greyscale, find image euclidean distance
    for i = 1:num
        i
        if i == 1
            gray_images{i} = im2double(rgb2gray(images{i}));
        end
        im1 = gray_images{i};
        for j = i:num
            if i == j
                D(i, j) = 0;
                D(j, i) = 0;
            else
                
                if i == 1
                    gray_images{j} = im2double(rgb2gray(images{j}));
                    
                end
                im2 = gray_images{j};
                
                dist = 0;
%                 dist = (im1 - im2)' * G;
%                 dist = sqrt(sum(sum(dist)));
                
                
                for m = 1:im_h
                    for n = 1:im_w
                        dist = dist + exp(-norm(m - n)^2/2) * ...
                                            (im1(m,n) - im2(m,n))^2;
                    end
                end
                dist = sqrt(dist / (2 * pi));
                
                D(i, j) = dist;
                D(j, i) = dist;
            end
        end
    end
end