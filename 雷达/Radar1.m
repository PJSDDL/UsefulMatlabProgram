clc
clear

%-------------------A-------------------%

f0 = 1 * 10^6;
fs = 4 * 10^7;
ts = 10 * 10^(-6); 
k = 3*10^(-4);
L = 400;

%矩形脉冲函数
t = [1:L];
x = (boxcar(L).') .* exp(1i*6.28*(f0/fs*t+k*t.*t/2));
% plot(x)
% plot(real(x))
 
%求频谱
x_fft = fft(x);
x_fft_abs = abs(x_fft);
x_fft_abs = x_fft_abs / max(x_fft_abs);
x_fft_abs = log(x_fft_abs);
% plot(x_fft_abs)

%求冲击函数
filter_fft = conj(x_fft);
filter = ifft(filter_fft);
% plot(filter)
% plot(real(filter))

%求输出信号
y_fft = x_fft.*filter_fft;
y = fftshift(ifft(y_fft));
y_abs = 20*log(abs(y)/max(abs(y)));
% plot(y_abs)

x_sinc = [-L/2:L/2]/2.7;
sinc = 390*sin(x_sinc) ./ x_sinc;
% plot(abs(y),'r'); hold;
% plot(abs(sinc))

%-------------------B-------------------%
% clc;
% clear;

transmitt = importdata('transmit_data.txt');
echo = importdata('echo_data.txt');

t = transmitt(:,1) + 1i*transmitt(:,2);
t_IQ = [t; zeros(56,1)];
e_IQ = echo(:,1) + 1i*echo(:,2);

%求发射波频谱
t_IQ_fft = fft(t_IQ);
t_IQ_fft_abs = abs(t_IQ_fft);
t_IQ_fft_abs = t_IQ_fft_abs / max(t_IQ_fft_abs);
t_IQ_fft_abs = log(t_IQ_fft_abs);
% plot(real(t_IQ)); 
% plot(t_IQ_fft_abs ,'r'); 

%求冲击函数
filter_fft = conj(t_IQ_fft);
filter = ifft(filter_fft);
% plot(filter)
% plot(real(filter))

%回波频谱
e_IQ_fft = fft(e_IQ);
e_IQ_fft_abs = abs(e_IQ_fft);
e_IQ_fft_abs = e_IQ_fft_abs / max(e_IQ_fft_abs);
e_IQ_fft_abs = log(e_IQ_fft_abs);
% plot(e_IQ_fft_abs,'g');

%求输出信号
y_fft = filter_fft.*e_IQ_fft;
y = fftshift(ifft(y_fft));
y_abs = 20*log(abs(y)/max(abs(y)));
x_lable = 0.5 * [1:1106] * 1/1050 * 300;
plot(x_lable,y_abs)




