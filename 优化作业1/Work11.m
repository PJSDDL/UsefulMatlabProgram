function Work11
    clc
    
    x = 1:0.01:2;
    
    plot(f(x))
    
    x1 = 1;
    x2 = 2;
    
    u = 0;
    v = 0;
    
    %黄金分割法
    for i = 1:100
        u = x1 + 0.618*(x2 - x1);
        v = x1 + 0.382*(x2 - x1);
        
        if(f(u) > f(v))
            x2 = u;
        else
            x1 = v;
        end
        
        if(x2 - x1 < 0.23)
            break
        end
    end
    
    x2
    x1
    
    %斐波那契法
    Fn1 = 1;
    Fn2 = 1;
    Fn3 = 2;
    
    for i = 1:100
        Fn3 = Fn2 + Fn1;
        Fn2 = Fn1;
        
        u = x1 + Fn2/Fn3 *(x2 - x1);
        v = x1 + Fn1/Fn3 *(x2 - x1);
        
        if(f(u) > f(v))
            x2 = u;
        else
            x1 = v;
        end
        
        if(x2 - x1 < 0.23)
            break
        end
    end
    
    x2
    x1
end

function [y] = f(x)
    y = 8*exp(1-x) + 7*log(x);
end














