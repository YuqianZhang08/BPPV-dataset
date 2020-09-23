
function y = lowp(acc)
fft_acc = fft(acc);
fft_acc(1) = 0;
y = ifft(fft_acc);
hd = design(fdesign.lowpass('N,F3dB',5,15,100),'butter'); %148.48*2
y = filter(hd,y);

end