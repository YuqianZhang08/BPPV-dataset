function  MV = MV_output(orig_acc2,orig_event,line)

%  [~, sheet , ~] = xlsfinfo(dst_input);
%  % name of sheet
%  sheet_name = [input_name(6:end)];
%  
 AP = zeros(0, 0);
%  mv_all= zeros(length(sheet), 6);
     
%      data =  xlsread(dst_input, sheet{p});
%      orig_acc = data(:, 15:20);
%      orig_event = data(:, 21:22);
%      event1 = orig_event(~isnan(orig_event(:,1)));
%      [line,~] = size(event1);
%      orig_event = orig_event(1:line,:);
% 
%       for i = 1:1:length(orig_acc)
%             acccut=orig_acc;
%             if acccut(i,1)==0 & acccut(i,2)==0 & acccut(i,3)==0
%                 acccut(i-1,1)=acccut(i-2,1)+(acccut(i-2,1)-acccut(i-3,1));
%                 acccut(i+1,1)=acccut(i+2,1)+(acccut(i+2,1)-acccut(i+3,1));
%                 acccut(i-1,2)=acccut(i-2,2)+(acccut(i-2,2)-acccut(i-3,2));
%                 acccut(i+1,2)=acccut(i+2,2)+(acccut(i+2,2)-acccut(i+3,2));
%                 acccut(i-1,3)=acccut(i-2,3)+(acccut(i-2,3)-acccut(i-3,3));
%                 acccut(i+1,3)=acccut(i+2,3)+(acccut(i+2,3)-acccut(i+3,3));                
%                 acccut(i,1)=0.5*(acccut(i-1,1)+acccut(i+1,1));
%                 acccut(i,2)=0.5*(acccut(i-1,2)+acccut(i+1,2));
%                 acccut(i,3)=0.5*(acccut(i-1,3)+acccut(i+1,3));
%             end
%             if acccut(i,4)==0 & acccut(i,5)==0 & acccut(i,6)==0
%                 acccut(i-1,4)=acccut(i-2,4)+(acccut(i-2,4)-acccut(i-3,4));
%                 acccut(i+1,4)=acccut(i+2,4)+(acccut(i+2,4)-acccut(i+3,4));
%                 acccut(i-1,5)=acccut(i-2,5)+(acccut(i-2,5)-acccut(i-3,5));
%                 acccut(i+1,5)=acccut(i+2,5)+(acccut(i+2,5)-acccut(i+3,5));
%                 acccut(i-1,6)=acccut(i-2,6)+(acccut(i-2,6)-acccut(i-3,6));
%                 acccut(i+1,6)=acccut(i+2,6)+(acccut(i+2,6)-acccut(i+3,6));
%                 acccut(i,4)=0.5*(acccut(i-1,4)+acccut(i+1,4));
%                 acccut(i,5)=0.5*(acccut(i-1,5)+acccut(i+1,5));
%                 acccut(i,6)=0.5*(acccut(i-1,6)+acccut(i+1,6));
%             end
%             orig_acc2=acccut;
%         end
%      
%      r_line = floor((line-1)/2);

    
    for k=1:1:6
       maxacc=[];
       for j = 1:1:line-1

%       first_strike = floor(orig_event(j, 1));
%       third_strike = floor(orig_event(j+2, 1));    
        first_strike = floor(orig_event(j, 1));
        second_strike = floor(orig_event(j+1, 1));
        acc = orig_acc2(first_strike:second_strike , k );
     
         % 把数据中NAN置空
        acc( isnan(acc)) = []; 
        %acc = lowp(acc/(9.81*1000)); %换算单位
        acc = lowp(acc/(1000)); %换算单位
        if k ==1 || k == 4
            maxacc=[maxacc 0.5*(abs(max(0-acc)-min(0-acc)))];
        else
            maxacc=[maxacc 0.5*(abs(max(acc)-min(acc)))];
        end
       
        
       end
       for j = 2:1:length(maxacc)-1
           prestd=[];
           prestd=[maxacc(j-1) maxacc(j) maxacc(j+1)];
        %sdacc=maxacc(2:length(maxacc)-1);
%            MV=[MV std(prestd,1)];
           AP(j-1,k)=std(prestd,1);
       end
    end
 MV=mean(AP);
  
end