
function [] = select_fo(dst_input)

 [~, sheet format] = xlsfinfo(dst_input);
 
  for p = 1:1:length(sheet)
      
      orig_data = xlsread(dst_input,sheet{p});
      left_ap = orig_data(:,4);
      right_ap =  -orig_data(:,7);
      left_strike = orig_data(:,21);
      right_strike = orig_data(:,23);
      left_strike = left_strike(~isnan(left_strike));
      right_strike = right_strike(~isnan(right_strike));
      left_off_frame = zeros(1,(length(left_strike)-1));
      right_off_frame = zeros(1,(length(right_strike)-1));
      
      for i = 1:1:(length(left_strike)-1)
          kl_off = floor(left_strike(i) + (left_strike(i+1) - left_strike(i))*0.6);
          kr_off = floor(right_strike(i) + (right_strike(i+1) - right_strike(i))*0.6);
          [left_pks, left_locs] = findpeaks(left_ap((kl_off-7):(kl_off+7)));
          [right_pks, right_locs] = findpeaks(right_ap((kr_off-7):(kr_off+7)));
          
          left_off_frame(i) = left_locs(1) - 7 + kl_off ;
          right_off_frame(i) = right_locs(1) - 7 + kr_off;
      end
      
      xlswrite(dst_input, left_off_frame', sheet{p}, 'V5');
      xlswrite(dst_input, right_off_frame', sheet{p}, 'X5');
  end
end
             