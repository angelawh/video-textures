% run_it_all.m
% Creates crossfaded and non-faded versions using all 3 distance metrics

function run_it_all(name, video_name, resize, start, finish, m_weight, ...
                        local_size, num_transitions, length, fade_l)

    [images,resized_images] = read_images(name, start, finish, resize);

    %% Create l2 distance black/white videos
    D = l2_distance(images);
    
    D_prime = prime_distance(D, m_weight, NaN, NaN, NaN);
    
    cost_thresh = .1; % For L2 distance
    primitive_loops = prune(D_prime, D_prime, local_size, cost_thresh, ...
                               num_transitions);
                           
    transitions = select_transitions(primitive_loops, length);
    
    ordered_transitions = schedule_transitions(transitions);
    
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_bwl2_nofade'], false, fade_l);
                            
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_bwl2_fade'], true, fade_l);
    
    %% Create hsv hist distance
    D_hist = hsv_l2_distance(resized_images);
    
    D_prime = prime_distance(D_hist, m_weight, NaN, NaN, NaN);
    
    cost_thresh = 100; % For hsv distance
    primitive_loops = prune(D_prime, D_prime, local_size, cost_thresh, ...
                               num_transitions);
                           
    transitions = select_transitions(primitive_loops, length);
    
    ordered_transitions = schedule_transitions(transitions);
    
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_hsvdist_nofade'], false, fade_l);
                            
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_hsvdist_fade'], true, fade_l);
                 
    %% Create Euclid dist videos
    D_euclid = im_euclid_distance(resized_images);
    
    D_prime = prime_distance(D_euclid, m_weight, NaN, NaN, NaN);
    
    cost_thresh = 1; % For euclid distance
    primitive_loops = prune(D_prime, D_prime, local_size, cost_thresh, ...
                               num_transitions);
                           
    transitions = select_transitions(primitive_loops, length);
    
    ordered_transitions = schedule_transitions(transitions);
    
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_iedist_nofade'], false, fade_l);
                            
    synthesize_video(images, ordered_transitions, name, ...
                     [video_name, '_iedist_fade'], true, fade_l);


end

