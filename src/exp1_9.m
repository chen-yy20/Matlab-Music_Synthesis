close all, clear all; clc;
music = audioread("音乐合成大作业\assets\fmt.wav");
N = length(music);

% 获取包络
[up_en,low_en] = envelope(music,400,'peak');
en = (up_en-low_en)/2;
dis_en = abs(0.5685-en);

% 找到波峰波谷
[pks,locs] = findpeaks(en,'MinPeakHeight',0.13,'MinPeakDistance',3000);
[lows,low_locs] = findpeaks(dis_en,'MinPeakHeight',0.43,'MinPeakDistance',3000);
lows = 0.5685-lows;

subplot(3,1,2);
plot(music);
title("音乐波形");

% 两个极小值点作为一个音的起始和结束
beat_start = [];
beat_end = [];
shamt = 0; % 偏移量
for i = 1: length(low_locs)-1
    if (i+shamt <= 26)
    if (low_locs(i)<locs(i+shamt))&&(low_locs(i+1)>locs(i+shamt))
         beat_start = [beat_start;low_locs(i)];
         beat_end = [beat_end;low_locs(i+1)];
    
    elseif  (low_locs(i)>=locs(i+shamt))
        shamt = shamt+1;
        i = i-1;
    elseif (low_locs(i+1)<=locs(i+shamt))
        beat_end(end) = low_locs(i+1);
        shamt = shamt -1;
    end
    end
end
subplot(3,1,1);
plot(en);
title("包络波形分割");
text(beat_start+.02,en(beat_start),num2str((1:numel(beat_start))'),'Color','g');
text(beat_end+.02,en(beat_end)-0.02,num2str((1:numel(beat_end))'),'Color','r'); %标出每一个切割的点
% 单音切割与频域分析
base = [];
beat = []; %记录每一个单音的时长
harmonic = zeros(length(beat_end),10);

for i = 1:length(beat_start)
L = beat_end(i) - beat_start(i);
beat = [beat;L];
segment = music(beat_start(i):beat_end(i));
segment = segment(round(0.05*L):round(0.95*L));
rep_seg = repmat(segment,1024,1);
% plot(rep_seg)
[f,F] = my_fft(rep_seg);
[max_peak,max_i] = max(F);
[f_pks,f_locs] = findpeaks(F(1:round(length(F)/5)),"MinPeakHeight",max_peak/3,'MinPeakDistance',3000);
% 根据总和声幅度最高的频率寻找基频
cal_base = zeros(length(f_locs),5);
for j = 1:length(f_locs)
    for k = 1:5
        cal_base(j,k) = max(F(f_locs(j)*k-1500:f_locs(j)*k+1500));
        if (f(k*f_locs(j))>=260 && f(k*f_locs(j))<=500)
            % fprintf("No. %d f=%f cal_base(%d,%d)=%f, double\n",i,f(k*f_locs(j)),j,k,cal_base(j,k));
            cal_base(j,k) = 2*cal_base(j,k);
        end
    end
end
sum_base = sum(cal_base,2);
[~,idx] = max(sum_base);
if (sound_fix(i))
    idx = sound_fix(i);
end
base_i = f_locs(idx);
this_base = f(base_i);
harmonic(i,1) = F(base_i);

fprintf("No.%d base_i %d\n",i,this_base);
% for j = 2:5
%     this_f = round(base_i/j);
%     if (max(F(this_f-1500:this_f+1500)) >= max_peak/2)
%         fprintf(" times:%d origin_f:%d  new_i：%d",j,this_base,this_f);
%         this_base = f(this_f);
%         base_i = this_f;
%         fprintf("   new_f: %d",this_base);
%     end
% end
% plot(f,F);
base = [base;this_base];
% 寻找2-10次谐波
% harmonic(i,1) = max(F(base_i-1500:base_i+1500));  % 更新基波幅度
% fprintf("  final_base_i:%d  amp:%d\n",base_i,F(base_i));
for j = 2:10
    temp_i = j*base_i;
    if (temp_i+1500 > length(F))
        harmonic(i,j) = 0;
    else
        harmonic(i,j) = max(F(temp_i-1500:temp_i+1500));%取范围内的最大值
    end
end

end

% 定调
tunes = ['C','D','E','F','G','A','B'];
all_tunes = [];
tunes_cnt = zeros(7,1); % 记录每个调的得分
for i = 1:7
    this_tune = my_get_tunes(tunes(i));
    all_tunes = [all_tunes;this_tune];
end
% 匹配基音
esp = 3; %误差在 esp Hz内可认为频率相等

for i = 1:length(base)
    temp = abs(base(i)-all_tunes);
    cnt = temp <= esp;
    tunes_cnt = tunes_cnt + sum(cnt,2);
end
[m,idx] = max(tunes_cnt);
major = tunes(idx);
tunes = my_get_tunes(major);
temp = tunes;
% 转换基音为标准音
for i = 1:length(base)
    for j=1:length(temp)
        if abs(base(i) -temp(j))<=3
            base(i) = temp(j);
        end
    end
end

har_amp = harmonic;
% 重新播放乐曲
my_music = [];
Fs = 8192;
for i=1:length(beat)
    f = base(i);
    sample_num = beat(i);
    t = linspace(0, sample_num/Fs, sample_num)'; % 采样
    temp_music = har_amp(i,1)*sin(2*pi*base(i)*t);
    for j = 2:10
        temp_music = temp_music + har_amp(i,j)*sin(2*pi*base(i)*j*t);
    end
    temp_music = temp_music.*envelop_piano(t);
    my_music = [my_music;temp_music];
end
subplot(3,1,3);
plot((0 : length(my_music) - 1) / Fs, my_music);
title("重新合成音乐");
sound(my_music,Fs);

save('音乐合成大作业/assets/base.mat','base');
save('音乐合成大作业/assets/harmonics.mat','harmonic');














