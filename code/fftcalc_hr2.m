function [sum_odd1, sum_even1, hr1] = fftcalc_hr2(acc,orien) 
 Fs=148.148;
 L=length(acc);
 NFFT = 2^nextpow2(L);
 Y = fft(acc,NFFT)*2/L;
 mag=abs(Y);
 f2 = Fs/2*linspace(0,1,NFFT/2+1);
% plot(f2,mag(1:NFFT/2+1)); 
 sum_odd1 = 0;
 sum_even1 = 0;

 ymag=mag(1:NFFT/2+1);
%  [ymax,tp]=max(ymag);
 basicf=Fs/NFFT;

    for k = 1 : 2 : 20
       oddbasicf=k*basicf;
       evenbasicf=(k+1)*basicf;
       Iodd=find(abs(f2-oddbasicf)<=0.001);
       Ieven=find(abs(f2-evenbasicf)<=0.001);
       sum_odd1 = sum_odd1 + ymag(Iodd);  
       sum_even1 =sum_even1 + ymag(Ieven) ;  
    end

    if orien == 0  
      hr1 = sum_odd1/sum_even1; 
    else
      hr1 = sum_even1/sum_odd1;
    end
  
end