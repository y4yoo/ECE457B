%dist to object
distToObj = 0.5; %input
closeToObj = MemOfX(distToObj, 0, -1/4);
mediumToObj = MemOfX(distToObj, 1, -1/4);
farToObj = MemOfX(distToObj, 2, -1/4);
%dist to target
distToTar = 1; %input
closeToTar = MemOfX(distToTar, 0, -15);
mediumToTar = MemOfX(distToTar, 10, -15);
farToTar = MemOfX(distToTar, 20, -15);
%angle from object
angle = 2; %input
straight = MemOfX(angle, 0, -15);
slightLeft = MemOfX(angle, -10, -15);
left = MemOfX(angle, -20, -15);
slightRight = MemOfX(angle, 10, -15);
right = MemOfX(angle, 20, -15);