function [ output_args ] = Untitled1( input_args )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here

%必要参数
N = 25;
EX=0;
DX=0;

%高斯白噪声
N=1000;
x = sqrt(2)*randn(1,N);

%自相关函数
subplot(2,2,1);
plot(xcorr(x));

%功率谱密度
Sx = fft(xcorr(x),2000);
subplot(2,2,2);
plot(log(abs(Sx)/max(abs(Sx))));

%信号通过滤波器
%N=2000，采样率10Hz
x = x+sin((1:N)*0.628);
filter = fir1(101,0.3);
y = fftfilt(filter,x);

%功率谱密度
Sx = fft(xcorr(x),2000);
subplot(2,2,3);
plot(log(abs(Sx)/max(abs(Sx))));
Sy = fft(xcorr(y),2000);
subplot(2,2,4);
plot(log(abs(Sy)/max(abs(Sx))));

end
