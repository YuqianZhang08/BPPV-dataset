
% Revision: 2018.1.6

function  [hr_all, rms_all] = hr_rms_output(  input_name,dst_input, dst_output )

 [~, sheet , ~] = xlsfinfo(dst_input);
 % name of sheet
 sheet_name = [input_name(6:end)];
 
 HR = zeros(0, 0);
 RMS = zeros(0, 0);
 AP= zeros(length(sheet), 6);
 
 for p = 1:1:length(sheet)
     
     data =  xlsread(dst_input, sheet{p});
     orig_acc = data(:, 15:20);
     orig_event = data(:, 21);
     event1 = orig_event(~isnan(orig_event(:,1)));
     [line,~] = size(event1);
     orig_event = orig_event(1:line,:);
     
      for i = 1:1:length(orig_acc)
            acccut=orig_acc;
            if acccut(i,1)==0 & acccut(i,2)==0 & acccut(i,3)==0
                acccut(i-1,1)=acccut(i-2,1)+(acccut(i-2,1)-acccut(i-3,1));
                acccut(i+1,1)=acccut(i+2,1)+(acccut(i+2,1)-acccut(i+3,1));
                acccut(i-1,2)=acccut(i-2,2)+(acccut(i-2,2)-acccut(i-3,2));
                acccut(i+1,2)=acccut(i+2,2)+(acccut(i+2,2)-acccut(i+3,2));
                acccut(i-1,3)=acccut(i-2,3)+(acccut(i-2,3)-acccut(i-3,3));
                acccut(i+1,3)=acccut(i+2,3)+(acccut(i+2,3)-acccut(i+3,3));                
                acccut(i,1)=0.5*(acccut(i-1,1)+acccut(i+1,1));
                acccut(i,2)=0.5*(acccut(i-1,2)+acccut(i+1,2));
                acccut(i,3)=0.5*(acccut(i-1,3)+acccut(i+1,3));
            end
            if acccut(i,4)==0 & acccut(i,5)==0 & acccut(i,6)==0
                acccut(i-1,4)=acccut(i-2,4)+(acccut(i-2,4)-acccut(i-3,4));
                acccut(i+1,4)=acccut(i+2,4)+(acccut(i+2,4)-acccut(i+3,4));
                acccut(i-1,5)=acccut(i-2,5)+(acccut(i-2,5)-acccut(i-3,5));
                acccut(i+1,5)=acccut(i+2,5)+(acccut(i+2,5)-acccut(i+3,5));
                acccut(i-1,6)=acccut(i-2,6)+(acccut(i-2,6)-acccut(i-3,6));
                acccut(i+1,6)=acccut(i+2,6)+(acccut(i+2,6)-acccut(i+3,6));
                acccut(i,4)=0.5*(acccut(i-1,4)+acccut(i+1,4));
                acccut(i,5)=0.5*(acccut(i-1,5)+acccut(i+1,5));
                acccut(i,6)=0.5*(acccut(i-1,6)+acccut(i+1,6));
            end
            orig_acc2=acccut;
        end
     
     %r_line = floor((line-1)/2);
     r_line = floor(line);
     sum_odd = zeros(r_line, 6);
     sum_even = zeros(r_line, 6);
     hr_all = zeros(r_line, 6);
     rms_all = zeros(r_line, 6);

 
   for j = 1:1:r_line-2

        first_strike = floor(orig_event(j, 1));
        third_strike = floor(orig_event(j+2, 1));    
       % first_strike = floor(orig_event(2*j-1, 1));
       % third_strike = floor(orig_event(2*j+1, 1));
        
        for k = 1:1:6
        acc = orig_acc2(first_strike:third_strike , k );
     
         % 把数据中NAN置空
        acc( isnan(acc)) = []; 
        acc = lowp(acc/(9.81*1000)); %换算单位
        
           if k ==2 || k == 5
              [sum_odd(j,k), sum_even(j,k), hr_all(j,k)] = calc_hr(acc,0);
           else
              [sum_odd(j,k), sum_even(j,k), hr_all(j,k)] = calc_hr(acc,1);
           end

     
     % RMS
     rms_all(j, k) = sqrt(mean2(acc.^2));
     end
     
   end
 AP(p,:) = MV_output(orig_acc2,orig_event,line); 
 hr_trail = mean(hr_all', 2)';
 rms_trail = mean(rms_all',2)'; 
 HR = [HR; hr_trail];
 RMS = [RMS; rms_trail];
 end

 % name of title
title1 = [{'head_vt'},{'head_ml'},{'head_ap'},{'pelvis_vt'},{'pelvis_ml'},{'pelvis_ap'}];
title_hr_trail = [{'HR'} sheet];
title_rms_trail = [{'RMS'} sheet];
title_mv_trail = [{'AP'} sheet];
% HR2 = [title_hr_trail' [title1; HR]];
% RMS2 = [title_rms_trail' [title1; RMS]];

xlswrite(dst_output, title1, sheet_name, 'B1');
xlswrite(dst_output, title_hr_trail', sheet_name, 'A1');
xlswrite(dst_output, HR, sheet_name, 'B2');
xlswrite(dst_output, title1, sheet_name, 'J1');
xlswrite(dst_output, title_rms_trail', sheet_name, 'I1' )
xlswrite(dst_output, RMS, sheet_name, 'J2');
xlswrite(dst_output, title1, sheet_name, 'R1');
xlswrite(dst_output, title_mv_trail', sheet_name, 'Q1' )
xlswrite(dst_output, AP, sheet_name, 'R2');
end

