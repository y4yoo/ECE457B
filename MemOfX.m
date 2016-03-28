function [y] = MemOfX(x, x0, s)
%Gaussian MF
%returns y value for x input
    y = exp((x-x0).^2/s);
end

