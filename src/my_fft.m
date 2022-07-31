function [f , Amp] = my_fft(X)
L = length(X);
Fs = 8000; % 采样率设置为8000 
Y = fft(X);
Amp = abs(Y/L);
Amp = Amp(1:round(L/2)+1);
Amp(2:end-1) = 2*Amp(2:end-1);
f = 0:Fs/L:Fs/2-Fs/L;
Amp = Amp(1:round(L/2));
end