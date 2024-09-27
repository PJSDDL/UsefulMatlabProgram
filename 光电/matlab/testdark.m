close all
clear all
clc

%���ڳ���
window_size=7;

%���ȥ����
w=0.95;

%ѡ��ͼ��
imagename='10.jpg';

%��ȡԴͼ��
imageres=imread(['F:\XY\master_thesis\testimage\test',imagename]);
figure,imshow(imageres,[0 255]);

%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%��ͨ��ͼ��
imagedark=zeros(imageres_heigth,imageres_length);
imagelight=zeros(imageres_heigth,imageres_length);
%��ȡ��ͨ������
for i=1:1:(imageres_heigth-window_size+1)
    for j=1:1:(imageres_length-window_size+1)
        minimageres(1)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),1),window_size*window_size,1));
        minimageres(2)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),2),window_size*window_size,1));
        minimageres(3)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),3),window_size*window_size,1));
        imagedark(i+floor(window_size/2),j+floor(window_size/2))=min(minimageres);
        maximageres(1)=max(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),1),window_size*window_size,1));
        maximageres(2)=max(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),2),window_size*window_size,1));
        maximageres(3)=max(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),3),window_size*window_size,1));
        imagelight(i+floor(window_size/2),j+floor(window_size/2))=min(maximageres);
    end
end
figure,imshow(imagedark,[0 255]);
clear minimageres;

%����ı�
for i=1:1:(floor(window_size/2))
    imagedark(i,:)=imagedark(floor(window_size/2)+1,:);
    imagedark(imageres_heigth-i+1,:)=imagedark(imageres_heigth-floor(window_size/2),:);
    imagelight(i,:)=imagelight(floor(window_size/2)+1,:);
    imagelight(imageres_heigth-i+1,:)=imagelight(imageres_heigth-floor(window_size/2),:);
end
for i=1:1:(floor(window_size/2))
    imagedark(:,i)=imagedark(:,floor(window_size/2)+1);
    imagedark(:,imageres_length-i+1)=imagedark(:,imageres_length-floor(window_size/2));
    imagelight(i,:)=imagelight(floor(window_size/2)+1,:);
    imagelight(imageres_heigth-i+1,:)=imagelight(imageres_heigth-floor(window_size/2),:);
end

%��ȡ������ֵ
[imagedarksort,imagedarkindex]=max(imagedark);

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

%��͸���ʣ��ʹ����������ر��Ĺ�ϵ��С��0.1����Ҫ���⴦���кö�λ�ó������������
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
image_tran_estimate(image_tran_estimate<0.1)=0.1;
figure,imshow(image_tran_estimate,[0 1]);

%�����˲�,����ѡ���ûҶȣ�������RGB�е�ĳһ��
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate,20,0.0001);  
figure,imshow(image_tran_estimate,[0 1]);



