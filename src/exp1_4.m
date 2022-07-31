clear all, close all, clc;

tunes = my_get_tunes('D');
beat_len = 0.5;
Fs = 8000;

low = @(x) x;
mid = @(x) x + 7;
high = @(x) x + 14;
pause = @(x) 22;

song = [...
    mid(5), 1; mid(5), 0.5; mid(6), 0.5; ...
    mid(2), 2; ...
    mid(1), 1; mid(1), 0.5; low(6), 0.5; ...
    mid(2), 2];

len = size(song);
len = len(1);
res = [];
amps = [1,0.340,0.102,0.085,0.070,0.065,0.028,0.085,0.011,0.030,0.010,0.014,0.012,0.013,0.004]';
harmonics = 1:15;


for i = 1 : 1 : len
    f = tunes(song(i, 1)); %对应唱名的频率
    time_len = song(i, 2) * beat_len;
    t = linspace(0, time_len - 1 / Fs, Fs * time_len)'; % 采样
    waves = sin(2*pi*f.*(t*harmonics));
    tmp_res = waves*amps.*envelop(t);
    res = [res; tmp_res];
end

%k = linspace(0,1.5,500*1.5);
%figure(1);
%plot(k,envelop(k));
%hold on;
%figure(2);
figure(1);
plot([0 : length(res) - 1] / Fs, res);
title("音频");
figure(2);
plot([0 : 200 - 1] / Fs, res(1 : 200));
title("波形");
sound(res, Fs);

