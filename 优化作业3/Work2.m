function [xm,fm,noi] = Work2()
    clc,clear;

    %º¯Êý
    fun = @(x)x(1)*x(1)*(x(2)+2)*x(3);
    
    H = [1 -1; -1 2]; 
    f = [-2; -6];
    A = [1 1; -1 2; 2 1];
    b = [2; 2; 3];
    
    [x,fval,exitflag,output,lambda] = quadprog(H,f,A,b);
    x
    fval
    lambda.lower
end
