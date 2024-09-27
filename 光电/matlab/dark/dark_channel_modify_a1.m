%% �Ľ�͸���ʣ�ʹ����̬ѧ�˲�
close all
clear all
clc

%���ڰ뾶
window_size=7;

%���ȥ����
w=0.95;

%ѡ��ͼ��
imagename='2.jpg';
tic
%��ȡԴͼ��
%imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres=imread('test.jpg');
figure,imshow(imageres,[0 255]);
%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%��ȡ��ͨ������
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%��ͨ��ͼ��
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab�Դ�����Сֵ�˲�
imagedark = double(imagedark);

%figure,imshow(imagedark,[0 255]);
%imwrite(uint8(imagedark),'imagedark.jpg');
clear minimageres;

%��ȡ������ֵ
image_A = reshape(imagedark,imageres_length*imageres_heigth,1);
image_A = sort(image_A,'descend');
image_A = image_A(1:round(imageres_length*imageres_heigth*0.001));
atmo_light_value = round(mean(image_A));

%��������ͨ����
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%��͸���ʣ��ʹ����������ر��Ĺ�ϵ
image_tran_estimate=1-w*imagedark/atmo_light_value;
image_tran_estimate(image_tran_estimate<0.1)=0.1;
figure,imshow(image_tran_estimate,[0 1]);
imwrite(image_tran_estimate,'image_tran_estimate1_no.jpg');

%�Ľ�͸���ʣ���̬ѧ�˲�
se = strel('ball',window_size);%disk(Բ),diamond�����Σ�,ball����,square�������Σ�
image_tran_estimate=uint8(round(image_tran_estimate*255));
image_tran_estimate = imerode(image_tran_estimate,se);
%image_tran_estimate = medfilt2(image_tran_estimate,[20,20]); 
%figure(2);
%imshow(image_tran_estimate,[0 255]);
image_tran_estimate=double(image_tran_estimate)/255;

%������ͼ��
imagedes_r = (imageres_r-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_g = (imageres_g-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_b = (imageres_b-atmo_light_value)./image_tran_estimate + atmo_light_value;
imagedes_r(imagedes_r>255)=255;
imagedes_g(imagedes_g>255)=255;
imagedes_b(imagedes_b>255)=255;
imagedes_r(imagedes_r<0)=0;
imagedes_g(imagedes_g<0)=0;
imagedes_b(imagedes_b<0)=0;
imagedes_r=round(imagedes_r);
imagedes_g=round(imagedes_g);
imagedes_b=round(imagedes_b);

imagedes(:,:,1)=uint8(imagedes_r);
imagedes(:,:,2)=uint8(imagedes_g);
imagedes(:,:,3)=uint8(imagedes_b);

toc

imwrite(image_tran_estimate,'image_tran_estimate1_mor_ball.jpg');
imwrite(imagedes,'imagedes1_mor_ball.jpg');
figure,imshow(imagedes,[0 255]);

%% ����
%imagedes(:,:,1)=adapthisteq(imagedes(:,:,1));
%imagedes(:,:,2)=adapthisteq(imagedes(:,:,2));
%imagedes(:,:,3)=adapthisteq(imagedes(:,:,3));
%figure,imshow(imagedes,[0 255]);

%% ���
%imagedes=uint8(imagedes);
%figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'adapterhis-1.jpg');
