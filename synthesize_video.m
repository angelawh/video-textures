%
% synthesize_video.m
%   Takes the name of a folder and loop 
%   transitions and synthesizes them into a video.

function synthesize_video(images, transitions, old_vid_name, video_name,...
                                                crossfade, fade_l)
   
    num = size(images,1);
    
    cd('./textures');
    vidDir = pwd();
    
    cd('../videos');
    old_vid = VideoReader([old_vid_name '.mp4']);
    
    cd('..');
                   
	video = VideoWriter(fullfile(vidDir, [video_name '.avi']));
    video.FrameRate = old_vid.FrameRate;
    open(video);
    
    % Create linear distribution of length fade_l * 2 + 1
    if crossfade
        dist_size = fade_l * 2 + 1;
        fade_distribution = zeros(dist_size);
        factor = 0.5 / (fade_l + 1);
        for i = 1:fade_l
            fade_distribution(i) = factor * i;
            fade_distribution(dist_size + 1 - i) = 0.5 + factor * i;
        end
        fade_distribution(fade_l+1) = 0.5;  
    end
    
    i = 1;
    t_num = 1; % Transition number we're on
    while i <= num
        
        if crossfade
            crossfade_frame(images, i, t_num, transitions, fade_l, ...
                                            fade_distribution, video);
        else
            writeVideo(video, images{i});
        end
        
        if t_num <= size(transitions, 1) && (i == transitions(t_num, 1))
            i = transitions(t_num, 2);
            t_num = t_num + 1;
        else
            i = i + 1;
        end
    end
    
    close(video);
end

function crossfade_frame(images, i, t_num, transitions, fade_l, ...
                                        fade_distribution, video)
    num = size(images,1);
    
    if t_num <= size(transitions, 1) && (i >= transitions(t_num,1) ...
                - fade_l) && (i <= transitions(t_num,1) +fade_l)
            
        offset = transitions(t_num,1) - i;
     	index = fade_l - offset + 1;
            
     	dest = transitions(t_num,2) - offset;
       	if dest < 1 || dest > num
            writeVideo(video, images{i});  
        else
        	im1 = images{dest} * fade_distribution(index);
          	im2 = images{i} * (1 - fade_distribution(index));
          	writeIm = im1 + im2;
          	writeVideo(video, writeIm);  
        end   
    else
      	writeVideo(video, images{i});
  	end

end