clear all; close all; clc;
load("音乐合成大作业\assets\Guitar.MAT");
Fs = 8000;
T = 1/Fs;
L = length(wave2proc);
t = (0:L-1)*T;

single_wave = wave2proc(1:round(L/10));
single_L = length(single_wave);

multi_wave = wave2proc;
for i = 1:1:32
    multi_wave = [multi_wave;wave2proc];
end
multi_L = length(multi_wave);

single_F = fft(single_wave);
F1 = abs(single_F/single_L);
F = fft(wave2proc);
F2 = abs(F/L);
multi_F = fft(multi_wave);
F3 = abs(multi_F/multi_L);

F_1 = F1(1:single_L/2+1);
F_1(2:end-1) = 2*F_1(2:end-1);
subplot(3,1,1);
plot(0:(Fs/single_L):(Fs/2-Fs/single_L),F_1(1:single_L/2));
title('single-wave fft')
xlabel('f(Hz)');
ylabel('Amp');

F_2 = F2(1:round(L/2)+1);
F_2(2:end-1) = 2*F_2(2:end-1);
subplot(3,1,2);
plot(0:round(Fs/L):(Fs/2-round(Fs/L)),F_2(1:round(L/2)-1));
title('origin-wave fft')
xlabel('f(Hz)');
ylabel('Amp');

F_3 = F3(1:round(multi_L/2+1));
F_3(2:end-1) = 2*F_3(2:end-1);
subplot(3,1,3);
plot(0:round(Fs/multi_L):(Fs/2-round(Fs/multi_L)),F_3(1:4000));
title('multi-wave fft')
xlabel('f(Hz)');
ylabel('Amp');

% 储存傅里叶级数
[f,F] = my_fft(multi_wave);
[pks,locs] = findpeaks(F,'MinPeakHeight',max(F)/5);
single_harmonics = zeros(1,10);
base = locs(1);
for i = 1:length(locs)
    times = round(locs(i)/base);
    single_harmonics(times) = pks(i);
end
save("音乐合成大作业/assets/single_har.mat",'single_harmonics');


