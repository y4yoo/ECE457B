fieldDimensions = [10 10];
startingCoords = [ 4 4];
goalCoord = [ 4 9 ];

obstacles = zeros(4, 2, 1) * NaN;    % 3 obstacles, max 4 vertices in each obstacle
obstacles(:,:,1) = [ 5 8; 3 5; 7 5; NaN NaN ];

RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, 2)