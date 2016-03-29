% Author: William Mayo

function RunSimulation(fieldDimensions, obstacles, startingCoords, goalCoord, visibilityRadius)
    simFig = figure();
    h = plot(1:fieldDimensions(1),0);
    axis([0 fieldDimensions(1) 0 fieldDimensions(2)]);
    hold on;
    set(h,'linewidth',2);

    % plot each obstacle
    for i = 1:size(obstacles,3)
        lastIndex = 1;
        for j = 2:size(obstacles,1)
            if isnan(obstacles(j,:,i))
                break;
            end
            lastIndex = lastIndex + 1;
            plot([obstacles(j-1,1,i) obstacles(j,1,i)], [obstacles(j-1,2,i) obstacles(j,2,i)], '-r');
        end
        % make sure to include the edge that wraps around
        plot([obstacles(1,1,i) obstacles(lastIndex,1,i)], [obstacles(1,2,i) obstacles(lastIndex,2,i)], '-r');
    end
    
    %add markers for starting and ending positions
    plot(goalCoord(1), goalCoord(2), 'Xg');
    for i=1:size(startingCoords,1)
        plot(startingCoords(i,1), startingCoords(i,2), 'og');
    end
    
    [obstacleEdges] = getObstacleEdges(obstacles, fieldDimensions);
    
    reachedDestination = 0;
    
    position = startingCoords;
    direction = pi/2;
    velocity = 0;
    
    %Define output fuzzy fuctions
    accelRange = 0:0.05:2;
    turnRange = -pi/9:pi/108:pi/9;
    
    posLAccel = gaussmf(accelRange, [0.25 2]);
    posAccel = gaussmf(accelRange, [0.25 1]);
    constAccel = gaussmf(accelRange, [0.25 0]);
    
    left = gaussmf(turnRange, [0.05 -pi/9]);
    smallLeft = gaussmf(turnRange, [0.05 -pi/18]);
    straight = gaussmf(turnRange, [0.05 0]);
    smallRight = gaussmf(turnRange, [0.05 pi/18]);
    right = gaussmf(turnRange, [0.05 pi/9]);
    
    %plot output graphs
    figure('Name','Acceleration');
    hold on;
    plot(accelRange, posLAccel);
    plot(accelRange, posAccel);
    plot(accelRange, constAccel);
    figure('Name','Turn Direction');
    hold on;
    plot(turnRange, left);
    plot(turnRange, smallLeft);
    plot(turnRange, straight);
    plot(turnRange, smallRight);
    plot(turnRange, right);
    
    TIME_PER_TICK = 0.1; % time in sec per iterations
    
    set(0,'CurrentFigure',simFig);
    hold on;
    
    while ~reachedDestination
        % Get distance and angle of closest obstacle
        [dist angle] = getVisibleObstacleDistAng(position, direction,visibilityRadius, obstacleEdges);
        distToTarget = sqrt((goalCoord(1) - position(1))^2+(goalCoord(2) - position(2))^2);
        angleToTarget = atan(abs(goalCoord(2) - position(2))/abs(goalCoord(1) - position(1)));
        diffAngleToTarget = angle - angleToTarget;
        
        diffAngleToTarget = diffAngleToTarget * 180/pi; %convert radians to degrees
        
        % Fuzzify input readings
        
        %angle of obstacle
        straightToObj = generateMF(angle, 0, -15);
        slightLeftToObj = generateMF(angle, -10, -15);
        leftToObj = generateMF(angle, -20, -15);
        slightRightToObj = generateMF(angle, 10, -15);
        rightToObj = generateMF(angle, 20, -15);
        
        %distance of obstacle
        closeToObj = generateMF(dist, 0, -1/4);
        mediumToObj = generateMF(dist, 1, -1/4);
        farToObj = generateMF(dist, 2, -1/4);
        farToObj = 1; % remove
        
        %distance to target
        closeToTar = generateMF(distToTarget, 0, -10);
        mediumToTar = generateMF(distToTarget, 10, -20);
        farToTar = generateMF(distToTarget, 20, -20);
        
        %angle of target
        straightT = generateMF(diffAngleToTarget, 0, -15);
        slightLeftT = generateMF(diffAngleToTarget, -10, -15);
        leftT = generateMF(diffAngleToTarget, -20, -15);
        slightRightT = generateMF(diffAngleToTarget, 10, -15);
        rightT = generateMF(diffAngleToTarget, 20, -15);
         
        %evaluate rules 
        
        %When object is very far
        rule0 = min([farToObj farToTar]); % then fast accel
        rule1 = min([farToObj mediumToTar]); % then const accel
        rule2 = min([farToObj closeToTar]); % then negative accel
        
        rule3 = min([farToObj straightT]); % then no turn
        rule4 = min([farToObj slightLeftT]); % then turn a bit left
        rule5 = min([farToObj leftT]); % then turn a lot left
        rule6 = min([farToObj slightRightT]); % then turn a bit right
        rule7 = min([farToObj rightT]); % then turn a bit left
        
        % defuzzify
        
        %acceleration
        posLAccelY = max([rule0]);
        posAccelY = max([rule1]);
        constAccelY = max([rule2]);
        
        %angle
        leftY = max([rule3]);
        smallLeftY = max([rule4]);
        straightY = max([rule5]);
        smallRightY = max([rule6]);
        rightY = max([rule7]);
         
        acceleration = defuzz(accelRange,max(posLAccelY*posLAccel,max(posAccelY*posAccel, constAccelY*constAccel)), 'centroid');
        dAngle = defuzz(turnRange, ....
            max(leftY*left, ...
            max(smallLeftY*smallLeft, ...
            max(straightY*straight, ...
            max(smallRightY*smallRight, rightY*right)))), 'centroid');
        
        dAngle = dAngle*pi/180;
        
        % update velocity, direction and current position for next tick
        velocity = velocity + acceleration;
        angle = angle + dAngle;
        position(1) = position(1) + TIME_PER_TICK*velocity*cos(angle);
        position(2) = position(2) + TIME_PER_TICK*velocity*sin(angle);
        
        plot(position(1), position(2), 'og');
    end
