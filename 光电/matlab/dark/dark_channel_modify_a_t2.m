%% 改进透射率，使用导向滤波
close all
clear all
clc

%窗口半径
window_size=7;

%雾的去除度
w=0.95;

%选择图像
imagename='2.jpg';

%读取源图像
%imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres=imread('test.jpg');
figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);

%求取暗通道数据
for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        if(i<=window_size)
            x_min = i;
        else 
            x_min = i - window_size;
        end
        
        x_max = i +  window_size;
        if(x_max>imageres_heigth)
            x_max = imageres_heigth;
        end
        
        if(j<=window_size)
            y_min = j;
        else 
            y_min = j - window_size;
        end
        
        y_max = j + window_size;
        if(y_max>imageres_length)
            y_max = imageres_length;
        end
        res = imageres(x_min:x_max,y_min:y_max,1);
        minimageres(1)=min(reshape(imageres(x_min:x_max,y_min:y_max,1),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(2)=min(reshape(imageres(x_min:x_max,y_min:y_max,2),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(3)=min(reshape(imageres(x_min:x_max,y_min:y_max,3),(x_max-x_min+1)*(y_max-y_min+1),1));
        imagedark(i,j)=min(minimageres);
    end
end

%figure,imshow(imagedark,[0 255]);
%imwrite(uint8(imagedark),'imagedark.jpg');
clear minimageres;

%求取大气光值
image_A = reshape(imagedark,imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value = round(mean(image_A));

%分离三个通道并
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%求透射率，和大气光照无特别大的关系
image_tran_estimate=1-w*imagedark/atmo_light_value;
image_tran_estimate(image_tran_estimate<0.1)=0.1;
figure,imshow(image_tran_estimate,[0 1]);
%imwrite(image_tran_estimate,'image_tran_estimate1_no.jpg');

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate_temp=image_tran_estimate;

image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate_temp,28,10^-4);  
figure,imshow(image_tran_estimate,[0 1]);

%求无雾图像
imagedes_r = (imageres_r-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_g = (imageres_g-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_b = (imageres_b-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_r(imagedes_r>255)=255;
imagedes_g(imagedes_g>255)=255;
imagedes_b(imagedes_b>255)=255;
imagedes_r(imagedes_r<0)=0;
imagedes_g(imagedes_g<0)=0;
imagedes_b(imagedes_b<0)=0;
imagedes_r=round(imagedes_r);
imagedes_g=round(imagedes_g);
imagedes_b=round(imagedes_b);

imagedes(:,:,1)=uint8(imagedes_r);
imagedes(:,:,2)=uint8(imagedes_g);
imagedes(:,:,3)=uint8(imagedes_b);

%imwrite(image_tran_estimate,'image_tran_estimate1_mor_ball.jpg');
%imwrite(imagedes,'imagedes1_mor_ball.jpg');
figure,imshow(imagedes,[0 255]);

%% 输出
%imagedes=uint8(imagedes);
%figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');
