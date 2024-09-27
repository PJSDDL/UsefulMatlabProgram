clc
close all

%------------------语音频谱------------------
[x,fs] = wavread('a.wav');
start = 450000;
length = 451000-450000;
x_e = x(start: start+length);

x_e

fft_speech = log(abs(fft(x_e)));
plot((0:length)*fs/length, fft_speech)


%------------------锯齿波------------------
t = [1:fs];  %时间
x_saw = sawtooth(2*pi*310/fs*t);

hold
scale = 1: length+1;

fft_saw = log(abs(fft(x_saw(scale))));

%------------------设计第一带通滤波器------------------
Ts = 1/fs;  %采样间隔，单位毫秒
N = 51;
w1 = 283*Ts*2*pi;    %计算数字频率
w2 = 483*Ts*2*pi;

h_ideal = ideallp(w2,N)-ideallp(w1,N);
h_window = hanning(N);

conv1 = h_ideal.*h_window';

%------------------设计第二带通滤波器------------------
w1 = 1246*Ts*2*pi;    %计算数字频率
w2 = 1446*Ts*2*pi;

h_ideal = ideallp(w2,N)-ideallp(w1,N);
h_window = hanning(N);

conv2 = h_ideal.*h_window';

%------------------设计第三带通滤波器------------------
w1 = 3168*Ts*2*pi;    %计算数字频率
w2 = 3368*Ts*2*pi;

h_ideal = ideallp(w2,N)-ideallp(w1,N);
h_window = hanning(N);

conv3 = h_ideal.*h_window';

y = conv(x_saw, conv1);
y = conv(y, conv2);
y = conv(y, conv3);

figure
plot(log(abs(fft(y))))

wavwrite(y/max(y), fs, 'speech.wav')