%改进牛顿法求方程的近似根
function [] = Work1vs4()
    clc

    x = 0.55;
    for i = 1:50
        [y, dy] = f3(x);
        x = x - 2*y/dy;
    end
    
    x

end

function [y, dy] = f3(x)
    y = (x-1)^2 * (2*x-1);
    dy = 2*(x-1)*(2*x-1) + (x-1)^2*2;
end

