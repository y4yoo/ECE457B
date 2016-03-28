function [output] = inGrid(x, y, grid)
    output = true;
    [m,n] = size(grid);
    if x < 1 || x > m
        output = false;
    end
    if y < 1 || y > n
        output = false;
    end
end

