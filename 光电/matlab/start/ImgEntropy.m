%==============================求图像信息熵=============================%
function H = ImgEntropy(Iin)
    [M,N] = size(Iin);
    Gray = zeros(1,256);
    
    % 灰度值统计
    for i=1:M
        for j=1:N
            Gray(Iin(i,j)+1) = Gray(Iin(i,j)+1)+1;
        end
    end
    
    Prob = Gray/(M*N);
    H = 0.0;
    for i=1:256
        if(Prob(i)>0)
            H = H-(Prob(i)*(log(Prob(i))/log(2.0)));
        end
    end
    
   
    