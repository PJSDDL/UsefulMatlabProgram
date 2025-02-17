%% 改进透射率，使用导向滤波,t2为原版
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
imageres=imread('test1.jpg');
figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%求取暗通道数据
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%暗通道图像
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab自带的最小值滤波
imagedark = double(imagedark);

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

image_tran_estimate(image_tran_estimate<10^-4) = 10^-4;
image_tran_estimate(image_tran_estimate>1) = 1;

%求无雾图像
%imagedes_r = (imageres_r-229)./image_tran_estimate + 229;
%imagedes_g = (imageres_g-217)./image_tran_estimate + 217;
%imagedes_b = (imageres_b-195)./image_tran_estimate + 195;

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
imwrite(imagedes,'imagedes2_gf.jpg');
figure,imshow(imagedes,[0 255]);

%% 输出
%imagedes=uint8(imagedes);
%figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');
