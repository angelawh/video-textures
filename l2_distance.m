%
% l2_distance.m
%   Creates distance matrices between pairs of images in folder images/name
%   using L2 distance metric.
%   name - String of folder name
%   m_weight - dynamics kernel weight. Should be 1 or 2
%   p - some transition something
%   alpha - related to future cost
%   Each return value is a num_images X num_images matrix

function [D, D_prime, D_prime_prime] = l2_distance(name, m_weight, p, alpha)
    cd(fullfile('./images/', name));
    curDir = pwd();
    
    % Count number of images
    files = dir(curDir);
    num = size(files);
    num = num(1) - 2;
    
    D = zeros(num);
    D_prime = zeros(num);
    D_prime_prime = zeros(num);
    
    % Frame-to-frame distance calculation:
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
    
    % Subsequence matching to preserve dynamics



end