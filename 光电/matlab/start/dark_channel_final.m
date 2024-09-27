close all
clear all
clc

%窗口长度
window_size=5;

%雾的去除度
w=0.95;

%选择图像
imagename='test1.bmp';
tic
%读取源图像
%imageres=imread('test1.jpg');
imageres = imread(['F:\XY\master_thesis\matlab\start\',imagename]);
figure,imshow(imageres,[0 255]);

%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
Imin= min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1));
imagedark = double(imagedark);

%求取大气光值
image_A = reshape(imageres(:,:,1),imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value(1) = round(mean(image_A));

image_A = reshape(imageres(:,:,2),imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value(2) = round(mean(image_A));

image_A = reshape(imageres(:,:,3),imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value(3) = round(mean(image_A));

%分离三个通道
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%求透射率
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
%figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate,2*(window_size-1),0.0001);  
%image_tran_estimate(image_tran_estimate<0.1)=0.1;
%image_tran_estimate(image_tran_estimate>1)=1;
image_tran_estimate(image_tran_estimate<0.5) = 1 - image_tran_estimate(image_tran_estimate<0.5);
%figure,imshow(image_tran_estimate,[0 1]);

%求无雾图像
imagedes_r = (imageres_r-atmo_light_value(1))./image_tran_estimate + atmo_light_value(1);
imagedes_g = (imageres_g-atmo_light_value(2))./image_tran_estimate + atmo_light_value(2);
imagedes_b = (imageres_b-atmo_light_value(3))./image_tran_estimate + atmo_light_value(3);

%clear imageres_r imageres_g imageres_b;
imagedes_r(imagedes_r>255)=255;
imagedes_g(imagedes_g>255)=255;
imagedes_b(imagedes_b>255)=255;
imagedes_r(imagedes_r<0)=0;
imagedes_g(imagedes_g<0)=0;
imagedes_b(imagedes_b<0)=0;
imagedes_r=round(imagedes_r);
imagedes_g=round(imagedes_g);
imagedes_b=round(imagedes_b);

imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
imagedes = uint8(imagedes);
%clear imagedes_r imagedes_g imagedes_b;
toc
%imwrite(imagedes,['image_f',imagename]);
imwrite(imagedes,['compare-dark-',imagename]);
figure,imshow(imagedes,[0 255]);
%{
info_entropy = ImgEntropy(imageres);
display(['信息熵: ',num2str(info_entropy)]);
quality_assessment(imageres);

r = 64;
eps = 0.1^2;
imagedes_enhance = guidef_enhance(double(imagedes)/255,r,eps);
imagedes_enhance = uint8(imagedes_enhance*255);
%}
%imwrite(imagedes_enhance,['image_fenhance',imagename]);
%figure,imshow(imagedes_enhance,[0 255]);
%{
进行亮度调整,使用杨晓莉的算法，可以在进行修改（有的时候太亮）,原作者是使用RGB的均值，我是用V（亮度）通道
imagedes_avg=zeros(imageres_heigth,imageres_length);
for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        imagedes_avg(i,j)=sum(imagedes(i,j,:))/3;
    end
end
a=rgb2hsv(imagedes);
imagedes_avg=a(:,:,3);
imagedes_r=(2-imagedes_avg/255).*imagedes_r;
imagedes_g=(2-imagedes_avg/255).*imagedes_g;
imagedes_b=(2-imagedes_avg/255).*imagedes_b;
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
figure,imshow(uint8(round(imagedes)),[0 255]);
%}


