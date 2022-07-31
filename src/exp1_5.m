clear all, close all, clc;

tunes = get_tunes('C');
Fs = 8000;
beat_len = 0.5;
ratio = 2^(1/12);

low = @(x) x;
mid = @(x) x + 7;
high = @(x) x + 14;
pause = @(x) 22;

song = [...
    mid(1), 1; mid(2), 1; mid(3), 1;mid(1), 1;mid(2), 1;mid(5), 1;mid(5), 2; ...
    mid(3), 1; mid(6), 0.5;mid(6), 0.5; mid(6), 1;mid(6), 1; mid(5),1;mid(5), 1;mid(3), 2;...
    mid(1), 1; mid(1), 0.5;mid(1), 0.5;mid(1), 1;mid(6), 1;mid(5), 1;mid(3), 1;mid(5), 2; ...
    mid(2), 0.5;mid(2), 1;mid(3), 0.5;mid(3), 0.5;mid(2), 0.5;mid(1), 0.5;mid(2), 0.5;mid(1), 3;];

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
    tmp_res = waves*amps.*envelop_piano(t);
    res = [res; tmp_res];
end

%k = linspace(0,1.5,500*1.5);
%figure(1);
%plot(k,envelop(k));
%hold on;
%figure(2);
figure(1);
plot([0 : length(res) - 1] / Fs, res);
figure(2);
plot([0 : 200 - 1] / Fs, res(1 : 200));
sound(res, Fs);
