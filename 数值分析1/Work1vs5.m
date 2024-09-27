%拟牛顿法求方程的近似根
function [] = Work1vs5()
    clc

    x = 1; y = 1; z = 1;
    
    [result, Jacob_maxtri] = f(x, y, z);
    H = eye(3) / Jacob_maxtri;
    
    for i = 1:3200
        [result, ] = f(x, y, z); %计算F（i）
        
        temp = [x, y, z] - (H*result)';  %计算x（i+1）
        x_ = temp(1); y_ = temp(2); z_ = temp(3);
        
        r = [x_, y_, z_] - [x, y, z];
    
        [result_, ] = f(x_, y_, z_); %计算F（i+1）
        Y = result_ - result;
        
        H = H + (r'-H*Y)* (r*H) / (r*H*Y); %计算H（i+1）
        
        x = x_;  y = y_;  z = z_;
    end
    
    result_
    x_ 
    y_
    z_
end

function [result, Jacob_maxtri] = f(x,y,z)
    result = [
        x*y - z*z - 1,
        x*y*z + y*y - x*x - 2,
        exp(x) + z - exp(y) - 3,
    ];
    Jacob_maxtri = [
        y, x, 2*z;
        y*z - 2*x, x*z + 2*y, x*y;
        exp(x), - exp(y), 1
    ];
end

