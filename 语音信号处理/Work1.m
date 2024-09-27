clc
close all

[y, fs] = wavread('1.wav');

x1 = y(69500:71000);
x2 = y(71000:74500);

%��Ŀ1
subplot(2,1,1)
plot(log(abs(fft(x1(100:300)))));%���ڿ��200
title('����1')
subplot(2,1,2)
plot(log(abs(fft(x2(1000:1201)))));
title('����2')

%��Ŀ2
figure
subplot(3,1,1)
plot(log(abs(fft(x1(100:200))))); %���ڿ��100
title('���ڿ��100')
subplot(3,1,2)
plot(log(abs(fft(x1(100:700))))); %���ڿ��600
title('���ڿ��600')
subplot(3,1,3)
x1_ham = x1(100:300).*hamming(201);
plot(log(abs(fft(x1_ham)))); %������
title('������')

%��Ŀ3
figure
x2_fft = log(abs(fft(x2(1000:1500))));
x2_fft = x2_fft(1:100);
plot([1:100]*fs/500, x2_fft);

