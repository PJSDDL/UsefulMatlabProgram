close all;clear all;clc;

%% 参数设置
fs=10e3;Ts=1/fs;;T=2048*Ts;
lambda=3e8/24.15e9; % 雷达发射波长
N=600; % 向下取整，读取点数
t=(0:N-1)*Ts;
f=(0:N-1)*fs/N;

%% 读取数据
raw_data=load('2.txt');
figure(1);
plot(raw_data)

% data = raw_data(1:600,:);  %1.txt
% data = raw_data(1:600,:);  %2.txt
data = raw_data(1:600,:);  %3.txt
x=data(:,1);y=data(:,2);
I=x-mean(x);Q=y-mean(y); % 去直流
echo=I+1i*Q;
figure(2);
subplot(211)
plot(t,real(echo))
subplot(212)
plot(t,imag(echo))

%% 回波信号的频谱
echo_fft=fftshift(fft(echo));
f=(0:N-1)/N*fs-fs/2; % 将0放置于坐标轴中央
v=f*lambda/2; % 频率坐标转换为速度
figure(3);
plot(v,abs(echo_fft))

