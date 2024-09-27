clear;
clc;

fs = 10000;
esp = 10e-1;
c = 3*10e8;
fm = 10e3/32;
fa = 125*10e6;
f0 = 24.15*10e9;

raw_data = importdata('RADAR_2.txt');  %动目标
figure(1)
plot(raw_data)

%截取一段数据
N1 = 200;   %测速
raw_silce_v = raw_data(260:460,:);
N2 = 100;   %测距
raw_silce_1 = raw_data(140:240,:);
raw_silce_2 = raw_data(470:570,:);
raw_silce_v_I(:,1) = raw_silce_v(:,1) - mean(raw_silce_v(:,1));
raw_silce_v_Q(:,1) = raw_silce_v(:,2) - mean(raw_silce_v(:,2));   %去除直流分量
raw_silce_v = raw_silce_v_I + 1j*raw_silce_v_Q;
raw_silce_1(:,1) = raw_silce_1(:,1) - mean(raw_silce_1(:,1));
raw_silce_2(:,1) = raw_silce_2(:,1) - mean(raw_silce_2(:,1));
x_slice_v = raw_silce_v(:,1)+esp;
x_slice_1 = raw_silce_1(:,1)+esp;
x_slice_2 = raw_silce_2(:,1)+esp;

%FFT  测速
x_fft_v = fft(x_slice_v);
x_fft_v = fftshift(x_fft_v);
x_abs_v = abs(x_fft_v);
x_abs_v = log((x_abs_v)/max(x_abs_v));

figure(2)
x_label = (-N1/2:N1/2)*fs/N1;
x_label = x_label*c/(2*f0); %测速
plot(x_label,x_abs_v)

%FFT  测距
x_fft_1 = fft(x_slice_1);
x_abs_1 = abs(x_fft_1);
x_abs_1 = log((x_abs_1)/max(x_abs_1));
x_fft_2 = fft(x_slice_2);
x_abs_2 = abs(x_fft_2);
x_abs_2 = log((x_abs_2)/max(x_abs_2));

figure(3)
x_label = (0:N2)*fs/N2;
plot(x_label,x_abs_1,'r')
hold;
plot(x_label,x_abs_2)

%测距
f1 = 400;
f2 = 500;
x = c*abs(f1+f2)/(2*8*fa*fm)

