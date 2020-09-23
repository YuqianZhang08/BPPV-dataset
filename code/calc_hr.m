
% Date: 2017.9.18
% Revision:2017.6.10
function [sum_odd, sum_even, hr] = calc_hr(acc,orien)

   sum_odd = 0;
   sum_even = 0;
   
    period = length(acc)/2;
    xn = fseries(acc, period, 20 );

   for k = 1 : 2 : 20
%        sum_odd = sum_odd + (abs(xn(k))).^2; % new version
%        sum_even = sum_even + (abs(xn(k+1))).^2; 
       sum_odd = sum_odd + abs(xn(k));  %old hr
       sum_even = sum_even + abs(xn(k+1));  % old hr
   end
   
   if orien == 0  
    %hr = sum_odd/(sum_even+sum_odd); 
     hr = sum_odd/sum_even; 
   else
%     hr = sum_even/(sum_odd+sum_even); 
     hr = sum_even/sum_odd;
    end
  
