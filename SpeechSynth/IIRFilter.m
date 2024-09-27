% clc
close all

freq_z = 20e3;%采样率

freq_r = 400 / freq_z;
BW = 100 / freq_z;

%H(z) = z^-2 / (1 + z^-1 + z^-2) 
a = [1 -2*exp(-3.14*BW)*cos(6.28*freq_r) exp(-6.28*BW)];
b = [1+a(2)+a(3) 0 0];
256*a
256*b

%滤波器特性分析
[h,w] = freqz(b,a,'whole',2001);
plot(w/pi, 10*log10(abs(h)))

%输入滤波器的波形
freq_x = 100;
x_sin = sin(6.28*freq_x/freq_z*[1:10000]);
x_saw = sawtooth(6.28*freq_x/freq_z*[1:10000]);
y = [0 0];
temp = 0;
%开始滤波
for i = 1: 10000-2
    temp = b(1)*x_saw(i+2) + b(2)*x_saw(i+1) + b(3)*x_saw(i+0); 
    temp = temp - a(2)*y(i+1) - a(3)*y(i+0);
    y = [y temp];
end

figure
subplot(2,1,1)
plot(x_saw(1:200))
subplot(2,1,2)
plot(y(1:200))