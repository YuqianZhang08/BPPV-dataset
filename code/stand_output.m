function  [Jerk, MS] = stand_output(  input_name,dst_input, dst_output )
 [~, sheet , ~] = xlsfinfo(dst_input);
 % name of sheet
 sheet_name = [input_name(6:end)];
 
Jerk = zeros(0, 0);
 RMS = zeros(0, 0);
MS = zeros(0, 0);
 
 for p = 1:1:length(sheet)
     
     data =  xlsread(dst_input, sheet{p});
     orig_acc = data(:, 15:20);

     
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
        orig_acc2( isnan(orig_acc2)) = []; 
        orig_acc2 = orig_acc2/1000; %换算单位
        d1 = designfilt('lowpassiir','FilterOrder',12, 'HalfPowerFrequency',3.5*2/148.148,'DesignMethod','butter');
        orig_acc2 = filtfilt(d1,orig_acc2);
pelvis=orig_acc2(:,1:3);
head=orig_acc2(:,4:6);
%---------------------Jerk-----------------%
gradplap=gradient(pelvis(:,3));
gradplml=gradient(pelvis(:,2));
Forintepl=gradplap.^2+gradplml.^2;
Jerkpel=0.5*cotes(1,length(Forintepl),Forintepl);

gradhdap=gradient(head(:,3));
gradhdml=gradient(head(:,2));
Forintehd=gradhdap.^2+gradhdml.^2;
Jerkhd=0.5*cotes(1,length(Forintehd),Forintehd);

Jerk=[Jerkpel Jerkhd];
%------------------RMS----------------------%
rms_all(j, k) = sqrt(mean2(orig_acc.^2));
%------------------MV-----------------------%
% accpel=(pelvis(:,1).^2+pelvis(:,2).^2+pelvis(:,3).^2).^0.5;
% acchd=(head(:,1).^2+head(:,2).^2+head(:,3).^2).^0.5;
% MVpl=cotes(1,length(accpel),accpel);
% MVhd=cotes(1,length(acchd),acchd);
% MV=[MVpl MVhd];
% acc=pelvis;
% fft_acc = fft(acc);
% fft_acc(1) = 0;
% pelvisft = ifft(fft_acc);
% pelvvt=cotes(1,length(pelvisft(:,1)),pelvisft(:,1));%归于零点
% pelvml=cotes(1,length(pelvisft(:,2)),pelvisft(:,2));
% pelvap=cotes(1,length(pelvisft(:,3)),pelvisft(:,3));
% speedpel=(pelvap^2+pelvml^2+pelvvt^2).^0.5;
pelvvt=cotes(1,length(pelvis(:,1)),pelvis(:,1)-mean(pelvis(:,1)));%归于零点
pelvml=cotes(1,length(pelvis(:,2)),pelvis(:,2)-mean(pelvis(:,2)));
pelvap=cotes(1,length(pelvis(:,3)),pelvis(:,3)-mean(pelvis(:,3)));
speedpel=(pelvap^2+pelvml^2+pelvvt^2).^0.5;
headvt=cotes(1,length(head(:,1)),head(:,1)-mean(head(:,1)));%归于零点
headml=cotes(1,length(head(:,2)),head(:,2)-mean(head(:,2)));
headap=cotes(1,length(head(:,3)),head(:,3)-mean(head(:,3)));
speedhead=(headvt^2+headml^2+headap^2).^0.5;
MV=[speedpel speedhead];

 end
end