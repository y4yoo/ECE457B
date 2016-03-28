function [grid] = Setup(x, y)
%SETUP 
% - init the problem 
%   - Create grid of size (x, y)
%   - Make obstacles (represented by 1's)

    grid = zeros(x, y);
    for i = 1:x
        for j = 1:y
            random = rand;
            threshold = 0.5;
            if (i > 1 && grid(i-1,j) == 1)
                threshold = threshold + 0.3;
            end
            if (j > 1 && grid(i,j-1) == 1)
                threshold = threshold + 0.3;
            end
            if (i > 1 && j > 1 && grid(i-1,j-1) == 1)
                threshold = threshold + 0.3;
            end
            if (random > threshold)
                grid(i,j) = 1;
            end
        end
    end
end

