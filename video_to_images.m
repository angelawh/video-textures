%
% video_to_images.m
%   Read in a video with name name from the videos/ folder 
%   and save it to a new folder in the images/ folder
%   as a sequence of images.
%

function video_to_images(name)

    cd('./videos');
    video = VideoReader(name);
    
    shortName = name(1:end-4);
    
    cd('../images');
    imagesDir = pwd();
    
    mkdir(imagesDir,shortName);
    
    ii = 1;

    while hasFrame(video)
       img = readFrame(video);
       filename = [sprintf('%03d',ii) '.jpg'];
       fullname = fullfile(imagesDir,shortName,filename);
       imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
       ii = ii+1;
    end