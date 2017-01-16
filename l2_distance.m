%
% l2_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using L2 distance metric.
%   name - String of folder name
%   Return value is a num_images X num_images matrix

function D = l2_distance(ims)
    num = size(ims,1);
    
    D = zeros(num);
    D_prime = zeros(num);
    D_prime_prime = zeros(num);
    
    %% Frame-to-frame distance calculation
    % Convert to greyscale, find euclidean distance between histograms
    for i = 1:num
        im1 = ims{i};
        im1 = rgb2gray(im1);
        hist1 = imhist(im1)./numel(im1);
        for j = i:num
            if i == j
                D(i, j) = 0;
                D(j, i) = 0;
            else
                im2 = ims{j};
                im2 = rgb2gray(im2);
                hist2 = imhist(im2)./numel(im2);
                dist = norm(hist1 - hist2);
                D(i, j) = dist;
                D(j, i) = dist;
            end
        end
        i
    end  
end