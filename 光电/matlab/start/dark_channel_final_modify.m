close all
clear all
clc

%���ڳ���
window_size=8;

%���ȥ����
w=0.95;

%ѡ��ͼ��
imagename='6.jpg';

%��ȡԴͼ��
imageres = imread(['F:/XY/master_thesis/speedtestimage/mytest',imagename]);%'F:/XY/master_thesis/speedtestimage/speedtestlarge1.jpg');
%figure,imshow(imageres,[0 255]);

%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%��ͨ��ͼ��
imagedark=zeros(imageres_heigth,imageres_length);
tic

%��ȡ��ͨ������
for i=1:1:ceil(imageres_heigth/window_size)
    for j=1:1:ceil(imageres_length/window_size)
        x_min = (i-1)*window_size+1;
        x_max = min(x_min + window_size-1,imageres_heigth);
        y_min = (j-1)*window_size+1;
        y_max = min(y_min + window_size-1,imageres_length);
        minimageres(1)=min(reshape(imageres(x_min:x_max,y_min:y_max,1),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(2)=min(reshape(imageres(x_min:x_max,y_min:y_max,2),(x_max-x_min+1)*(y_max-y_min+1),1));
        minimageres(3)=min(reshape(imageres(x_min:x_max,y_min:y_max,3),(x_max-x_min+1)*(y_max-y_min+1),1));
        imagedark(x_min:x_max,y_min:y_max) = uint8(ones(x_max-x_min+1,y_max-y_min+1))*min(minimageres);
        %temp(i,j)=min(minimageres);
    end
end
%{
%��ȡ��ͨ������
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%��ͨ��ͼ��
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab�Դ�����Сֵ�˲�
imagedark = double(imagedark);
%}
toc
%figure,imshow(imagedark,[0 255]);
clear minimageres;

%��ȡ������ֵ
[imagedarksort,imagedarkindex]=max(imagedark);
tic
%��������ͨ����
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));
atmo_light_value_r_temp=double(0);
atmo_light_value_g_temp=double(0);
atmo_light_value_b_temp=double(0);
for i=1:1:imageres_length
    atmo_light_value_r_temp=atmo_light_value_r_temp+imageres_r(imagedarkindex(i),i);
    atmo_light_value_g_temp=atmo_light_value_g_temp+imageres_g(imagedarkindex(i),i);
    atmo_light_value_b_temp=atmo_light_value_b_temp+imageres_b(imagedarkindex(i),i);
end

atmo_light_value(1)=round(atmo_light_value_r_temp/imageres_length);
atmo_light_value(2)=round(atmo_light_value_g_temp/imageres_length);
atmo_light_value(3)=round(atmo_light_value_b_temp/imageres_length);
toc
%��͸���ʣ��ʹ����������ر��Ĺ�ϵ��С��0.1����Ҫ���⴦���кö�λ�ó������������
tic
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
toc
%figure,imshow(image_tran_estimate,[0 1]);
tic
%�����˲�,����ѡ���ûҶȣ�������RGB�е�ĳһ��
%image_gary = rgb2gray(imageres);
%image_gary = double(image_gary)/255;

image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate = image_tran_estimate/255;
%{
%�Ľ�͸���ʣ���̬ѧ�˲�
se = strel('disk',window_size);%disk(Բ),diamond�����Σ�,ball����,square�������Σ�
image_tran_estimate=uint8(round(image_tran_estimate*255));
image_tran_estimate = imerode(image_tran_estimate,se);
image_tran_estimate=double(image_tran_estimate)/255;
%}


image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;
image_tran_estimate(image_tran_estimate<0.4) = 0.4;
toc
%figure,imshow(image_tran_estimate,[0 1]);

%������ͼ��
tic
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
toc
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;

imagedes = uint8(imagedes);
%clear imagedes_r imagedes_g imagedes_b;

%imwrite(imagedes,['image_fm',imagename]);
%imwrite(imagedes,['compare-darkmodify-',imagename]);
figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,['F:\XY\����\imagedes-final-',imagename]);
%{
info_entropy = ImgEntropy(imagedes);
display(['��Ϣ��: ',num2str(info_entropy)]);
quality_assessment(imagedes);

r = 64;
eps = 0.1^2;
imagedes_enhance = guidef_enhance(double(imagedes)/255,r,eps);
imagedes_enhance = uint8(imagedes_enhance*255);

%imwrite(imagedes_enhance,['image_fmenhance',imagename]);
figure,imshow(imagedes_enhance,[0 255]);
%}
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