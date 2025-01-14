clc;
close all;

%--------------------1---------------------%
%% 语音的波形特点
% 元音
[x1,fs1]=wavread('6.wav'); 
N=length(x1);
time=(0:N-1)/fs1;
subplot(2,2,1);
plot(time,x1);
title('元音信号波形');
% 摩擦音
samples1 = [11015,15251];
[x2,fs2]=wavread('4.wav',samples1); 
N=length(x2);
time=(0:N-1)/fs2;
subplot(2,2,2);
plot(time,x2);
title('摩擦音信号波形');
% 爆破音
samples2 = [4800,6100];
[x3,fs3]=wavread('7.wav',samples2); 
N=length(x3);
time=(0:N-1)/fs3;
subplot(2,2,3);
plot(time,x3);
title('爆破音信号波形');
% 鼻音
samples3= [6600,9000];
[x4,fs4]=wavread('8.wav',samples3); 
N=length(x4);
time=(0:N-1)/fs4;
subplot(2,2,4);
plot(time,x4);
title('鼻音信号波形');

%--------------------2---------------------%
%% 语音的端点检测
[yq,fsq]=wavread('6.wav');
% 设定参数
frame_size=0.01; % 10毫秒帧大小
overlap=0.5; % 50%的重叠
energy_threshold=0.02; % 能量阈值
% 计算帧大小和帧移
frame_length=round(frame_size*fsq);
frame_shift=round(frame_length);
% 计算短时能量
energy=sum(buffer(yq.^2,frame_length));
% 计算能量阈值
threshold=energy_threshold*max(energy);
% 找到超过阈值的帧
voiced_frames=find(energy>threshold);
% 根据帧索引计算对应的时间
voiced_time=(voiced_frames-1)*frame_shift/fsq;
% 绘制语音波形和端点检测结果
figure;
subplot(2,1,1)
plot((0:length(yq)-1)/fsq,yq);
title('语音信号波形');

subplot(2,1,2)
plot((0:length(energy)-1)*frame_shift/fsq, energy,'r-','LineWidth',2);
hold on;
plot(voiced_time, threshold*ones(size(voiced_time)),'g--','LineWidth',2);
title('短时能量端点检测');legend('短时能量', '端点检测阈值');xlabel('时间/s');
hold off;

%% 清音浊音对比
[yq,fsq]=wavread('10.wav');
[yz,fsz]=wavread('6.wav');
% 设定参数
frame_size=0.02; % 20毫秒帧大小
energy_threshold=0.02; % 能量阈值
% 计算帧大小和帧移
frame_lengthq=round(frame_size*fsq);
frame_lengthz=round(frame_size*fsz);
% 计算短时能量
energyq=sum(buffer(yq.^2,frame_length));
energyz=sum(buffer(yz.^2,frame_length));
% 计算能量阈值
thresholdq=energy_threshold*max(energyq);
thresholdz=energy_threshold*max(energyz);
% 找到超过阈值的帧
voiced_framesq=find(energyq>thresholdq);
voiced_framesz=find(energyz>thresholdz);
% 根据帧索引计算对应的时间
voiced_timeq=(voiced_framesq-1)*frame_shift/fsq;
voiced_timez=(voiced_framesz-1)*frame_shift/fsz;
% 绘制语音波形和端点检测结果
figure;
subplot(2,1,1)
plot((0:length(yq)-1)/fsq,yq);
title('语音信号波形');

subplot(2,1,2)
plot((0:length(energyq)-1)*frame_shift/fsq, energyq,'b-','LineWidth',2);
hold on;
plot(voiced_timeq, thresholdq*ones(size(voiced_timeq)),'r--','LineWidth',2);
title('清音短时能量端点检测');legend('短时能量', '端点检测阈值');xlabel('时间/s');
hold off;

figure;
subplot(2,1,1)
plot((0:length(yz)-1)/fsq,yz);
title('语音信号波形');

subplot(2,1,2)
plot((0:length(energyz)-1)*frame_shift/fsz, energyz,'b-','LineWidth',2);
hold on;
plot(voiced_timez, thresholdz*ones(size(voiced_timez)),'r--','LineWidth',2);
title('浊音短时能量端点检测');legend('短时能量', '端点检测阈值');xlabel('时间/s');
hold off;
%% 加入噪声
% 生成噪声
[y,fs] = wavread('语音信号处理\1.wav');
noise_level_low=0.001; %低SNR背景噪声水平
noise_level_high=0.1; %高SNR背景噪声水平
noise_low=noise_level_low*randn(size(y));
noise_high=noise_level_high*randn(size(y));

% 生成低SNR语音和高SNR语音
speech_low_snr=y+noise_low;
speech_high_snr=y+noise_high;
y1=speech_low_snr;
y2=speech_high_snr;

% 进行端点检测
frame_size=0.02; % 20毫秒帧大小
overlap=0.5; % 50%的重叠
energy_threshold=0.02; % 能量阈值
% 计算帧大小和帧移
frame_length=round(frame_size*fs);
frame_shift=round(frame_length*(1-overlap));

% 计算短时能量
energy1=sum(buffer(y1.^2,frame_length,frame_shift));
energy2=sum(buffer(y2.^2,frame_length,frame_shift));

% 计算能量阈值
threshold1=energy_threshold*max(energy1);
threshold2=energy_threshold*max(energy2);

% 找到超过阈值的帧
voiced_frames1=find(energy1>threshold1);
voiced_frames2=find(energy2>threshold2);

% 根据帧索引计算对应的时间
voiced_time1=(voiced_frames1-1)*frame_shift/fs;
voiced_time2=(voiced_frames2-1)*frame_shift/fs;

% 显示原始语音和添加噪声后的语音波形
figure;
subplot(2,2,1)
plot((0:length(y)-1)/fs, y);
title('原始语音信号');

subplot(2,2,2)
plot((0:length(speech_low_snr)-1)/fs, speech_low_snr);
title('低噪声条件下的语音信号');

subplot(2,2,3)
plot((0:length(speech_high_snr)-1)/fs, speech_high_snr);
title('高噪声条件下的语音信号');

% 显示端点检测结果
figure;
subplot(2,2,1)
plot((0:length(energy1)-1)*frame_shift/fs, energy1,'r-','LineWidth',2);
hold on;
plot(voiced_time1, threshold1 * ones(size(voiced_time1)), 'g--', 'LineWidth', 2);
title('低噪声语音信号端点检测');legend('低噪声语音信号', '端点检测阈值');xlabel('时间/s');
hold off;

subplot(2,2,2)
plot((0:length(energy2)-1)*frame_shift/fs, energy2,'r-','LineWidth',2);
hold on;
plot(voiced_time2, threshold2 * ones(size(voiced_time2)), 'g--', 'LineWidth', 2);
title('高噪声语音信号端点检测');legend('高噪声语音信号', '端点检测阈值');xlabel('时间/s');
hold off;

%--------------------3---------------------%
%% 基于幅度信息的语音感知
[y,fs]=wavread('1.wav');
amplitude=abs(y);% 初始化随机相位
random_phase=exp(1i*2*pi*rand(size(y)));% 迭代优化相位信息
num_iterations=100;
reconstructed_signal=amplitude.*random_phase;

for iter=1:num_iterations
    current_phase=angle(hilbert(real(ifft(reconstructed_signal))));% 使用希尔伯特变换获取当前相位估计
    reconstructed_signal=amplitude.*exp(1i * current_phase);% 使用当前相位估计更新重构信号
end
reconstructed_audio=real(ifft(reconstructed_signal));
sound(y,fs); 
pause(3); 
sound(reconstructed_audio,fs); 