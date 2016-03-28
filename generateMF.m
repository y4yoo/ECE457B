function [y] = generateMF(x, x0, s)
%generate Gaussian Membership Function
y = exp((x-x0).^2/s);
end

