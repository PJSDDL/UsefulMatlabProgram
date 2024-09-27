%二分法计算sinx-0.5*x*x=0的根
%1，2
%0.5*1e-5

clc

a = 1;
b = 2;

for i = 1:50
    x = (a+b)/2.0;  
    if((sin(x) - x*x/2)*(sin(a) - a*a/2) < 0)
        b = x;
    else
        a = x;
    end
    
    if(b-a < 0.5*1e-5)
        i
        fprintf('a = %3.7f\n',b)
        fprintf('a = %3.7f\n',a)
        break
    end
end
