clc
close all

% ÔªÒô
[x1,fs1]=wavread('6.wav'); 
x1 = x1(2000: 3000);
% Ä¦²ÁÒô
samples1 = [11015,11215];
[x2,fs2]=wavread('4.wav',samples1); 

x1_cceps = fftshift(cceps(x1));
x2_cceps = fftshift(cceps(x2));

subplot(2,1,1)
plot(x1_cceps)
subplot(2,1,2)
plot(x2_cceps)
figure

[xhat1,yhat1] = rceps(x1);
[xhat2,yhat2] = rceps(x2);

subplot(2,1,1)
plot(fftshift(xhat1))
subplot(2,1,2)
plot(fftshift(xhat2))
figure

subplot(2,1,1)
plot(fftshift(abs(fft(yhat1))))
subplot(2,1,2)
plot(fftshift(abs(fft(yhat2))))