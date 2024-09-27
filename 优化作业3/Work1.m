function [xm,fm,noi] = Work1()
    clc,clear;

    %函数
    fun = @(x)x(1)*x(1)*(x(2)+2)*x(3);
    %自变量区域1<=x1<=4  4.5<=x2<=50  10<=x3<=30
    lb = [1, 4.5, 10];
    ub = [4, 50, 30];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    x0 = [3, 34, 20];
    
    nonlcon = @c;
    [x, fval] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon)
end

function [c, ceq] = c(x)
    c = [
        350 - 163 * (x(1)^(-2.86)) * (x(2)^(0.86)),
        10 - 0.004 * (x(1)^(-4)) * x(2) * (x(3)^3),
        x(1)*(x(2)+1.5) + 0.0044 * (x(1)^(-4)) * x(2) * (x(3)^3) - 3.7*x(3),
        375- 356000 * x(1) * (x(2)^(-1)) * (x(3)^(-2)),
        4 - x(3)/x(1),
        ];
    ceq = [];
end