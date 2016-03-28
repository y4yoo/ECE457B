function [x1, x2] = InputOfY(y, x0, s)
%Gaussian Membership Function
%return x input(s) for y value
    x1 = x0 + sqrt(s*log(y));
    x2 = x0 - sqrt(s*log(y));
end

