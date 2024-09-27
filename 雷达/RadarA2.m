clc
clear
close all

A = 4;
A_n = 1 * 10e3;
f0 = 1 * 10e6;
fs = 5 * 10e6;
k = 1;
L = 1000;

%噪声调频信号
t = [1:L];
noise = randn(1,L);
[b,a] = butter(3,0.9);
noise = filter(b,a,noise);  %噪声低通滤波
noise = noise/sqrt(sum(noise.*noise));  %噪声能量归一化
noise = A_n*noise;

n_p = [];
for i = 1:10
    n_p = [n_p cumsum(noise(1+(i-1)*L/10:i*L/10))];  %积分
end   
x = A * cos(6.28*(f0*t+k*n_p.*t)/fs);

plot(x)

%FFT
x_fft = fft(x);
x_abs = abs(x_fft).^2;
x_abs = fftshift(x_abs);
x_abs = log(x_abs/max(x_abs)+eps);

figure;
plot(x_abs(1:L/2))
