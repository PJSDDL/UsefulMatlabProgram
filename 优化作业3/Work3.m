function [xm,fm,noi] = Work3()
    clc,clear;

    %二次型函数1/2xHx + cx
    %约束Ax = b
    %H对称阵
    H = [1  -1  0;  -1  sqrt(2)  0;  0  0  1];
    c = [0; 0; 1];
    A = [1  1  1;  2  -1  1];
    b = [4;  2];
    
    [x, lamda, fval] = fin(H, c, A, b)
end

function [x, lamda, fval] = fin(H, c, A, b)
   lamda = - (b + A/H * c)' / (A/H * A');
   lamda = lamda';
   x = - (c' + lamda'*A) / H;
   x = x';
   fval = 0.5*x'*H*x + c'*x;
end
