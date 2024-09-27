function W1
    clc

    a = 0.000 1; b = 1;
    
    temp = zeros([1,6]);
    n = 3;
    
    %º∆À„T0,k
    for i = 0:n
        S = 0;
        h = (b-a) / 2^i;
        
        for k = 0 : 2^i-1
            a_temp = a + k*h;
            b_temp = a + k*h + h;
            
            S = S + 0.5 * h * (f(a_temp) + f(b_temp));
        end
        
        temp(i+1) = S;
        
    end
    
    %µ›Õ∆º∆À„Tn£¨k
    for m = 1:n+1
        temp
        
        for i = 1 : n+1-m
            k = 4^m;
            temp(i) = (k * temp(i+1) - temp(i)) / (k - 1);
        end
        
    end
    
end

function y = f(x)
%      y = x*x*x;
     y = sin(x)/x;
%     y = sin(x^2);
end