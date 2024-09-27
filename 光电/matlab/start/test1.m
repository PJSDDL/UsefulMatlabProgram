close all
clear all
clc

%窗口长度
window_size=8;

%雾的去除度
w=0.95;

%选择图像
imagename='.jpg';

%读取源图像
%imageres=imread('F:\XY\master_thesis\speedtestimage\test17.jpg');
imageres = imread(['3',imagename]);
imagegray = rgb2gray(imageres);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%%
%计算透射率

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);
%求取暗通道数据
for i=1:1:ceil(imageres_heigth/window_size)
    for j=1:1:ceil(imageres_length/window_size)
        x_min = (i-1)*window_size+1;
        x_max = min(x_min + window_size-1,imageres_heigth);
        y_min = (j-1)*window_size+1;
        y_max = min(y_min + window_size-1,imageres_length);
        minimageres(1)=min(reshape(imageres(x_min:x_max,y_min:y_max,1),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(2)=min(reshape(imageres(x_min:x_max,y_min:y_max,2),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(3)=min(reshape(imageres(x_min:x_max,y_min:y_max,3),(x_max-x_min+1)*(y_max-y_min+1),1));
        imagedark(x_min:x_max,y_min:y_max) = uint8(ones(x_max-x_min+1,y_max-y_min+1))*min(minimageres);
        %temp(i,j)=min(minimageres);
    end
end
clear minimageres;

%求取大气光值
[imagedarksort,imagedarkindex]=max(imagedark);

%分离三个通道并
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

atmo_light_value_r_temp=double(0);
atmo_light_value_g_temp=double(0);
atmo_light_value_b_temp=double(0);
for i=1:1:imageres_length
    atmo_light_value_r_temp=atmo_light_value_r_temp+imageres_r(imagedarkindex(i),i);
    atmo_light_value_g_temp=atmo_light_value_g_temp+imageres_g(imagedarkindex(i),i);
    atmo_light_value_b_temp=atmo_light_value_b_temp+imageres_b(imagedarkindex(i),i);
end

atmo_light_value(1)=round(atmo_light_value_r_temp/imageres_length);
atmo_light_value(2)=round(atmo_light_value_g_temp/imageres_length);
atmo_light_value(3)=round(atmo_light_value_b_temp/imageres_length);

%求透射率，和大气光照无特别大的关系，小于0.1的需要特殊处理，有好多位置出现溢出的问题
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
atmo_light_max = max(atmo_light_value);
%figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;

image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;

image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;

%%
%计算canny
imageedgetemp = ones(imageres_heigth+2,imageres_length+2);
imageedge = edge(imagegray,'canny');  % 调用canny函数  

imageedgeres = imageedge;

se = strel('square',5);%disk(圆),diamond（菱形）,ball（球）,square（正方形）
imageedgetemp(2:(imageres_heigth+1),2:(imageres_length+1)) = imclose(imageedge,se);
figure,imshow(imageedgetemp,[0 1]);
index = image_tran_estimate > 0.1;
imageedgetemp(1,2:(imageres_length+1)) = index(1,:);
%imagegray=bwperim(imagegray);  
imageedgetemp=imfill(imageedgetemp,'holes');
imageedge = imageedgetemp(2:(imageres_heigth+1),2:(imageres_length+1));
%figure,imshow(imageedge,[0 1]);
imageedge = ~imageedge;
imageedge=imfill(imageedge,'holes');
%imageedge=bwperim(imageedge);  
figure,imshow(imageedge,[0 1]);
%figure,imshow(imageedgeres,[0 1]);

%%
%求无雾图像
atmo_light_value = zeros(imageres_heigth,imageres_length);

%%
%这个里面的可变参数很重要，即30
%atmo_light_max = atmo_light_max-5;
atmo_light_min = atmo_light_max-30; 

%%
atmo_light_value = atmo_light_max;

%atmo_light_value(image_tran_estimate<0.5) = atmo_light_min-20;
image_tran_estimate(imageedge) = 1 - image_tran_estimate(imageedge);

tic
imagedes_r = (imageres_r-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_g = (imageres_g-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_b = (imageres_b-atmo_light_value)./image_tran_estimate + atmo_light_value;

%clear imageres_r imageres_g imageres_b;
toc
imagedes_r = uint8(imagedes_r);
imagedes_g = uint8(imagedes_g);
imagedes_b = uint8(imagedes_b);

imagedes(:,:,1) = imagedes_r;
imagedes(:,:,2) = imagedes_g;
imagedes(:,:,3) = imagedes_b;
figure,imshow(imagedes,[0 255]);