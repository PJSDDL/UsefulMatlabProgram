%% ȫ��ֱ��ͼ����
close all
clear all
clc
%% ͼ�����뼰��������

%ѡ��ͼ��
imagename='1.jpg';
%��ȡԴͼ��
imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
figure,imshow(imageres,[0 255]);

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);

imagedes(:,:,1)=histeq(imageres(:,:,1));
imagedes(:,:,2)=histeq(imageres(:,:,2));
imagedes(:,:,3)=histeq(imageres(:,:,3));
imagedes=uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'globalhis-1.jpg');