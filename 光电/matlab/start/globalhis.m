%% 全局直方图均衡
close all
clear all
clc
%% 图像输入及参数设置

%选择图像
imagename='10.jpg';

%读取源图像
%imagein=imread('F:\XY\master_thesis\speedtestimage\test17.jpg');
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
%{
for i=1:1:3
    temp1 = reshape(imagein(:,:,i),1,1024*768);
    %temp1 = reshape(temp1,1024,768);
    imageres(:,:,i) = temp1;
end
%imageres = imageres(1:100,:,:);
figure,imshow(imageres,[0 255]);
%}
%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);

imagedes(:,:,1)=histeq(imageres(:,:,1));
imagedes(:,:,2)=histeq(imageres(:,:,2));
imagedes(:,:,3)=histeq(imageres(:,:,3));
imagedes=uint8(imagedes);


for i=1:1:3
    temp1 = reshape(imagedes(:,:,i),1,1024*768);
    temp1 = reshape(temp1,768,1024);
    imageout(:,:,i) = temp1;
end
figure,imshow(imageout,[0 255]);

