%% SSR
close all
clear all
clc

%% ͼ�����뼰��������
%ѡ��ͼ��
imagename='1.jpg';
%��ȡԴͼ��
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread('msrretnx.bmp');
figure,imshow(imageres,[0 255]);
imageres = double(imageres);
%�����˹��

sigmal =30;

g_filter_window = fspecial('gaussian',[sigmal,sigmal],round(sigmal/3));

%r = 80;
%window_size = 2*r+1;
%g_filter_window = fspecial('gaussian',5,1.2);

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����

for imagechannel=1:1:3
    imagedes_temp = imfilter(imageres(:,:,imagechannel),g_filter_window,'conv','replicate');
    imagedes_temp = log(imageres(:,:,imagechannel)+1) - log(imagedes_temp+1);
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
