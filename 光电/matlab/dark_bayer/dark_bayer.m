close all
clear all
clc

%窗口长度
window_size=4;

%雾的去除度
w=0.95;

%读取源图像
imageres=imread('test1.bmp');

figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres);

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);

%求取暗通道数据
for i=1:1:ceil(imageres_heigth/window_size)
    for j=1:1:ceil(imageres_length/window_size)
        x_min = (i-1)*window_size+1;
        x_max = min(x_min + window_size-1,imageres_heigth);
        y_min = (j-1)*window_size+1;
        y_max = min(y_min + window_size-1,imageres_length);
        imagedark(x_min:x_max,y_min:y_max) = uint8(ones(x_max-x_min+1,y_max-y_min+1))*min(reshape(imageres(x_min:x_max,y_min:y_max,1),(x_max-x_min+1)*(y_max-y_min+1),1));
        %temp(i,j)=min(minimageres);
    end
end

figure,imshow(imagedark,[0 255]);
clear minimageres;

%求取大气光值
[imagedarksort,imagedarkindex]=max(imagedark);

%分离三个通道并
imageres_double=double(imageres);
atmo_light_value=0;
for i=1:1:imageres_length
    atmo_light_value=atmo_light_value+imageres_double(imagedarkindex(i),i);
end

atmo_light_value = round(atmo_light_value/imageres_length);

%求透射率，和大气光照无特别大的关系，小于0.1的需要特殊处理，有好多位置出现溢出的问题

image_tran_estimate=1-w*imagedark/max(atmo_light_value);

figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_tran_estimate = guidedfilter((imageres_double),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;

image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;

%%
%求无雾图像
imagedes = (imageres_double-atmo_light_value)./image_tran_estimate + atmo_light_value;

imagedes(imagedes>255)=255;
imagedes(imagedes<0)=0;
imagedes=round(imagedes);
imagedes = uint8(imagedes);
figure,imshow(imagedes,[0 255]);

imagergb = bayer2rgb_3block(double(imagedes));
%figure,imshow(imagergb,[0 255]);
