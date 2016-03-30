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
    accelRange = 0:0.005:4;
    turnRange = -pi/9:pi/243:pi/9;
    
    posLAccel = smf(accelRange, [2.5 4]);
    posAccel = gaussmf(accelRange, [0.6 2]);
    constAccel = zmf(accelRange, [0 1.5]);
    
    left = zmf(turnRange, [-pi/9 -1.5*pi/18]);
    smallLeft = gaussmf(turnRange, [0.05 -pi/18]);
    straight = gaussmf(turnRange, [0.05 0]);
    smallRight = gaussmf(turnRange, [0.05 pi/18]);
    right = smf(turnRange, [1.5*pi/18 pi/9]);
    
    TIME_PER_TICK = 0.1; % time in sec per iterations
    
    set(0,'CurrentFigure',simFig);
    hold on;
    
    timeM = zeros(10000,1);
    time = 0;
    velVsTime = zeros(10000,1);
    directionVTime = zeros(10000,1);
    tarDistVTime = zeros(10000,1);
    iteration = 1;
    
    %reachedDestination = 1;
    
    while ~reachedDestination
        % Get distance and angle of closest obstacle
        [dist angle] = getVisibleObstacleDistAng(position, direction,visibilityRadius, obstacleEdges);
        distToTarget = sqrt((goalCoord(1) - position(1))^2+(goalCoord(2) - position(2))^2);
        angleToTarget = atan(abs(goalCoord(2) - position(2))/abs(goalCoord(1) - position(1)));
        
        if (goalCoord(1) < position(1) && goalCoord(2) < position(2))
            angleToTarget = angleToTarget + pi;
        elseif goalCoord(1) < position(1)
            angleToTarget = (pi/2 - angleToTarget) + pi/2;
        elseif goalCoord(2) < position(2)
            angleToTarget = (pi/2 - angleToTarget) + 3*pi/2;
        end
        
        diffAngleToTarget = direction - angleToTarget;
        
        if diffAngleToTarget > pi
            diffAngleToTarget = 2*pi - diffAngleToTarget;
        elseif diffAngleToTarget < -pi
            diffAngleToTarget = 2*pi + diffAngleToTarget;
        end
        
        diffAngleToTarget = diffAngleToTarget * 180/pi; %convert radians to degrees
        angle = angle * 180/pi;
        % Fuzzify input readings
        
        %angle of obstacle
        leftToObj = zmf(angle, [-20 -15]);
        slightLeftToObj = generateMF(angle, -10, -15);
        straightToObj = generateMF(angle, 0, -15);
        slightRightToObj = generateMF(angle, 10, -15);
        rightToObj = smf(angle, [15 20]);
        
        %distance of obstacle
        closeToObj = zmf(dist, [0 0.75]);
        mediumToObj = generateMF(dist, 1, -1/4);
        farToObj = smf(dist, [1.25 2]);
        
        %distance to target
        closeToTar = zmf(distToTarget, [0 1]);
        mediumToTar = generateMF(distToTarget, 1.5, -0.5);
        farToTar = smf(distToTarget, [2 3]);
        
        %angle of target
        straightT = generateMF(diffAngleToTarget, 0, -15);
        slightLeftT = generateMF(diffAngleToTarget, -10, -15);
        leftT = zmf(diffAngleToTarget, [-20 -15]);
        slightRightT = generateMF(diffAngleToTarget, 10, -15);
        rightT = smf(diffAngleToTarget, [15 20]);
         
        %evaluate rules 
        
        %When object is very far
        rule0 = min([farToObj farToTar]); % then fast accel
        rule1 = min([farToObj mediumToTar]); % then const accel
        rule2 = min([farToObj closeToTar]); % then negative accel
        
        rule3 = min([farToObj leftT]); % then turn a lot left
        rule4 = min([farToObj slightLeftT]); % then turn a bit left
        rule5 = min([farToObj straightT]); % then no turn
        rule6 = min([farToObj slightRightT]); % then turn a bit right
        rule7 = min([farToObj rightT]); % then turn a bit left
        
        %When obstacle is getting close
        rule8 = min([max([closeToObj]) leftToObj]);
        rule9 = min([max([closeToObj]) slightLeftToObj]); 
        rule10 = min([max([closeToObj]) straightToObj]); 
        rule11 = min([max([closeToObj]) slightRightToObj]); 
        rule12 = min([max([closeToObj]) rightToObj]); 
        
        rule13 = min([max([mediumToObj]) leftToObj]);
        rule14 = min([max([mediumToObj]) slightLeftToObj]); 
        rule15 = min([max([mediumToObj]) straightToObj]); 
        rule16 = min([max([mediumToObj]) slightRightToObj]); 
        rule17 = min([max([mediumToObj]) rightToObj]); 
        
        % defuzzify
        
        %acceleration
        posLAccelY = max([rule0 rule1]);
        posAccelY = max([rule13 rule14 rule15 rule16 rule17]);
        constAccelY = max([rule2 rule8 rule9 rule10 rule11 rule12]);
        
        %angle
        leftY = max([rule3 rule11 rule16]);
        smallLeftY = max([rule4 rule12 rule17]);
        straightY = max([rule5 rule10 rule15]);
        smallRightY = max([rule6 rule8 rule13]);
        rightY = max([rule7 rule9 rule14]); 
         
        %{
        figure
        plot(accelRange,max(posLAccelY*posLAccel,max(posAccelY*posAccel, constAccelY*constAccel)));
        figure
        plot(turnRange, ....
            max(leftY*left, ...
            max(smallLeftY*smallLeft, ...
            max(straightY*straight, ...
            max(smallRightY*smallRight, rightY*right)))));
        %}
        acceleration = defuzz(accelRange,max(posLAccelY*posLAccel,max(posAccelY*posAccel, constAccelY*constAccel)), 'centroid');
        dAngle = defuzz(turnRange, ....
            max(leftY*left, ...
            max(smallLeftY*smallLeft, ...
            max(straightY*straight, ...
            max(smallRightY*smallRight, rightY*right)))), 'centroid');
        
        % update velocity, direction and current position for next tick
        velocity = velocity + acceleration;
        direction = direction - dAngle;
        position(1) = position(1) + TIME_PER_TICK*acceleration*cos(direction);
        position(2) = position(2) + TIME_PER_TICK*acceleration*sin(direction);
        
        plot(position(1), position(2), 'og');
        
        if position(1) > (goalCoord(1) - 0.1) && position(1) < (goalCoord(1) + 0.1) && position(2) > (goalCoord(2) - 0.1) && position(2) < (goalCoord(2) + 0.1)
            reachedDestination = 1;
        end
        
        timeM(iteration) = time;
        velVsTime(iteration) = acceleration;
        directionVTime(iteration) = direction*180/pi;
        tarDistVTime(iteration) = distToTarget;
        time = time + TIME_PER_TICK;
        iteration = iteration + 1;
        pause(0.001);
    end
    
    %{
    %plot output graphs
    figure('Name','Velocity over time');
    hold on;
    plot(timeM, velVsTime);
    figure('Name','Direction over time');
    hold on;
    plot(timeM, directionVTime);
    figure('Name','Target Distance over Time');
    hold on;
    plot(timeM, tarDistVTime);
    
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
    
    figure('Name','Dist to target');
    hold on;
    x = 0:0.1:3;
    plot(x, zmf(x, [0 1]));
    plot(x, generateMF(x, 1.5, -0.5));
    plot(x, smf(x, [2 3]));
    
    figure('Name','Angle to target');
    hold on;
    x = -20:0.1:20;
    plot(x, generateMF(x, 0, -15));
    plot(x, generateMF(x, -10, -15));
    plot(x, zmf(x, [-20 -15]));
    plot(x, generateMF(x, 10, -15));
    plot(x, smf(x, [15 20]));
    
    figure('Name','Dist to Object');
    hold on;
    x = 0:0.1:2;
    plot(x, zmf(x, [0 0.75]));
    plot(x, generateMF(x, 1, -1/4));
    plot(x, smf(x, [1.25 2]));
    
    figure('Name','Angle to Object');
    hold on;
    x = -20:0.1:20;
    plot(x, zmf(x, [-20 -15]));
    plot(x, generateMF(x, -10, -15));
    plot(x, generateMF(x, 0, -15));
    plot(x, generateMF(x, 10, -15));
    plot(x, smf(x, [15 20]));
    %}
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
                angle = direction - scanAngle;
            end
        end
        scanAngle = scanAngle + pi/180;
    end
end
