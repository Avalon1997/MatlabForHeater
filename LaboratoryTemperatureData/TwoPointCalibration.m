function [cc, cc_string] = TwoPointCalibration(x,y)
%TWOPOINTCALIBRATION Two-point calibration
% Two-point calibration: the coefficients and constants of the two-point 
% calibration method are obtained according to the following formula.
% k = (y2 - y1) / (x2 - x1)
% b = (y2 - kx2) or b = (y1 - kx1)

cc = zeros(2, 7);
cc_string = strings(2, 7);
for i = 1:1:7
    cc(1, i) = (y(1, i) - y(2, i))/(x(1, i) - x(2, i));
    cc(2, i) = (y(1, i) - (cc(1, i) * x(1, i)));
end

for i = 1:1:7
    for j = 1:1:2
    cc_string(j, i) = sprintf("%.6f", cc(j, i));
    end
end