clc
close all

freq_z = 40e3; %采样率
length = 40000;

%------------------压控振荡器VCO------------------%
freq_x = 440;
x_saw = sawtooth(2*pi*freq_x/freq_z*[1:length]);

%------------------滤波器VCF------------------%
freq_r = 440 / freq_z;
BW = 100 / freq_z;

y = [0 0];
temp = 0;

%开始滤波
for i = 1: 40000-2
    freq_r = 1295.354569 /freq_z;
%     freq_r = 337.872791 /freq_z;
    
    a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) exp(-2*pi*BW)];
    b = [1+a(2)+a(3) 0 0];
    
    temp = b(1)*x_saw(i+2) + b(2)*x_saw(i+1) + b(3)*x_saw(i+0); 
    temp = temp - a(2)*y(i+1) - a(3)*y(i+0);
    y = [y temp];
end

%再次滤波
x_saw = y;
y = [0 0];
for i = 1: 40000-2
    freq_r = 1675.649291/freq_z
%     freq_r = 3246.894266/freq_z;
    
    a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) exp(-2*pi*BW)];
    b = [1+a(2)+a(3) 0 0];
    
    temp = b(1)*x_saw(i+2) + b(2)*x_saw(i+1) + b(3)*x_saw(i+0); 
    temp = temp - a(2)*y(i+1) - a(3)*y(i+0);
    y = [y temp];
end

%梅开三度
x_saw = y;
y = [0 0];
for i = 1: 40000-2
    freq_r = 3868.432292/freq_z;
%     freq_r = 3646.870095/freq_z;
    
    a = [1 -2*exp(-pi*BW)*cos(2*pi*freq_r) exp(-2*pi*BW)];
    b = [1+a(2)+a(3) 0 0];
    
    temp = b(1)*x_saw(i+2) + b(2)*x_saw(i+1) + b(3)*x_saw(i+0); 
    temp = temp - a(2)*y(i+1) - a(3)*y(i+0);
    y = [y temp];
end

%------------------压控放大VCA------------------%
% y = y.* x_envelope_1;
y = y / max(y);
sound(y, freq_z);
