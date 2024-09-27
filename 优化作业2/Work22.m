%甲加工三种零件的时间x1 x2 x3
%乙加工三种零件的时间x4 x5 x6
%0.6x1+1.2x2+1.1x3 <= 600 
%0.4x1+1.2x2+1.0x3 <= 900 
%x1+x4 >= 400
%x2+x5 >= 600
%x3+x6 >= 500
%min 13x1 + 9x2+ 10x3 + 11x4 + 12x5 + 8x6

function [xm,fm,noi] = Work22(A,b,c)
    clc,clear;
    %不等式约束
    A=[ 0.6  1.2  1.1  0  0  0 
        0  0  0  0.4  1.2 1.0 
        -1  0  0  -1  0  0
        0  -1  0  0  -1  0
        0  0  -1  0  0  -1  ];
    b=[600 900 -400 -600 -500];
    %函数
    c=[13 9 10 11 12 8];
    
    x = linprog(c,A,b,[],[],[0 0 0 0],[]);
    
    disp('最优解为：');
    disp(x);

end