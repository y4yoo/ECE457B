fieldDimensions = [20 20];
startingCoords = [ 1 1];
goalCoord = [ 17 17 ];

obstacles = zeros(5, 2, 3) * NaN;    % 3 obstacles, max 4 vertices in each obstacle
obstacles(:,:,1) = [ 5 8; 3 5; 7 5; NaN NaN; NaN NaN ];
obstacles(:,:,2) = [ 10 10; 10 14; 14 14; 14 10; NaN NaN ];
obstacles(:,:,3) = [ 8.5 5.5; 8.5 7.5; 16 7.5; 16 5.5; NaN NaN ];

RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, 2)