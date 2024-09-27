%% 自适应直方图均衡
%close all
clear all
clc

%% 图像输入及参数设置

%选择图像
imagename='4.jpg';
%读取源图像
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
%imageres = imread('test.png');
%figure,imshow(imageres,[0 255]);

%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);

%% 处理
imagedes(:,:,1)=adapthisteq(imageres(:,:,1));
imagedes(:,:,2)=adapthisteq(imageres(:,:,2));
imagedes(:,:,3)=adapthisteq(imageres(:,:,3));


%% 输出
imagedes=uint8(imagedes);
figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');