%% ����Ӧֱ��ͼ����
%close all
clear all
clc

%% ͼ�����뼰��������

%ѡ��ͼ��
imagename='4.jpg';
%��ȡԴͼ��
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
%imageres = imread('test.png');
%figure,imshow(imageres,[0 255]);

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����
imagedes(:,:,1)=adapthisteq(imageres(:,:,1));
imagedes(:,:,2)=adapthisteq(imageres(:,:,2));
imagedes(:,:,3)=adapthisteq(imageres(:,:,3));


%% ���
imagedes=uint8(imagedes);
figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');