close all
clear all
clc

%���ڳ���
window_size=5;

%���ȥ����
w=0.95;

%ѡ��ͼ��
imagename='test1.bmp';
tic
%��ȡԴͼ��
%imageres=imread('test1.jpg');
imageres = imread(['F:\XY\master_thesis\matlab\start\',imagename]);
figure,imshow(imageres,[0 255]);

%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%��ͨ��ͼ��
Imin= min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1));
imagedark = double(imagedark);

%��ȡ������ֵ
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

%��������ͨ��
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%��͸����
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
%figure,imshow(image_tran_estimate,[0 1]);

%�����˲�,����ѡ���ûҶȣ�������RGB�е�ĳһ��
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate,2*(window_size-1),0.0001);  
%image_tran_estimate(image_tran_estimate<0.1)=0.1;
%image_tran_estimate(image_tran_estimate>1)=1;
image_tran_estimate(image_tran_estimate<0.5) = 1 - image_tran_estimate(image_tran_estimate<0.5);
%figure,imshow(image_tran_estimate,[0 1]);

%������ͼ��
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
display(['��Ϣ��: ',num2str(info_entropy)]);
quality_assessment(imageres);

r = 64;
eps = 0.1^2;
imagedes_enhance = guidef_enhance(double(imagedes)/255,r,eps);
imagedes_enhance = uint8(imagedes_enhance*255);
%}
%imwrite(imagedes_enhance,['image_fenhance',imagename]);
%figure,imshow(imagedes_enhance,[0 255]);
%{
�������ȵ���,ʹ����������㷨�������ڽ����޸ģ��е�ʱ��̫����,ԭ������ʹ��RGB�ľ�ֵ��������V�����ȣ�ͨ��
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


