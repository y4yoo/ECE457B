while (1)
    
fieldDimensions = [22 20];
startingCoords = [ 1 1];
goalCoord = [ 17 17 ];

obstacles = zeros(5, 2, 3) * NaN;    % 3 obstacles, max 4 vertices in each obstacle
obstacles(:,:,1) = [ 5 8; 3 5; 7 5; NaN NaN; NaN NaN ];
obstacles(:,:,2) = [ 10 10; 10 14; 18 14; 18 10; NaN NaN ];
obstacles(:,:,3) = [ 8.5 5.5; 8.5 7.5; 16 7.5; 16 5.5; NaN NaN ];

RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, 2)

fieldDimensions = [12 14];
startingCoords = [ 1 1 ];
goalCoord = [ 9.5 4.5 ];

obstacles = zeros(16, 2, 6) * NaN;    % 3 obstacles, max 4 vertices in each obstacle
obstacles(:,:,1) = [ 1 3; 1.2 3.2; 3.2 1.2; 3 1; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,4) = [ 5 2; 5 2.5; 7 2.5; 7 6.5; 7 7; 8 7; 8 2; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];
obstacles(:,:,6) = [ 9 6; 9 8; 9.5 8; 9.5 6.5; 11 6.5; 11 6; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN ];

RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, 2)

end