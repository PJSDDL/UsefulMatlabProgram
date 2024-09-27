clc
clear
close all;

A = 4;
T = 10^(-3);  
fs = 5*10^6;
f0 = 1*10^5;
B  = 4*10^6;
L = 512;

%模拟频率转化成数字频率
f0 = f0/fs;
B = B/fs;

%线性调频信号
t = [1:L];
k = B/T/fs;
x = A * exp(1i*6.28*(f0*t+0.5*k*t.*t));
x = [x x x x x];

plot(imag(x))

%STFT   
STFT = [];
STFT_N = 100;  %窗口长度
M = 90; %重合长度

move_length = STFT_N-M;
for i = 1:fix(5*L/move_length)-10
    start = 1+move_length*i;
    %fft
    x_n = x(start:start+STFT_N-1);
    
    %加窗类型
    x_n = x_n.*(hanning(STFT_N)');
    
    x_fft = fft(x_n);
    x_fft = fftshift(x_fft);
    x_abs = abs(x_fft);
    
    %求频率
    [amp,freq] = max(x_abs);
    
    %储存当前片段频率
    STFT = [STFT freq];
end

figure;
max_freq = max(STFT);
plot(STFT)
