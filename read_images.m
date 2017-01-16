%
% read_brightness.m
%   Reads images from start to finish in folder images/name and saves
%   them to cell array. If NaN or out of bounds, start value defaults to
%   1 if argument finish value defaults to the number of image files.
%   Start and finish are optional values to specify the start and end 
%    images if you want to analyze a subsequence of the image. If either
%    is NaN, will analyze all parts of image.
%   Resize is the resize factor if want to make images larger or smaller
%    for calculations. If NaN, will just return as NaN.


function [images,resized_images] = read_images(name, start, finish, resize)

    cd(fullfile('./images/', name));
    curDir = pwd();

    files = dir(curDir);
    num = size(files);
    num = num(1) - 2;
    
    images = cell(num, 1);
    resized_images = images;
    
    if isnan(start) || isnan(finish) || start<1 || start > num || ...
                                            finish < 1 || finish > num
        start = 1;
        finish = num;
    end
    
    for i = start:finish
        img = imread(fullfile(curDir,[sprintf('%03d', i) '.jpg']));
        images{i} = img;
        
        if ~isnan(resize)
            resized_images{i} = imresize(img, resize);
        end
    end
    
    if isnan(resize)
        resized_images = NaN;
    end
    
    % Change the directory back
    cd('../..');
end