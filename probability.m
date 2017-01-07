%
% probability.m
%   Equalizes brightness across all images in folder images/name.
%

function P = probability(D, sigma_multiplier)
    % Set sigma to a small multiple of the average non-zero D values
    num_elements = 0;
    sum = 0;
    for i = 1:size(D,1)
        for j = 1:size(D,1)
            if D(i,j) ~=0
                sum = sum + D(i,j);
                num_elements = num_elements + 1;
            end
        end
    end
    
    sigma = sigma_multiplier * sum / num_elements;
    
    P = exp(-D ./ sigma);
end