clc
close all

%程序用于生成单片机波表

% x = 127*sin(2*3.1415926*[1:1000]/1000);
% x = 255 * rand(1, 1000) - 127;
% x = 256 * exp(-3.1415926*[1:1000]/1000)
% x = 126*cos(2*3.1415926*[1:1000]/1000);
[x_s, fs] = wavread('sddl.wav');
x_s = 128 * (x_s / max(x_s));
x = resample(x_s(:,1),1,2);
x = fix(x);
plot(x)

fileID = fopen('table.txt', 'w');
fprintf(fileID, ',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n', x);
fclose(fileID);

