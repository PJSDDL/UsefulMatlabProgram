%% MSR
close all
clear all
clc

%% 图像输入及参数设置
%选择图像
imagename='7.jpg';
%读取源图像
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread('test.jpg');
figure,imshow(imageres,[0 255]);
imageres = double(imageres);

%构造高斯核
sigmal1 = 30;
sigmal2 = 60;
sigmal3 = 120;
g_filter_window1 = fspecial('gaussian',[sigmal1,sigmal1],sigmal1/3);
g_filter_window2 = fspecial('gaussian',[sigmal2,sigmal2],sigmal2/3);
g_filter_window3 = fspecial('gaussian',[sigmal3,sigmal3],sigmal3/3);

%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);

%% 处理

for imagechannel=1:1:3
    
    imagedes_temp = zeros(height,length);
    
    temp = imfilter(imageres(:,:,imagechannel),g_filter_window1,'conv','replicate');
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    temp = imfilter(imageres(:,:,imagechannel),g_filter_window2,'conv','replicate');
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    temp = imfilter(imageres(:,:,imagechannel),g_filter_window3,'conv','replicate');
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    imagemin = min(min(imagedes_temp));
    imagemax = max(max(imagedes_temp));
    imagedes(:,:,imagechannel) = (imagedes_temp-imagemin)*255/(imagemax-imagemin);
    
end

imagedes = uint8(imagedes);
figure,imshow(imagedes,[0 255]);

imagedes(:,:,1) = adapthisteq(imagedes(:,:,1));
imagedes(:,:,2) = adapthisteq(imagedes(:,:,2));
imagedes(:,:,3) = adapthisteq(imagedes(:,:,3));

%% 输出
figure,imshow(imagedes,[0 255]);
