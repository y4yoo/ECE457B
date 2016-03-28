function [blockedDirection] = blockedDirection(delta_x,delta_y)
%BLOCKEDDIRECTION 
% 8 cases for 8 directions:
% - 0 is east
% - 1 is south-east
% - 2 is south
%   .
%   .
%   .
    blockedDirection = 0;
    
    if delta_x >= 0
        slope = delta_y/delta_x;
        if slope > 2.41
            blockedDirection = 6;
        elseif slope > .414
            blockedDirection = 7;
        elseif slope > -.414
            blockedDirection = 0;
        elseif slope > -2.41
            blockedDirection = 1;
        else
            blockedDirection = 2;
        end
    else
        slope = delta_y/delta_x;
        if slope > 2.41
            blockedDirection = 2;
        elseif slope > .414
            blockedDirection = 3;
        elseif slope > -.414
            blockedDirection = 4;
        elseif slope > -2.41
            blockedDirection = 5;
        else
            blockedDirection = 6;
        end
    end
end

