
% DATE:2017.10.30
% Revision:

% mian
clc;clear all;
directory = 'F:\Ñ§Ï°\BPPV\BPPV\BPPVÊý¾Ý\data_control\walk\sun\';
input_files = [directory '*.xlsx'];
output_file = 'sp2con.xlsx';
dst_output = [directory, output_file];

dirs = dir( input_files );
dirnum = length(dirs);
dircell = struct2cell(dirs)';
filenames = dircell(:,1); 

for i = 1:1:dirnum
    filename = filenames{i};
    dst_input = [directory, filename];
    input_name = filename(1:end-5);   
  
  %  [ hr, rms ] = hr_rms_output(input_name, dst_input, dst_output );
    [ space_temporal,space2 ] = sp2_output( input_name, dst_input, dst_output);
    
end
