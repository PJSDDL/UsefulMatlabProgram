clear;
clc;

fs = 10000;
esp = 10e-1;
c = 3*10e8;
fm = 10e3/32;
fa = 125*10e6;
f0 = 24.15*10e9;

raw_data = importdata('range_still.txt');  %静目标
figure(1)
plot(raw_data)

%截取一段数据
N = 140;   %测距
raw_silce_1 = raw_data(920:1060,:);
raw_silce_2 = raw_data(920:1060,:);
raw_silce_1(:,1) = raw_silce_1(:,1) - mean(raw_silce_1(:,1));
raw_silce_2(:,1) = raw_silce_2(:,1) - mean(raw_silce_2(:,1));
x_slice_1 = raw_silce_1(:,1)+esp;
x_slice_2 = raw_silce_2(:,1)+esp;

figure(2)
plot(x_slice_1)

%FFT
x_fft = fft(x_slice_1);
x_abs = abs(x_fft);
x_abs = log((x_abs)/max(x_abs));

figure(3)
x_label = (0:N)*fs/N;
plot(x_label,x_abs)

%测距
f1 = 857.1;
x = c*f1/(8*fa*fm)
