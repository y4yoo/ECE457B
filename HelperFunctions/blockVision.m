function [output_grid] = blockVision(x,y,direction,grid)
%BLOCKVISION 
    [m,n] = size(grid);
    output_grid = grid;
    switch direction
        case 0
            for i = 1:m
                if inGrid(x+i,y,grid)
                    output_grid(x+i,y) = .5;
                end
            end
        case 1
            for k = 1:max(m,n)
                if inGrid(x+k,y-k,grid)
                    output_grid(x+k,y-k) = .5;
                end
            end
        case 2
            for j = 1:n
                if inGrid(x,y-j,grid)
                    output_grid(x,y-j) = .5;
                end
            end
        case 3
            for k = 1:max(m,n)
                if inGrid(x-k,y-k,grid)
                    output_grid(x-k,y-k) = .5;
                end
            end
        case 4
            for i = 1:m
                if inGrid(x-i,y,grid)
                    output_grid(x-i,y) = .5;
                end
            end
        case 5
            for k = 1:max(m,n)
                if inGrid(x-k,y+k,grid)
                    output_grid(x-k,y+k) = .5;
                end
            end
        case 6
            for j = 1:n
                if inGrid(x+j,y,grid)
                    output_grid(x,y+j) = .5;
                end
            end
        case 7
            for k = 1:max(m,n)
                if inGrid(x+k,y+k,grid)
                    output_grid(x+k,y+k) = .5;
                end
            end
        otherwise
    end
end

