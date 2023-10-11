
% Date: 2017.10.22
% Revision:

% main
clc;clear all;
input_name = 'mayongbin';
input_file = [input_name '.xlsx'];
input_directory = 'D:\bppv\';
output_directory = 'D:\bppv\orgnized\';
output_file_s = [input_name '_s' '.xlsx'];
output_file = [input_name '.xlsx'];
dst_input = [input_directory, input_file];
dst_output = [output_directory, output_file];
dst_output_s = [output_directory, output_file_s];

left_ankle = 5;
right_ankle = 12;
chest_back =2;
chest = 11;
pelvis =14;
head =13;

[~, sheet format] = xlsfinfo(dst_input);

for p = 1:1:length(sheet)
    
    [orig, txt] = xlsread(dst_input, sheet{p});
    orig_data = orig(5:end,:);
    title = txt(3:4,:);
    [line, list] = size(orig_data);
    
    LA = orig_data(:, left_ankle*3:(left_ankle*3+2));
    RA = orig_data(:, right_ankle*3:(right_ankle*3+2));
    CH = orig_data(:, chest*3:(chest*3+2));
    CB = orig_data(:, chest_back*3:(chest_back*3+2));
    PE = orig_data(:, pelvis*3:(pelvis*3+2));
    HE = orig_data(:, head*3:(head*3+2));
    
    LA_title = title(:, left_ankle*3:(left_ankle*3+2));
    RA_title = title(:, right_ankle*3:(right_ankle*3+2));
    CH_title = title(:, chest*3:(chest*3+2));
    CB_title = title(:, chest_back*3:(chest_back*3+2));
    PE_title = title(:, pelvis*3:(pelvis*3+2));
    HE_title = title(:, head*3:(head*3+2));
    
    frame = 1:line;
    subframe = orig_data(:, 2);
    organ_data = [frame' subframe LA RA CH CB PE HE];
    title_position = [{''} {''} {'left_ankle'} {''} {''} {'right_ankle'} {''} {''} {'chest'} {''} {''} {'chest_back'} {''} {''} {'pelvis'} {''} {''} {'head'} {''} {''}];
    title_direction = [{''} {''} {'VT'} {'AP'} {'ML'} {'VT'} {'AP'} {'ML'} {'VT'} {'ML'} {'AP'} {'VT'} {'ML'} {'AP'} {'VT'} {'ML'} {'AP'} {'VT'} {'ML'} {'AP'}];
    organ_title = [title_position; [[{''};{'Frame'}] [{''};{'Subframe'}] LA_title RA_title CH_title CB_title PE_title HE_title];title_direction];
    
    if p <= 10
    xlswrite(dst_output, organ_title, sheet{p})
    xlswrite(dst_output, organ_data, sheet{p}, 'A5')
    else
    xlswrite(dst_output_s, organ_title, sheet{p})
    xlswrite(dst_output_s, organ_data, sheet{p}, 'A5')   
    end
    
end
