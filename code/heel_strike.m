
% heel strike dectect
% one trail detect (one sheet)
% left & right

clc;clear all;
input_name = '0925_lichendi'; 
input_trail = 'walk01_2';
directory =  'F:\Ñ§Ï°\BPPV\BPPV\BPPVÊý¾Ý\data_control\walk\';
input_file = [input_name '.xlsx'];
dst_input = [directory, input_file];

orig_data = xlsread(dst_input, input_trail );
left_ankle_ap = orig_data(:,4);
right_ankle_ap = -orig_data(:,7);
[left_frame] = select_hs(left_ankle_ap,6);

[right_frame] = select_hs(right_ankle_ap, 6);

subplot(2,1,1);
plot(left_ankle_ap );hold on;
title('left strike');
for i = 1:1:length(left_frame)
    plot([left_frame(i) left_frame(i)], [0, 22000])
end
hold off;

subplot(2,1,2);
plot(right_ankle_ap );hold on;
title('right strike');
for i = 1:1:length(right_frame)
    plot([right_frame(i) right_frame(i)], [0, 22000])
end
hold off;

title = [{'left strike'}, {'left off'}, {'right strike'}, {'right off'} ];
xlswrite(dst_input, title, input_trail, 'U4');
xlswrite(dst_input, left_frame, input_trail, 'U5');
xlswrite(dst_input, right_frame, input_trail, 'W5');
