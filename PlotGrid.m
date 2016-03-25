function [] = PlotGrid(grid)
%PLOT
% - graph the map
%   - obstacles are red
    hold on
    [m,n] = size(grid);
    for i = 1:m
        for j = 1:n
            if(grid(i,j) == 1)
                scatter(i,j,30,'red','filled');
            end
        end
    end
end

