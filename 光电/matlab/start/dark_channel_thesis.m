close all
clear all
clc

%窗口长度
window_size=8;

%雾的去除度
w=0.95;

%选择图像
imagename='1.jpg';

%读取源图像
%imageres=imread('F:\XY\master_thesis\speedtestimage\test17.jpg');
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
imagegray = rgb2gray(imageres);

figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);
tic
%求取暗通道数据
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
toc
%figure,imshow(imagedark,[0 255]);
clear minimageres;

%求取大气光值
[imagedarksort,imagedarkindex]=max(imagedark);
tic
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
toc
%求透射率，和大气光照无特别大的关系，小于0.1的需要特殊处理，有好多位置出现溢出的问题

image_tran_estimate=1-w*imagedark/max(atmo_light_value);

%figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;

image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;

image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;


%image_index_low = (image_tran_estimate <= 0.5);
image_index_high = (image_tran_estimate < 0.5);
figure,imshow(image_index_high,[0 1]);
se1 = strel('square',5);
se2 = strel('square',10);
image_index_high = imerode(image_index_high,se1);
image_index_high = imdilate(image_index_high,se2);
image_index_high = imerode(image_index_high,se1);

image_index_high = imfill(image_index_high,'holes');
image_index_high = ~image_index_high;
image_index_high = imfill(image_index_high,'holes');
image_index_high = ~image_index_high;
figure,imshow(image_index_high,[0 1]);

sky_aera = sum(sum(image_index_high));
sky_aera =sky_aera/(imageres_heigth*imageres_length)
for i=1:1:3
    temp1 = imageres(:,:,i);
    temp2 = temp1(image_index_high);
    index_end = length(temp2);
    temp2 = cat(1,temp2,zeros(round(length(temp2)/10),1),255*ones(round(length(temp2)/10),1));
    %temp2 = cat(1,temp2,255*ones(round(length(temp2)/10),1));
    imagehis(:,:,i) = histeq(temp2); 
end
imagehis=imagehis(1:index_end,:,:);
%%
image_tran_estimate(image_tran_estimate<0.5) = 1 - image_tran_estimate(image_tran_estimate<0.5);
%figure,imshow(image_tran_estimate,[0 1]);

%求无雾图像
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
imagedes_r = uint8(imagedes_r);
imagedes_g = uint8(imagedes_g);
imagedes_b = uint8(imagedes_b);
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;


%clear imagedes_r imagedes_g imagedes_b;

%imwrite(imagedes,['image_fm',imagename]);
%imwrite(imagedes,['compare-darkmodify-',imagename]);
figure,imshow(imagedes,[0 255]);

imagedes_r(image_index_high) = imagehis(:,:,1);
imagedes_g(image_index_high)=imagehis(:,:,2);
imagedes_b(image_index_high)=imagehis(:,:,3);
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
figure,imshow(imagedes,[0 255]);
imwrite(image_index_high,'filltest.bmp');
%imwrite(imagedes,'enhanceres3.bmp');

%atmo_light_value(image_tran_estimate<0.5) = atmo_light_min-20;
%image_tran_temp = sqrt(1-image_tran_temp.^2);
%atmo_light_value(image_tran_estimate<0.5) = atmo_light_max;
%atmo_light_value(image_tran_estimate<0.5) = round((atmo_light_max-atmo_light_min)*image_tran_estimate(image_tran_estimate<0.5)/0.4 + (5*atmo_light_min-atmo_light_max)/4);
%image_tran_estimate(image_tran_estimate<0.5) = 1 - image_tran_estimate(image_tran_estimate<0.5);
