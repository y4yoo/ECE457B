hold off
%dist to object
x = 0:0.01:2;
closeToObj = generateMF(x, 0, -1/4);
mediumToObj = generateMF(x, 1, -1/4);
farToObj = generateMF(x, 2, -1/4);
hold on
plot(x, closeToObj);
plot(x, mediumToObj);
plot(x, farToObj);
hold off
%dist to target
x = 0:0.1:20;
closeToTar = generateMF(x, 0, -15);
mediumToTar = generateMF(x, 10, -15);
farToTar = generateMF(x, 20, -15);
hold on
plot(x, closeToTar);
plot(x, mediumToTar);
plot(x, farToTar);
hold off
%angle from object
x = -20:0.1:20;
straight = generateMF(x, 0, -15);
slightLeft = generateMF(x, -10, -15);
left = generateMF(x, -20, -15);
slightRight = generateMF(x, 10, -15);
right = generateMF(x, 20, -15);
hold on
plot(x, straight);
plot(x, slightLeft);
plot(x, left);
plot(x, slightRight);
plot(x, right);