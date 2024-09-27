close all
clear all
clc

%窗口长度
window_size=5;

%雾的去除度
w=0.95;

%选择图像
imagename='17.jpg';

%读取源图像
%imageres=imread('test2.jpg');
%imageres = imread(['test',imagename]);
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
figure,imshow(imageres,[0 255]);

%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
Imin= min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1));
imagedark = double(imagedark);

%求取大气光值
image_A = reshape(imagedark,imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value = round(mean(image_A));

%分离三个通道
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%求透射率
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate,2*(window_size-1),0.0001);  
image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;
figure,imshow(image_tran_estimate,[0 1]);

%求无雾图像
imagedes_r = (imageres_r-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_g = (imageres_g-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_b = (imageres_b-atmo_light_value)./image_tran_estimate + atmo_light_value;

%clear imageres_r imageres_g imageres_b;
imagedes_r(imagedes_r>255)=255;
imagedes_g(imagedes_g>255)=255;
imagedes_b(imagedes_b>255)=255;
imagedes_r(imagedes_r<0)=0;
imagedes_g(imagedes_g<0)=0;
imagedes_b(imagedes_b<0)=0;
imagedes_r=round(imagedes_r);
imagedes_g=round(imagedes_g);
imagedes_b=round(imagedes_b);

imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
imagedes = uint8(imagedes);
%clear imagedes_r imagedes_g imagedes_b;
%imwrite(imagedes,['F:\XY\中期\mid-com1-',imagename]);
figure,imshow(imagedes,[0 255]);



