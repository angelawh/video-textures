%
% equalize_brightness.m
%   Equalizes brightness across all images in folder images/name.
%

function equalize_brightness(name)
    cd(fullfile('./images/', name));
    curDir = pwd();
    
    im_orig = imread(fullfile(curDir, '001.jpg'));
    
    files = dir(curDir);
    num = size(files);
    num = num(1) - 2;
    
    for i = 2:num
        fullname = fullfile(curDir, [sprintf('%03d',i) '.jpg']);
        im_new = imread(fullname);
        output = imhistmatch(im_new, im_orig);
        imwrite(output, fullname);
    end
end