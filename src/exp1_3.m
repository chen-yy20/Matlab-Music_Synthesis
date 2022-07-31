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
res2 = [];
for i = 1 : 1 : len
    f = tunes(song(i, 1)); %对应唱名的频率
    time_len = song(i, 2) * beat_len;
    t = linspace(0, time_len - 1 / Fs, Fs * time_len)'; % 采样
    tmp_res = sin(2 * pi * f * t).*envelop(t);
    % 频率翻倍即可提高八度
    tmp_res_higher = sin(4 * pi * f * t).*envelop(t);
    res = [res; tmp_res];
    res2 = [res2;tmp_res_higher];
end
res3 = resample(res,2,1);
res4 = resample(res,round(Fs*(2)^(1/12)),Fs);
% res 为原音频，res2为高八度不变速音频，res3为降低八度速度降为1/2音频，res4为重采样提高半音音频。


%k = linspace(0,1.5,500*1.5);
%figure(1);
%plot(k,envelop(k));
%figure(2);
% plot([0 : length(res3) - 1] / Fs, res3);
% sound(res3, Fs);
%sound(res4,Fs/2);
sound(res, Fs);

