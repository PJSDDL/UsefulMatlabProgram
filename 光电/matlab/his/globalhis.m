%% 全局直方图均衡
close all
clear all
clc
%% 图像输入及参数设置

%选择图像
imagename='1.jpg';
%读取源图像
imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
figure,imshow(imageres,[0 255]);

%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);

imagedes(:,:,1)=histeq(imageres(:,:,1));
imagedes(:,:,2)=histeq(imageres(:,:,2));
imagedes(:,:,3)=histeq(imageres(:,:,3));
imagedes=uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'globalhis-1.jpg');