clear all; close all; clc;
load("音乐合成大作业\assets\Guitar.MAT");
cor = xcorr(realwave,realwave);
[pks,locs] = findpeaks(cor,'MinPeakHeight',1);
plot(cor);
title('realwave自相关函数');
my_wave = realwave;
for i = 1:length(locs)
    my_wave = my_wave + circshift(realwave,locs(i),1);
end
my_wave = my_wave ./ length(locs);


figure(2);
subplot(3,1,1),
plot(realwave);
title('realWave');

subplot(3,1,2),
plot(my_wave);
title('myWave');

subplot(3,1,3),
plot(wave2proc);
title('wave2proc')

figure(3);
diff_pre = abs(realwave - wave2proc);
diff_ans = abs(wave2proc - my_wave);
plot(diff_pre,'r');
hold on;
plot(diff_ans,'b');
legend('realWave','myWave')
title('差值对比')



