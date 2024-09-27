 clc
close all

freq_z = 40e3; %采样率
length = 60000;

%------------------包络发生器------------------%
x_envelope_1 = exp(-[1:length]/30000);
% x_envelope_1 = exp(-[1:length]/1000);
x_envelope_2 = 0.01*sin(2*pi*1.5/freq_z*[1:length]) + 0.015;  %LFO

%------------------压控振荡器VCO------------------%
freq_x = 880;
x_sin = sin(2*pi*freq_x/freq_z*[1:length]);
x_saw = sawtooth(2*pi*freq_x/freq_z*[1:length]);
% x_saw = x_sin;

%------------------滤波器VCF------------------%
freq_r = 2500 / freq_z;
BW = 1000 / freq_z;

%二阶低通
%H(z) = z^-2 / (1 + z^-1 + z^-2) 
a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) exp(-2*pi*BW)]; 
b = [1+a(2)+a(3) 0 0]; 

% %一阶低通
% %H(z) = z^-2 / (1 + z^-1 + z^-2) 
% a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) 0]; 
% b = [1+a(2)+a(3) 0 0]; 


%滤波器特性分析
[h,w] = freqz(b,a,'whole',2001);
plot(w/pi, 10*log10(abs(h)))

y = [0 0];
temp = 0;

%开始滤波
for i = 1: length-2
%      freq_r = x_envelope_2(i);
%     freq_r = 1295.354569 /freq_z;
%     freq_r = 337.872791 /freq_z;
    
    a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) exp(-2*pi*BW)];
    b = [1+a(2)+a(3) 0 0];
    
    temp = b(1)*x_saw(i+2) + b(2)*x_saw(i+1) + b(3)*x_saw(i+0); 
    temp = temp - a(2)*y(i+1) - a(3)*y(i+0);
    y = [y temp];
end

%------------------压控放大VCA------------------%
y = y.* x_envelope_1;
y = y / max(y);
sound(y, freq_z);

figure
subplot(2,1,1)
plot(x_saw(1:2000))
subplot(2,1,2)
plot(y(1:2000))

figure
subplot(2,1,1)
plot(x_envelope_1)
subplot(2,1,2)
plot(y)