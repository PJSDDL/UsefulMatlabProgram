clc
close all

fs = 44100;
f = 440;

x = [0.1];
y = [0.1];
z = [0.1];
%ÂåÂ××È
a = 10;
b = 28;
c = 8/3;
%Rosser
w = 1;
a = 0.165;
b = 0.2;
c = 10;

delta_t = 1e-2;

for i = 1:100000
    if mod(i, 10000) == 0
        disp(i)
    end
    
%     %ÂåÂ××È
%     x_ = - (x(end) - y(end)) * a * delta_t + x(end);
%     y_ = (b * x(end) - y(end) - x(end) * z(end)) * delta_t + y(end);
%     z_ = (- c * z(end) + x(end) * y(end)) * delta_t + z(end);

    %Rosser
    x_ = ( - w * y(end) - z(end)) * delta_t + x(end);
    y_ = (w * x(end) +  y(end) * a) * delta_t + y(end);
    z_ = (b + z(end) * (x(end) - c)) * delta_t + z(end);
    
    x = [x, x_];
    y = [y, y_];
    z = [z, z_];
end

plot(x, y)

wavwrite(x/max(x), fs * 10, 'Chaos.wav')