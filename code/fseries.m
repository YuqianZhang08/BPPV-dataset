% Date: 2017.4.11
% Revision:

function [ xn ] = fseries(acc, period, fs)

X = zeros(fs,1);
for k = 1 : 1 : fs
    for n = 1 : 1 : period-1
        X(k) = X(k)+acc(n)*exp(-j*2*pi*n*k/period);
    end
end

  % xn = zeros(fs,1);
xn = abs(X);
xn = xn/xn(2);
%xn = xn/xn(2); %±ê×¼»¯


