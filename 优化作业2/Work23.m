%一级检验员x1 二级检验员x2
%25x1+15x2 >= 1800/8
%x1 <= 7
%x2 <= 8
%min 4x1+3x2+2*(0.02*25x1+0.05*15x2)

function [xm,fm,noi] = Work23(A,b,c)
    clc,clear;
    %不等式约束
    A=[ -25 -15
        1 0
        0 1];
    b=[-1800/8 7 8];
    %函数
    c=[5 4.5];
    
    x = linprog(c,A,b,[],[],[0 0],[]);
    
    disp('最优解为：');
    disp(x);

end