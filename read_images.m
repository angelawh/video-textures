%
% read_brightness.m
%   Reads images from start to finish in folder images/name and saves
%   them to cell array. If NaN or out of bounds, start value defaults to
%   1 if argument finish value defaults to the number of image files.
%


function images = read_images(name, start, finish)

    cd(fullfile('./images/', name));
    curDir = pwd();

    files = dir(curDir);
    num = size(files);
    num = num(1) - 2;
    
    
    images = cell(num, 1);
    
    if isnan(start) || isnan(finish) || start<1 || start > num || ...
                                            finish < 1 || finish > num
        start = 1;
        finish = num;
    end
    
    for i = start:finish
        img = imread(fullfile(curDir,[sprintf('%03d', i) '.jpg']));
        images{i} = img;
    end
    
    % Change the directory back
    cd('..');
end