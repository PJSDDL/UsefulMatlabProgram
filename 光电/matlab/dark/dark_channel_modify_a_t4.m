close all
clear all
clc

%窗口长度
window_size=7;

%雾的去除度
w=0.95;

%选择图像
imagename='1.jpg';

%读取源图像
imageres=imread(['F:\XY\master_thesis\testimage\test',imagename]);
figure,imshow(imageres,[0 255]);

%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);

%求取暗通道数据
for i=1:1:(imageres_heigth-window_size+1)
    for j=1:1:(imageres_length-window_size+1)
        minimageres(1)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),1),window_size*window_size,1));
        minimageres(2)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),2),window_size*window_size,1));
        minimageres(3)=min(reshape(imageres(i:(window_size+i-1),j:(window_size+j-1),3),window_size*window_size,1));
        imagedark(i+floor(window_size/2),j+floor(window_size/2))=min(minimageres);
    end
end
figure,imshow(imagedark,[0 255]);
clear minimageres;

%添加四边
for i=1:1:(floor(window_size/2))
    imagedark(i,:)=imagedark(floor(window_size/2)+1,:);
    imagedark(imageres_heigth-i+1,:)=imagedark(imageres_heigth-floor(window_size/2),:);
end
for i=1:1:(floor(window_size/2))
    imagedark(:,i)=imagedark(:,floor(window_size/2)+1);
    imagedark(:,imageres_length-i+1)=imagedark(:,imageres_length-floor(window_size/2));
end

%求取大气光值
[imagedarksort,imagedarkindex]=max(imagedark);

%分离三个通道并
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

%求透射率，和大气光照无特别大的关系，小于0.1的需要特殊处理，有好多位置出现溢出的问题
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
image_tran_estimate(image_tran_estimate<0.1)=0.1;
figure,imshow(image_tran_estimate,[0 1]);

%改进透射率，形态学滤波
%se = strel('square',floor(window_size/2));
%image_tran_estimate=uint8(round(image_tran_estimate*255));
%image_tran_estimate = imerode(image_tran_estimate,se);
%image_tran_estimate = medfilt2(image_tran_estimate,[20,20]); 
%figure(2);
%imshow(image_tran_estimate,[0 255]);
%image_tran_estimate=double(image_tran_estimate)/255;

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r/255),image_tran_estimate,20,0.0001);  
figure,imshow(image_tran_estimate,[0 1]);

%求无雾图像
%imagedes_r = (imageres_r-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);
%imagedes_g = (imageres_g-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);
%imagedes_b = (imageres_b-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);

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

%clear imagedes_r imagedes_g imagedes_b;

imwrite(uint8(imagedes),['resultam',imagename]);
figure,imshow(uint8(imagedes),[0 255]);

%进行亮度调整,使用杨晓莉的算法，可以在进行修改（有的时候太亮）,原作者是使用RGB的均值，我是用V（亮度）通道
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



