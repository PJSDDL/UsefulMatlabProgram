clc
close all

y1 = [];
y2 = [];
temp = 0;
w = 6.28 * 0.003;

for i = 1: 1000
    temp = 0;
    
    for n = 1: 2: 1111
        temp = temp + 1 / n *sin(n * w * i);
    end
    
    y1 = [y1 temp];
end

for i = 1: 1000
    temp = 0;
    
    for n = 1: 2: 1111
        temp = temp + 1 / n *sin(2 * n * w * i);
    end
    
    y2 = [y2 temp];
end

plot(y1 + 0.5 * y2)