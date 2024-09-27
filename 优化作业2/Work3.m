function [xm,fm,noi] = Work3(A,b,c)
clc,clear;
A=[ 1,1,1,0,0,0;
    1,2,0,1,0,0;
    1,0,0,0,1,0;
    0,1,0,0,0,1;  ]; 
b = [6,8,4,3];
c=[-2,-3,0,0,0,0]; 

X = linprog(c, [], [], A, b, [0 0 0 0], []);
disp('最优解为：');
disp(X);
end
