%% ȫ��ֱ��ͼ����
close all
clear all
clc
%% ͼ�����뼰��������

%ѡ��ͼ��
imagename='10.jpg';

%��ȡԴͼ��
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
%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
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

