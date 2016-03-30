fieldDimensions = [12 14];
startingCoords = [ 6 11 ];
goalCoord = [ 1 1 ];

obstacles = zeros(16, 2, 6) * NaN;    % 3 obstacles, max 4 vertices in each obstacle
obstacles(:,:,1) = [ 1 3; 1.2 3.2; 3.2 1.2; 3 1; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,2) = [ 2 7; 2 8; 3 8; 3 7; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,3) = [ 4 2.5; 4 6.5; 6 4.5; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,4) = [ 5 2; 5 2.5; 7 2.5; 7 6.5; 5 6.5; 5 7; 8 7; 8 2; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,5) = [ 9 1; 9 4.5; 10 1; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,6) = [ 9 6; 9 8; 9.5 8; 9.5 6.5; 11 6.5; 11 6; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,6) = [ 4 13; 4 9; 8 9; 8 13; 5 13; 5 10; 7 10; 7 12; 6.5 12; 6.5 10.5; 5.5 10.5; 5.5 12.5; 7.5 12.5; 7.5 9.5; 4.5 9.5; 4.5 13 ];

RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, 2)