end

function [obstacleEdges] = getObstacleEdges(obstacles, fieldDimensions)
    %Generate a list of all edges in obstacles
    obstacleEdges = [0 0 fieldDimensions(1) 0];
    for i = 1:size(obstacles,3)
        lastIndex = 1;
        
        for j = 2:size(obstacles,1)
            if isnan(obstacles(j,:,i))
                break;
            end
            lastIndex = lastIndex + 1;
            obstacleEdges = [obstacleEdges ; obstacles(j-1,:,i) obstacles(j,:,i)]; 
        end
        
        % make sure to include the edge that wraps around
        obstacleEdges = [obstacleEdges ; obstacles(1,:,i) obstacles(lastIndex,:,i)];
    end
    %Add map edges
    obstacleEdges = [obstacleEdges; 0 fieldDimensions(2) fieldDimensions(1) fieldDimensions(2)];
    obstacleEdges = [obstacleEdges; 0 0 0 fieldDimensions(2)];
    obstacleEdges = [obstacleEdges; fieldDimensions(1) 0 fieldDimensions(1) fieldDimensions(2)];
end

function [dist angle] = getVisibleObstacleDistAng(pos, direction, radius, obstacleEdges)
    dist = Inf;
    angle = 0;
    
    scanAngle = direction - pi/9; %20 degrees
    for j = 1:40
        for i = 1:size(obstacleEdges,1)
            edge = obstacleEdges(i,:);
            
            rayX2 = pos(1)+(radius*cos(scanAngle));
            rayY2 = pos(2)+(radius*sin(scanAngle));
            
            [xInt yInt] = polyxpoly([pos(1) rayX2],[pos(2) rayY2],[edge(1) edge(3)],[edge(2) edge(4)]);
            %plot([pos(1) rayX2],[pos(2) rayY2]);
            %if intercept distance is smallest, store it
            intDist = sqrt((xInt - pos(1))^2+(yInt-pos(2))^2);
            if intDist < dist
                dist = intDist;
                angle = scanAngle;
            end
        end
        scanAngle = scanAngle + pi/180;
    end
end
