
% Date:2017.9.19
% Revision:

function [ space_temporal ] = sp_output( input_name, dst_input, dst_output)

 [~, sheet format] = xlsfinfo(dst_input);
 
 stride_time = zeros(6,6);
 right_stride_time = zeros(6,6); 
 left_stand_time = zeros(6,6);
 right_stand_time = zeros(6,6);
 left_stand_phase = zeros(6,6);
 right_stand_phase = zeros(6,6);

step_time = zeros(6,6);
candence = zeros(6,6);

double_support = zeros(6,6);
 
 for p = 1:length(sheet)

     data = xlsread(dst_input,sheet{p});
     left_strike = data(:,21);
     left_off =  data(:,22);
     right_strike = data(:,23);
     right_off = data(:,24);
     left_strike = left_strike(~isnan(left_strike));
     left_off = left_off(~isnan(left_off));
     right_strike = right_strike(~isnan(right_strike));
     right_off = right_off(~isnan(right_off));
     
     [line1,~] = size(left_strike);
     [line2,~] = size(right_strike);
     
     if line1 > line2
        line = line2;
     else
        line = line1;
     end


for j = 1 : 1 : line-1
       
   stride_time(j,p) = (left_strike(j+1) - left_strike(j));
   right_stride_time(j,p) = (right_strike(j+1) - right_strike(j));
    
  
   left_stand_time(j,p) = abs(left_off(j) - left_strike(j));
   right_stand_time(j,p) = abs(right_off(j)-right_strike(j));
   
   left_stand_phase(j,p) = (left_stand_time(j,p)/stride_time(j,p))*100;
   right_stand_phase(j,p) = (right_stand_time(j,p)/right_stride_time(j,p))*100; 
   
   if right_strike(j) > left_strike(j)
      
       double_support(j,p) = (abs(right_strike(j)-left_off(j))+abs(left_strike(j+1)-right_off(j)))/stride_time(j,p)*100;
       
   else

        double_support(j,p) = (abs(left_strike(j)-right_off(j)) + abs(right_strike(j+1)-left_off(j)))/stride_time(j,p)*100;
   end
   
   step_time(j,p) = abs(right_strike(j) - left_strike(j));
   candence(j,p) = 60/(step_time(j,p)/148.148);
 
end
   
end
   Stride_time = mean(stride_time(stride_time~=0))/148.148;
   
   L_stand_phase = mean(left_stand_phase(left_stand_phase~=0)) ;
   R_stand_phase = mean(right_stand_phase(right_stand_phase~=0));
   
   Step_time =  mean(step_time(step_time~=0))/148.148 ;
   Candence =  mean(candence(candence~=0)) ;
   Double_support =  mean(double_support(double_support~=0)) ;
   
   space_temporal = [Stride_time Step_time Candence  Double_support L_stand_phase R_stand_phase]';
  
    % name of sheet 
    sp_sheet = [input_name(6:end)];
   
   title2 = [{'stride time(s)'} {'step time(s)'} {'candence'}  {'double support(%)'} {'L_stand_phase'} {'R_stand_phase'}]';
   %title =  [{''} ,{'mean'}, {'SD'}, {' '},{'mean'}, {'SD'},{' '}];
   
   xlswrite(dst_output, title2, sp_sheet, 'a1');
   xlswrite(dst_output, space_temporal, sp_sheet, 'B1');
end
   
   
   