%% SSR
close all
clear all
clc

%% ͼ�����뼰��������
%ѡ��ͼ��
imagename = '7.jpg';
%��ȡԴͼ��
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread('test.png');
figure,imshow(imageres,[0 255]);
imageres = double(imageres);

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));

%�����˹��
sigma = 60;
%sigma = 120;
%sigma = 240;
g_filter_window = fspecial('gaussian', [height,length], sigma);
g_filter_window = fft2(g_filter_window);

%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����

for imagechannel=1:1:3
    imagedes_temp = fft2(imageres(:,:,imagechannel));
    imagedes_temp = g_filter_window.*imagedes_temp;
    imagedes_temp = ifft2(imagedes_temp);
    imagedes_temp = exp(log(imageres(:,:,imagechannel)+1) - log(double(imagedes_temp)+1));
    imagemin = min(min(imagedes_temp));
    imagemax = max(max(imagedes_temp));
    imagedes(:,:,imagechannel) = (imagedes_temp-imagemin)*255/(imagemax-imagemin);
end

%% ���
imagedes = uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'SSR-60.jpg');
imagedes(:,:,1) = adapthisteq(imagedes(:,:,1));
imagedes(:,:,2) = adapthisteq(imagedes(:,:,2));
imagedes(:,:,3) = adapthisteq(imagedes(:,:,3));
figure,imshow(imagedes,[0 255]);


