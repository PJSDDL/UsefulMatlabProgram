%% MSRCR
close all
clear all
clc

%% ͼ�����뼰��������
%ѡ��ͼ��
imagename='1.jpg';
%��ȡԴͼ��
imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
%imageres = imread('msrretnx.bmp');
%imageres = imread('test3.jpg');
figure,imshow(imageres,[0 255]);
imageres = double(imageres);

%�����˹��
recover_coe= 125;
sigmal1 = 30;
sigmal2 = 60;
sigmal3 = 120;
g_filter_window1 = fspecial('gaussian',[sigmal1,sigmal1],round(sigmal1/3));
g_filter_window2 = fspecial('gaussian',[sigmal2,sigmal2],round(sigmal2/3));
g_filter_window3 = fspecial('gaussian',[sigmal3,sigmal3],round(sigmal3/3));

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����

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
    
    color_recover_c = log(1 + recover_coe.*(imageres(:,:,imagechannel)./(imageres(:,:,1)+imageres(:,:,2)+imageres(:,:,3))));

    imagedes_temp = imagedes_temp.*color_recover_c;
    
    imagemin = min(min(imagedes_temp));
    imagemax = max(max(imagedes_temp));
    imagedes(:,:,imagechannel) = (imagedes_temp-imagemin)*255/(imagemax-imagemin);
    
end

imagedes = uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imagedes(:,:,1) = adapthisteq(imagedes(:,:,1));
imagedes(:,:,2) = adapthisteq(imagedes(:,:,2));
imagedes(:,:,3) = adapthisteq(imagedes(:,:,3));

%% ���
figure,imshow(imagedes,[0 255]);

imageres = uint8(imageres);
imagedes(:,:,1) = adapthisteq(imageres(:,:,1));
imagedes(:,:,2) = adapthisteq(imageres(:,:,2));
imagedes(:,:,3) = adapthisteq(imageres(:,:,3));

%% ���
figure,imshow(imagedes,[0 255]);


