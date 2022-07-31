clear all, close all; clc;

% 载入吉他的谐波文件
load("音乐合成大作业/assets/base.mat");
load("音乐合成大作业/assets/harmonics.mat");

Fs = 8000;
beat_len = 0.5;
tunes = my_get_tunes('C')';

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
harmonics = 1:10;

for i = 1 : 1 : len
    amps = [.03,zeros(1,9)]';
    f = tunes(song(i, 1)); %对应唱名的频率
    time_len = song(i, 2) * beat_len;
    guitar_idx = 0;
    for j = 1:length(base)
        if f == base(j)
            guitar_idx = j;
            amps = harmonic(j,:)';
            break;
        end
    end
    
    t = linspace(0, time_len - 1 / Fs, Fs * time_len)'; % 采样
    waves = sin(2*pi*f.*(t*harmonics));
    tmp_res = waves*amps.*envelop_piano(t);
    res = [res; tmp_res];
end

figure(1);
plot([0 : length(res) - 1] / Fs, res);
sound(res, Fs);

