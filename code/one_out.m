
% Date:2017.9.18
% Revision:

% main
clc;clear all;
input_name = 'PD1ACCLabel2';
directory =   'F:\ѧϰ\Parkinson\FOG\dataset\dataset\';
input_file = [input_name '.csv'];
output_file = 'zwsp.xls';
dst_input = [directory, input_file];
dst_output = [directory, output_file];

%[ hr, rms ] = hr_rms_output(input_name, dst_input, dst_output );
[ speed, sl ] = sp2_output( input_name, dst_input, dst_output);