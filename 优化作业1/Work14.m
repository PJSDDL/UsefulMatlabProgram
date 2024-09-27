clc

x = 6;
x_list = [];


for i = 1:100
    x = x - (4*(x-5)^3)/(12*(x-5)^2);
    x_list = [x_list x];
end

plot(x_list)