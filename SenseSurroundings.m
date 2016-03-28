function [sensed_grid] = SenseSurroundings(x,y,grid)
%SENSE SURROUNDINGS
%Inputs:
%   x: x-coordinate of robot
%   y: y-coordinate of robot
%   grid: grid values (m x n matrix)

%Outputs:
%   sensed_grid: m x n matrix of what the robot senses
%   - value are fuzzy memberships in intervals [0,1]
%       - 1 is 100% of obstace
%       - 0 is 100% of free space
%       - 0.5 is no confidence
    [m,n] = size(grid);
    grid(x,y) = 88;
    
%   membership based purely on disance from robot
    d_grid = zeros(m,n);
    d_grid(x,y) = 88;

    
    
    for i = 1:max(m,n)
        for j = 0:i
            for k = -j:j
                for l = -j:j
                    if k == i || k == -i || l == i || l == -i
                        if inGrid(x+k, y+l, grid)
                            value = .5 *(1.2^-(i-1)) + .5;
                            if grid(x+k, y+l) == 0
                                d_grid(x+k, y+l) = 1 - value;
                            end
                            if grid(x+k, y+l) == 1
                                d_grid(x+k, y+l) = value;
                            end
                        end
                    end
                end
            end
        end
    end
    
%   membership based purely on obstacles blocking robot's view
    o_grid = grid;
    o_grid(x,y) = 88;
    
    for i = 1:m
        for j = 1:n
            if grid(i,j) == 1
                delta_x = i-x;
                delta_y = j-y;
                blocked_direction = blockedDirection(delta_x,delta_y)
                o_grid = blockVision(i,j,blocked_direction,o_grid);
            end
        end
    end
    
    grid
    d_grid
    o_grid
%   Take the values that are more uncertain 
    sensed_grid = zeros(m, n);
    for i = 1:m
        for j = 1:n
            if abs(.5 - d_grid(i,j)) > abs(.5 - o_grid(i,j))
                sensed_grid(i,j) = o_grid(i,j);
            else
                sensed_grid(i,j) = d_grid(i,j);
            end
        end
    end
    sensed_grid
end

