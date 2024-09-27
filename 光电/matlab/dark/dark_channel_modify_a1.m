%% 改进透射率，使用形态学滤波
close all
clear all
clc

%窗口半径
window_size=7;

%雾的去除度
w=0.95;

%选择图像
imagename='2.jpg';
tic
%读取源图像
%imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres=imread('test.jpg');
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
imwrite(image_tran_estimate,'image_tran_estimate1_no.jpg');

%改进透射率，形态学滤波
se = strel('ball',window_size);%disk(圆),diamond（菱形）,ball（球）,square（正方形）
image_tran_estimate=uint8(round(image_tran_estimate*255));
image_tran_estimate = imerode(image_tran_estimate,se);
%image_tran_estimate = medfilt2(image_tran_estimate,[20,20]); 
%figure(2);
%imshow(image_tran_estimate,[0 255]);
image_tran_estimate=double(image_tran_estimate)/255;

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

toc

imwrite(image_tran_estimate,'image_tran_estimate1_mor_ball.jpg');
imwrite(imagedes,'imagedes1_mor_ball.jpg');
figure,imshow(imagedes,[0 255]);

%% 处理
%imagedes(:,:,1)=adapthisteq(imagedes(:,:,1));
%imagedes(:,:,2)=adapthisteq(imagedes(:,:,2));
%imagedes(:,:,3)=adapthisteq(imagedes(:,:,3));
%figure,imshow(imagedes,[0 255]);

%% 输出
%imagedes=uint8(imagedes);
%figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');
