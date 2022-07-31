load("音乐合成大作业\assets\Guitar.MAT")
[wave,Fs] = audioread('音乐合成大作业/assets/fmt.wav');
figure(1);
plot(wave);
sound(wave,Fs);

figure(2);
plot(realwave);
title("realwave");
figure(3);
plot(wave2proc);
title("wave2proc");