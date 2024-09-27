%% MSRCR
close all
clear all
clc

%% ͼ�����뼰��������
%ѡ��ͼ��
imagename='9.jpg';
%��ȡԴͼ��
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread('test.png');
figure,imshow(imageres,[0 255]);
imageres = double(imageres);

%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));

%�����˹��
recover_coe= 125;
sigma1 = 60;
sigma2 = 120;
sigma3 = 240;
g_filter_window1 = fspecial('gaussian', [height,length], sigma1);
g_filter_window2 = fspecial('gaussian', [height,length], sigma2);
g_filter_window3 = fspecial('gaussian', [height,length], sigma3);
g_filter_window1 = fft2(g_filter_window1);
g_filter_window2 = fft2(g_filter_window2);
g_filter_window3 = fft2(g_filter_window3);

%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����

for imagechannel=1:1:3
    
    imagedes_temp = zeros(height,length);
    
    temp = fft2(imageres(:,:,imagechannel));
    temp = g_filter_window1.*temp;
    temp = ifft2(temp);
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    temp = fft2(imageres(:,:,imagechannel));
    temp = g_filter_window2.*temp;
    temp = ifft2(temp);
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    temp = fft2(imageres(:,:,imagechannel));
    temp = g_filter_window3.*temp;
    temp = ifft2(temp);
    temp = log(imageres(:,:,imagechannel)+1) - log(temp+1);
    imagedes_temp = imagedes_temp + temp;
    
    imagedes_temp = imagedes_temp/3;
    color_recover_c = log(1 + recover_coe*imageres(:,:,imagechannel)./(imageres(:,:,1)+imageres(:,:,2)+imageres(:,:,3)));
    imagedes_temp = imagedes_temp.*color_recover_c;
    
    imagedes_temp = exp(imagedes_temp);
    
    imagemin = min(min(imagedes_temp));
    imagemax = max(max(imagedes_temp));
    imagedes(:,:,imagechannel) = (imagedes_temp-imagemin)*255/(imagemax-imagemin);
end


%% ���
imagedes = uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'MSRCR.jpg');
imagedes(:,:,1) = adapthisteq(imagedes(:,:,1));
imagedes(:,:,2) = adapthisteq(imagedes(:,:,2));
imagedes(:,:,3) = adapthisteq(imagedes(:,:,3));

%% ���
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'MSRCR-CLANE.jpg');
imagedes = uint8(imageres);
imagedes(:,:,1) = adapthisteq(imagedes(:,:,1));
imagedes(:,:,2) = adapthisteq(imagedes(:,:,2));
imagedes(:,:,3) = adapthisteq(imagedes(:,:,3));

%% ���
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'CLANE.jpg');


