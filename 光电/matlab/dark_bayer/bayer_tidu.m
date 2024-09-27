clear all;
close all;

%%
%选择图像
imagename='12.jpg';

%%
%读取源图像
image_res_rgb=imread(['test',imagename]);
figure,imshow(image_res_rgb,[0 255]);
image_res_rgb = double(image_res_rgb);

%得到图像的长和宽
[imageres_heigth,imageres_length]=size(image_res_rgb(:,:,1));
 %创建rggb的bayer图像
image_bayer_rggb = double(zeros(imageres_heigth,imageres_length));                                                    
image_turnback = double(zeros(imageres_heigth,imageres_length,3));    

%%
%先由原图按照RGGB方式获得BAYER图像
for i = 1:2:imageres_heigth                                                                                                                   %给所有的红色赋值
    for j = 1:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,1);
        image_turnback(i,j,1) = image_res_rgb(i,j,1);
    end
end

for i = 2:2:imageres_heigth                                                                                                                   %给所有的蓝色赋值
    for j = 2:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,3);
        image_turnback(i,j,3) = image_res_rgb(i,j,3);
    end
end

for i = 1:2:imageres_heigth                                                                                                                   %给所有的绿色赋值
    for j = 2:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,2);
        image_turnback(i,j,2) = image_res_rgb(i,j,2);
    end
end

for i = 2:2:imageres_heigth
    for j = 1:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,2);
        image_turnback(i,j,2) = image_res_rgb(i,j,2);
    end
end

figure,imshow(uint8(round(image_bayer_rggb)),[0,255]);
imwrite(uint8(round(image_bayer_rggb)),'test12.bmp');
image_bayer_rggb = double(image_bayer_rggb);

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%恢复所有点的绿色分量

for i = 3:2:imageres_heigth-2                                                                                                                  %给所有的红色点回复绿色分量
    for j = 3:2:imageres_length-2
              
%        tidu_x_r = abs(double(2*image_res_rgb(i,j,1) - image_res_rgb(i,j-2,1) - image_res_rgb(i,j+2,1)));            %x方向梯度，5*5模板
%        tidu_y_r = abs(double(2*image_res_rgb(i,j,1) - image_res_rgb(i-2,j,1) - image_res_rgb(i+2,j,1)));            %y方向梯度，5*5模板
       
       tidu_x_r = abs(double(image_bayer_rggb(i,j-1) - image_bayer_rggb(i,j+1)));            %x方向梯度，3*3模板
       tidu_y_r = abs(double(image_bayer_rggb(i-1,j) - image_bayer_rggb(i+1,j)));            %y方向梯度，3*3模板       
        
       if(tidu_x_r > tidu_y_r)
           image_turnback(i,j,2) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;
       elseif(tidu_x_r < tidu_y_r)
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;
       else
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1)+image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/4;
       end
        
    end
    end

for i = 4:2:imageres_heigth-2                                                                                                                   %给所有的蓝色点回复绿色分量
    for j = 4:2:imageres_length-2
        
%        tidu_x_b = abs(double(2*image_res_rgb(i,j,3) - image_res_rgb(i,j-2,3) - image_res_rgb(i,j+2,3)));            %x方向梯度，5*5模板
%        tidu_y_b = abs(double(2*image_res_rgb(i,j,3) - image_res_rgb(i-2,j,3) - image_res_rgb(i+2,j,3)));            %y方向梯度，5*5模板
       
       tidu_x_b = abs(double(image_bayer_rggb(i,j-1) - image_bayer_rggb(i,j+1)));            %x方向梯度，3*3模板
       tidu_y_b = abs(double(image_bayer_rggb(i-1,j) - image_bayer_rggb(i+1,j)));            %y方向梯度，3*3模板
       
       if(tidu_x_b > tidu_y_b)
           image_turnback(i,j,2) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;
       elseif(tidu_x_b < tidu_y_b)
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;
       else
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1)+image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/4;
       end
    end
end

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%恢复红色和蓝色分量

for i = 3:2:imageres_heigth-1                                                                                                                   %给所有的绿色点恢复红色分量和蓝色分量
    for j = 4:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) - image_turnback(i,j-1,2) - image_turnback(i,j+1,2))/2  + image_bayer_rggb(i,j);          %红色
        image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) - image_turnback(i-1,j,2) - image_turnback(i+1,j,2))/2  + image_bayer_rggb(i,j);          %蓝色
    end
end

for i = 4:2:imageres_heigth-1
    for j = 3:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) - image_turnback(i-1,j,2) - image_turnback(i+1,j,2))/2  + image_bayer_rggb(i,j);          %红色
        image_turnback(i,j,3) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) - image_turnback(i,j-1,2) - image_turnback(i,j+1,2))/2  + image_bayer_rggb(i,j);          %蓝色
    end
end

for i = 4:2:imageres_heigth-1                                                                                                                   %给所有的蓝色点恢复红色分量
    for j = 4:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) - image_turnback(i-1,j-1,2) - image_turnback(i-1,j+1,2) - image_turnback(i+1,j-1,2) - image_turnback(i+1,j+1,2))/4  + image_turnback(i,j,2);
    end
end

for i = 3:2:imageres_heigth-2                                                                                                                  %给所有的红色点回复蓝色分量
    for j = 3:2:imageres_length-2
         image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) - image_turnback(i-1,j-1,2) - image_turnback(i-1,j+1,2) - image_turnback(i+1,j-1,2) - image_turnback(i+1,j+1,2))/4  + image_turnback(i,j,2);    
    end
end

% r = image_turnback(:,:,1);
% r_1 = image_res_rgb(:,:,1);
% g = image_turnback(:,:,2);
% g_1 = image_res_rgb(:,:,2);
% b = image_turnback(:,:,3);
% b_1 = image_res_rgb(:,:,3);
figure,imshow(uint8(round(image_turnback)),[0,255],'border','tight','initialmagnification','fit');axis normal;      %画出恢复后的全彩图像
% A_1 = image_turnback(:,:,1);
% A_2 = image_turnback(:,:,2);
% A_3 = image_turnback(:,:,3);
% B_1 = image_res_rgb(:,:,1);
% B_2 = image_res_rgb(:,:,2);
% B_3 = image_res_rgb(:,:,3);
% 
% A_d = A_1 - B_1;
% B_d = A_2 - B_2;
% C_d = A_3 - B_3;
MES = 0;
for i = 2 : imageres_heigth-1    
    for j = 2 : imageres_length-1
        MES = (image_turnback(i,j,1) -  image_res_rgb(i,j,1))^2 + (image_turnback(i,j,2) -  image_res_rgb(i,j,2))^2 + (image_turnback(i,j,3) -  image_res_rgb(i,j,3))^2 + MES;
    end
end
MES = MES/(3*(imageres_heigth-1)*(imageres_length-1));
PSNR = 10*log(255^2/round(MES));






