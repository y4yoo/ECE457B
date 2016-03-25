function [grid] = Setup(x, y)
%SETUP 
% - init the problem 
%   - Create grid of size (x, y)
%   - Make obstacles (represented by 1's)

    grid = zeros(x, y);
    for i = 1:x
        for j = 1:y
            random = rand;
            if(random > 0.5)  
                grid(i,j) = 1;
            end
        end
    end
end

