clc
close all

[y, fs] = wavread('1.wav');

x1 = y(69500:71000);
x2 = y(71000:74500);

%项目1
subplot(2,1,1)
plot(log(abs(fft(x1(100:300)))));%窗口宽度200
title('语音1')
subplot(2,1,2)
plot(log(abs(fft(x2(1000:1201)))));
title('语音2')

%项目2
figure
subplot(3,1,1)
plot(log(abs(fft(x1(100:200))))); %窗口宽度100
title('窗口宽度100')
subplot(3,1,2)
plot(log(abs(fft(x1(100:700))))); %窗口宽度600
title('窗口宽度600')
subplot(3,1,3)
x1_ham = x1(100:300).*hamming(201);
plot(log(abs(fft(x1_ham)))); %海明窗
title('海明窗')

%项目3
figure
x2_fft = log(abs(fft(x2(1000:1500))));
x2_fft = x2_fft(1:100);
plot([1:100]*fs/500, x2_fft);

