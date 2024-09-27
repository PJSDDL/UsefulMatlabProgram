%牛顿法求方程的近似根
function [] = Work1vs2()
    clc

    x = 0.5;
    for i = 1:20
        [y, dy] = f1(x);
        x = x - y/dy;
    end
    x
    
    x = 1;
    for i = 1:20
        [y, dy] = f2(x);
        x = x - y/dy;
    end
    x
    
    x = 0.45;
    for i = 1:50
        [y, dy] = f3(x);
        x = x - y/dy;
    end
    x
    
    x = 0.65;
    for i = 1:50
        [y, dy] = f3(x);
        x = x - y/dy;
    end
    x
end


function [y, dy] = f1(x)
    y = x * exp(x) - 1;
    dy = (x + 1) * exp(x);
end

function [y, dy] = f2(x)
    y = x^3 - x - 1;
    dy = 3*x*x - 1;
end

function [y, dy] = f3(x)
    y = (x-1)^2 * (2*x-1);
    dy = 2*(x-1)*(2*x-1) + (x-1)^2*2;
end

