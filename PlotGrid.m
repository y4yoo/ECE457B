function [] = PlotGrid(grid)
%PLOT
% - graph the map
%   - obstacles are red
    hold on
    [m,n] = size(grid);
    for i = 1:m
        for j = 1:n
            if (grid(i,j) == 1)
                %scatter(i,j,30,'red','filled');
                rectangle('Position',[i-1 j-1 1 1], 'FaceColor', [0 0 0]);
            end
        end
    end
    axis([0 m 0 n]);
end

