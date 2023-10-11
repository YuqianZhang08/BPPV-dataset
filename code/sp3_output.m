function [ speed, steplength ] = sp3_output( input_name, dst_input, dst_output)
[~, sheet format] = xlsfinfo(dst_input);
 
speed = zeros(1,length(sheet));
steplength = zeros(1,length(sheet));


 for p = 1:length(sheet)
     data =  xlsread(dst_input, sheet{p});
     orig_acc = data(:, 15:20);
     orig_event1 = data(:, 21);
     orig_event2 = data(:, 23);
     event1 = orig_event1(~isnan(orig_event1));
     event2 = orig_event2(~isnan(orig_event2));
     steplength(1,p)=length(event1)+length(event2);
     speed(1,p)=length(orig_acc(:,1));
 end
 sp_sheet = [input_name(6:end)];
 title = [{' '} {'speed'} {'step_length'}];
 xlswrite(dst_output, title', sp_sheet, 'A1');
 xlswrite(dst_output, speed, sp_sheet, 'B2');
 xlswrite(dst_output, steplength, sp_sheet, 'B3');







end