function [ symmetry , variability ] = sp_FOG(dst_input)
data =  xlsread(dst_input);
orig_acc = data(:, 1:4);
orig_event = data(:, 5);
event1 = orig_event(~isnan(orig_event(:,1)));
[line,~] = size(event1);
r_line = floor(line);
regularity = zeros(r_line,3);
variability= zeros(r_line,3);
strideregularity= zeros(r_line,3);
symmetry= zeros(r_line,3);
for p = 1:1:r_line-2
        first_strike = floor(event1(p, 1));
        third_strike = floor(event1(p+2, 1));    
       % first_strike = floor(orig_event(2*j-1, 1));
       % third_strike = floor(orig_event(2*j+1, 1));
        
        for j = 1:1:3
        acc = orig_acc(first_strike:third_strike ,j );
        xcor=xcov(acc,'unbiased');
        nor=(xcor-min(xcor))/(max(xcor)-min(xcor));
        xcorfin=2*nor-1;
        
        %[pks2,locs2]=findpeaks(-xcorfin,'minpeakdistance',40);
        
        %[dom_x,dom]=find(pks==1);
        if j==1 || j==3
            [pks,locs]=findpeaks(xcorfin,'minpeakdistance',30);
            dom_x=(length(pks)+1)/2;
            Ad1=pks(dom_x+1);
            Ad2=pks(dom_x+2);
        else         
            [pks,locs]=findpeaks(xcorfin,'minpeakdistance',30);
            [pks2,locs2]=findpeaks(-xcorfin,'minpeakdistance',30);
            len=length(pks);
            dom_x=(length(pks)+1)/2;
            dom_x2=round((length(pks2))/2);
           % Ad=sort(pks);
            %Ad1=Ad(len-1);
            Ad1=pks(dom_x+1);
            %len=length(pks2);
%             Adf=sort(pks2);
%             Ad2=-Adf(len);
            Ad2=-pks2(dom_x2+1);
        end
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

end