
function [selected_frames]= select_hs(acc_data, stride_num)
max_val = max(acc_data);
half_max_val = max_val / 2;
half_length = 5;
count = 1;
data2= zeros(0,0);
frame = zeros(0);
top_value = zeros(0);
for i = half_length:1:length(acc_data)-half_length
    if acc_data(i) >= half_max_val
        if acc_data(i-1) < acc_data(i) && acc_data(i+1) < acc_data(i)
            frame = [frame; i];
            top_value = [top_value; acc_data(i)];
            tmpdata = zeros(half_length * 2 + 1, 1);
            for j = -half_length:1:half_length
                tmpdata(j + half_length + 1, 1) = acc_data(i + j);
            end
            data2 = [data2; tmpdata'];
            %count = count + 1;
            %count = count + 1;
        end
    end
end
[row, col]=size(data2);
if row <= stride_num + 2
    selected_frames = frame;
else
[coef,score,latent,t2] = pca(data2);
tmpcoef = coef(:,1:2);
data3 = data2 * tmpcoef;
idx = kmeans(data3, 2);
top1_values = mean(top_value(idx == 1));
top2_values = mean(top_value(idx == 2));
selected_value = 1;
if top2_values > top1_values
    selected_value = 2;
end

selected_frames = frame(idx == selected_value);

end