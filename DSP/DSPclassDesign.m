clc;
clear;

Ts = 1/20000;  %采样间隔，单位毫秒
N = 1001;
w1 = 495*Ts*2*pi;    %计算数字频率
w2 = 505*Ts*2*pi;

%理想滤波器
h_ideal = ideallp(w2,N)-ideallp(w1,N);

%窗函数
h_window = hanning(N);

%测量滤波器曲线
h_ideal.*h_window'
[freqz,w] = freqz(h_ideal.*h_window',[1],1000,'whole');
freqz_abs = abs(freqz);

%横坐标归一化
w = 20000000*w/(2*pi);

% subplot(3,1,1);
% plot(h_ideal.*h_window');
% subplot(3,1,2);
% plot(w,20*log10(freqz_abs/max(freqz_abs)));
% subplot(3,1,3);
% plot(w,phase(freqz));

%输入正弦波进行测试
x1 = sin(Ts*400*2*pi*[1:10000]);
x2 = sin(Ts*500*2*pi*[1:10000]);
x3 = sin(Ts*600*2*pi*[1:10000]);
x4 = sin(Ts*700*2*pi*[1:10000]);

subplot(4,2,1);
plot(x1);
xlabel('400kh正弦波');
subplot(4,2,3);
plot(x2);
xlabel('500kh正弦波');
subplot(4,2,5);
plot(x3);
xlabel('600kh正弦波');
subplot(4,2,7);
plot(x4);
xlabel('700kh正弦波');
subplot(4,2,2);
plot(conv(x1,h_ideal.*h_window'));
xlabel('400kh正弦波通过滤波器');
subplot(4,2,4);
plot(conv(x2,h_ideal.*h_window'));
xlabel('500kh正弦波通过滤波器');
subplot(4,2,6);
plot(conv(x3,h_ideal.*h_window'));
xlabel('600kh正弦波通过滤波器');
subplot(4,2,8);
plot(conv(x4,h_ideal.*h_window'));
xlabel('700kh正弦波通过滤波器');