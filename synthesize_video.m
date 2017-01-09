%
% synthesize_video.m
%   Takes the name of a folder and loop 
%   transitions and synthesizes them into a video.

function synthesize_video(name, transitions, video_name)
    cd(fullfile('./images/', name));
    imDir = pwd();
    files = dir(imDir);
    num = size(files);
    num = num(1) - 2;
    
    cd('../../textures');
    vidDir = pwd();
    
    cd('../videos');
    old_vid = VideoReader([name '.mp4']);
    
    cd('..');
    
    images = cell(num, 1);
    for i = 1:num
        img = imread(fullfile(imDir,[sprintf('%03d', i) '.jpg']));
        images{i} = img;
    end
                   
	video = VideoWriter(fullfile(vidDir, [video_name '.avi']));
    video.FrameRate = old_vid.FrameRate;
    open(video);
    
    i = 1;
    t_num = 1; % Transition number we're on
    while i <= num
        writeVideo(video, images{i});    
        if t_num <= size(transitions, 1) && (i == transitions(t_num, 1))
            i = transitions(t_num, 2);
            t_num = t_num + 1;
        else
            i = i + 1;
        end
    end
    
    close(video);
end