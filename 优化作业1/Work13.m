function Work13
    clc
    
    %ËÑË÷·¶Î§
    x1 = 0;
    x2 = 1;

    u = x2;
    v = x1;

    for i = 1:20
        u = x1 + 0.618*(x2 - x1);
        v = x1 + 0.382*(x2 - x1);
        
        if(f(u) > f(v))
            x2 = u;
        else
            x1 = v;
        end 
        
        u 
        v          
    end
end

function [y] = f(x)
    y = x^2 - sin(x);
end

