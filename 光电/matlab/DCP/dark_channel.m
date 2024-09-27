function Idark = dark_channel(Iin,r)
% 功能：计算输入图像的暗通道
% 输入：Iin,输入图像（彩色，double）
%       r，最小值滤波领域半径
% 输出：Idark，图像暗通道（double）

%% 
% 初始化
Rin = Iin(:,:,1);
Gin = Iin(:,:,2);
Bin = Iin(:,:,3);
% [row,col] = size(Rin);

% 求RGB最小通道
Imin = min(Rin,min(Gin,Bin));

% tic;
% Idark = MinFilter(Imin,row,col,r);
Idark = ordfilt2(Imin,1,ones(2*r+1,2*r+1)); % matlab自带的最小值滤波
% toc;

end

%% 自定义最小值滤波
function i_out = MinFilter(i_in,row,col,r)
    i_ext = ReflectEdge(i_in,r);
    i_out = i_in;
    for i=1+r:row+r
        for j=1+r:col+r
            i_near = i_ext(i-r:i+r,j-r:j+r);  % 取当前像素点领域
            min_near = min(min(i_near));
            
            i_out(i-r,j-r) = min_near;      %最小值  
        end
    end
 
end
