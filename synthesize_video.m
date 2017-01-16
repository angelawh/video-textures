%
% synthesize_video.m
%   Takes the name of a folder and loop 
%   transitions and synthesizes them into a video.

function synthesize_video(images, transitions, old_vid_name, video_name)
   
    num = size(images,1);
    
    cd('./textures');
    vidDir = pwd();
    
    cd('../videos');
    old_vid = VideoReader([old_vid_name '.mp4']);
    
    cd('..');
                   
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