clc;
clear;

N=16;
pi = 3.14159267;
lable = [0:N-1];

x1 = [[1,1,1,1],zeros(1,N-4)];
x2 = [[1,2,3,4,4,3,2,1],zeros(1,N-8)];
x3 = [[4,3,2,1,1,2,3,4],zeros(1,N-8)];
x4 = cos(pi/8*[1:N]);
x5 = sin(pi/8*[1:N]);
x6 = cos(pi/8*[1:N])+cos(pi/16*[1:N])+cos(pi/20*[1:N]);

subplot(5,3,1)
plot(lable,x1)
subplot(5,3,2)
plot(lable,x2)
subplot(5,3,3)
plot(lable,x3)
subplot(5,3,4)
plot(lable,x4)
subplot(5,3,5)
plot(lable,x5)
subplot(5,3,6)
plot(lable,x6)

subplot(5,3,7)
plot(lable,abs(fft(x1)))
subplot(5,3,8)
plot(lable,abs(fft(x2)))
subplot(5,3,9)
plot(lable,abs(fft(x3)))
subplot(5,3,10)
plot(lable,abs(fft(x4)))
subplot(5,3,11)
plot(lable,abs(fft(x5)))
subplot(5,3,12)
plot(lable,abs(fft(x6)))

x = x4+x5*i
subplot(5,3,14)
plot(lable,abs(fft(x)))

% subplot(5,3,1)
% plot(lable,x1)
% subplot(5,3,2)
% plot(lable,x2)
% subplot(5,3,3)
% plot(lable,x3)
% subplot(5,3,4)
% plot(lable,x4)
% subplot(5,3,5)
% plot(lable,x5)
% subplot(5,3,6)
% plot(lable,x6)
% 
% subplot(5,3,7)
% plot(lable,phase(fft(x1)))
% subplot(5,3,8)
% plot(lable,phase(fft(x2)))
% subplot(5,3,9)
% plot(lable,phase(fft(x3)))
% subplot(5,3,10)
% plot(lable,phase(fft(x4)))
% subplot(5,3,11)
% plot(lable,phase(fft(x5)))
% subplot(5,3,12)
% plot(lable,phase(fft(x6)))
% 
% x = x4+x5*i
% subplot(5,3,14)
% plot(lable,phase(fft(x)))
% 
