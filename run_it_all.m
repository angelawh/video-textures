%run_it_all.m

function run_it_all(name, video_name, resize, m_weight, local_size, ...
                    cost_thresh, num_transitions, length)

    

    [images,resized_images] = read_images(name, NaN, NaN, resize);

    D = hsv_l2_distance(resized_images);
    %or
    %D = l2_distance(ims);
    
    D_prime = prime_distance(D, m_weight, NaN, NaN, NaN);
    
    primitive_loops = prune(D_prime, D_prime, local_size, cost_thresh, ...
                               num_transitions);
                           
    transitions = select_transitions(primitive_loops, length);
    
    ordered_transitions = schedule_transitions(transitions);
    
    synthesize_video(resized_images, ordered_transitions, name, video_name);



end

