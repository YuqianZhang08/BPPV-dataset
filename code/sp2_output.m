function [ sum_space , sum_space2 ] = sp2_output( input_name, dst_input, dst_output)
[~, sheet , ~] = xlsfinfo(dst_input);
 
steptime_sd = zeros(1,length(sheet));
cadence = zeros(1,length(sheet));

regularity = zeros(length(sheet),6);
variability= zeros(length(sheet),6);
strideregularity= zeros(length(sheet),6);
symmetry= zeros(length(sheet),6);
sum_space=zeros(6,length(sheet));
sum_space2=zeros(4,6);
 for p = 1:length(sheet)
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
% % % % % % % cadence%%%%%%%%%%%%%%
   numostride=length(orig_event(:,1));
   lenoftime=(orig_event(numostride,1)-orig_event(1,1))/148.148;
   cadence(1,p)=(numostride-1)*120/lenoftime;
   
     
% pelvt=orig_acc2(:,1);
% peaknum=length(findpeaks(pelvt));
% secondd=length(pelvt)/148.148;
% cadence=peaknum*60/secondd;

%%%%%%%%%%%%%steptime_sd%%%%%%%%%%%%%%%
right_event = data(:, 23);
event2 = right_event(~isnan(right_event(:,1)));
sortevent=sort([event1;event2]);
steptime=[];
for j=1:1:length(sortevent)-2
    steptime=[steptime (sortevent(j+2)-sortevent(j))/148.148*4];
end
steptime_sd(1,p)=std(steptime,1);

%%%%%%%%%%%%regularity%%%%%%%%%%%%%%%%%%%%%
for j=3:3:6;
acc=orig_acc2(:,j);
acc( isnan(acc/1000)) = []; 
xcor=xcov(acc,'unbiased');
nor=(xcor-min(xcor))/(max(xcor)-min(xcor));
xcorfin=2*nor-1;
[pks,locs]=findpeaks(xcorfin,'minpeakdistance',50);
% [pks2,locs2]=findpeaks(-xcorfin,'minpeakdistance',50);
dom_x=(length(pks)+1)/2;
%[dom_x,dom]=find(pks==1);
%Ad1=pks(dom_x+1);
%Ad2=pks2(dom_x+1)*(-1);
len=length(pks);
Ad=sort(pks);
Ad1=Ad(len-1);
Ad2=Ad(len-3);
% len=length(pks2);
% Adf=sort(pks2);
% Ad2=Adf(len-1)*(-1);
width=locs(dom_x+1)-locs(dom_x);
regularity(p,j)=Ad1;
strideregularity(p,j)=Ad2;
if Ad2/Ad1>-1
   symmetry(p,j)=Ad2/Ad1;
else
   symmetry(p,j)=Ad1/Ad2;
end
variability(p,j)=width;
end
 end
sum_space(1,:)=cadence;
sum_space(2,:)=steptime_sd;
sum_space2(1,:)=mean(regularity,1);
sum_space2(2,:)=mean(variability,1);
sum_space2(3,:)=mean(strideregularity,1);
sum_space2(4,:)=mean(symmetry,1);
mean_space=mean(sum_space,2);
sp_sheet = [input_name(6:end)];
   title1 = [{'head_vt'},{'pelvis_vt'}];
   title2 = [{' '} {'cadence'} {'step_time(sd)'}];
   title_space1_trail = [sheet];
   title_space2_trail = [{' '} {'regularity'} {'variability'} {'strideregularity'} {'symmetry'} ];
   
xlswrite(dst_output, title2', sp_sheet, 'A1');
xlswrite(dst_output, title_space1_trail, sp_sheet, 'B1');
xlswrite(dst_output, [sum_space mean_space], sp_sheet, 'B2');
xlswrite(dst_output, title1, sp_sheet, 'K1');
xlswrite(dst_output, title_space2_trail', sp_sheet, 'J1' )
xlswrite(dst_output, sum_space2, sp_sheet, 'K2');
xlswrite(dst_output, [sum_space2(:)' mean_space'], sp_sheet, 'A9');
end
