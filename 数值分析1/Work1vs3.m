%割线法求方程的近似根
function [] = Work1vs3()
    clc

    x_1 = 0.4;
    x_2 = 0.6;
    x_3 = 0;
    
    for i = 1:5
        [y_1, ] = f1(x_1);
        [y_2, ] = f1(x_2);
        x_3 = x_2 - y_2 * (x_2-x_1) / (y_2-y_1);
        x_1 = x_2;
        x_2 = x_3;
    end
    
    x_3
    
end


function [y, dy] = f1(x)
    y = x * exp(x) - 1;
    dy = (x + 1) * exp(x);
end

