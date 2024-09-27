%将每个窗分成一个像素点，加入了亮通道,效果不好
close all
clear all
clc

%窗口长度
window_size=8;

%雾的去除度
w=0.95;
%选择图像
imagename='10.jpg';

%读取源图像
imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
imagedark=zeros(imageres_heigth/window_size,imageres_length/window_size);

%求取暗通道数据
for i=1:1:(imageres_heigth/window_size)
    for j=1:1:(imageres_length/window_size)
        minimageres(1)=min(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),1),window_size*window_size,1));
        minimageres(2)=min(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),2),window_size*window_size,1));
        minimageres(3)=min(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),3),window_size*window_size,1));
        imagedark(i,j)=min(minimageres);
    end
end
temp=imagedark;
imagedark=zeros(imageres_heigth,imageres_length);
for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        imagedark(i,j)=temp(ceil(i/window_size),ceil(j/window_size));
    end
end
figure,imshow(imagedark,[0 255]);
imwrite(uint8(imagedark),'imagedark12.jpg');
%亮通道图像
window_size=4;
imagelight=zeros(imageres_heigth/window_size,imageres_length/window_size);
%求取亮通道数据
for i=1:1:(imageres_heigth/window_size)
    for j=1:1:(imageres_length/window_size)
        maximageres(1)=max(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),1),window_size*window_size,1));
        maximageres(2)=max(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),2),window_size*window_size,1));
        maximageres(3)=max(reshape(imageres((i*window_size-window_size+1):(i*window_size),(j*window_size-window_size+1):(j*window_size),3),window_size*window_size,1));
        imagelight(i,j)=min(maximageres);
    end
end
temp=imagelight;
imagelight=zeros(imageres_heigth,imageres_length);
for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        imagelight(i,j)=temp(ceil(i/window_size),ceil(j/window_size));
    end
end
figure,imshow(imagelight,[0 255]);
imwrite(uint8(imagelight),'imagelight12.jpg');
clear minimageres;
clear temp;

%求取大气光值
imagedark=reshape(imagedark,imageres_heigth*imageres_length,1);
[imagedarksort,imagedarkindex]=sort(imagedark,'descend');

%分离三个通道并
imageres_r=double(reshape(imageres(:,:,1),imageres_heigth*imageres_length,1));
imageres_g=double(reshape(imageres(:,:,2),imageres_heigth*imageres_length,1));
imageres_b=double(reshape(imageres(:,:,3),imageres_heigth*imageres_length,1));
atmo_light_value_r_temp=double(0);
atmo_light_value_g_temp=double(0);
atmo_light_value_b_temp=double(0);
for i=1:1:floor(imageres_heigth*imageres_length/1000)
    atmo_light_value_r_temp=atmo_light_value_r_temp+imageres_r(imagedarkindex(i));
    atmo_light_value_g_temp=atmo_light_value_g_temp+imageres_g(imagedarkindex(i));
    atmo_light_value_b_temp=atmo_light_value_b_temp+imageres_b(imagedarkindex(i));
end

atmo_light_value(1)=round(atmo_light_value_r_temp/floor(imageres_heigth*imageres_length/1000));
atmo_light_value(2)=round(atmo_light_value_g_temp/floor(imageres_heigth*imageres_length/1000));
atmo_light_value(3)=round(atmo_light_value_b_temp/floor(imageres_heigth*imageres_length/1000));

imagedark=reshape(imagedark,imageres_heigth,imageres_length);
imageres_r=reshape(imageres_r,imageres_heigth,imageres_length);
imageres_g=reshape(imageres_g,imageres_heigth,imageres_length);
imageres_b=reshape(imageres_b,imageres_heigth,imageres_length);


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
%imwrite(image_tran_estimate,'tran.jpg');
%filterwindow=fspecial('gaussian',[7 7]);
%image_tran_estimate=imfilter(image_tran_estimate,filterwindow,'conv','replicate');
%image_tran_estimate=medfilt2(image_tran_estimate,[3 3]);
%figure,imshow(image_tran_estimate,[0 1]);
%求无雾图像
%imagedes_r = (imageres_r-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);
%imagedes_g = (imageres_g-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);
%imagedes_b = (imageres_b-max(atmo_light_value))./image_tran_estimate + max(atmo_light_value);

imagedes_r = (imageres_r-atmo_light_value(1))./image_tran_estimate + atmo_light_value(1);
imagedes_g = (imageres_g-atmo_light_value(2))./image_tran_estimate + atmo_light_value(2);
imagedes_b = (imageres_b-atmo_light_value(3))./image_tran_estimate + atmo_light_value(3);

for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        if(image_tran_estimate(i,j)<0.2)
            imagedes_r(i,j) = max(atmo_light_value)*(1-image_tran_estimate(i,j));
            imagedes_g(i,j) = max(atmo_light_value)*(1-image_tran_estimate(i,j));
            imagedes_b(i,j) = max(atmo_light_value)*(1-image_tran_estimate(i,j));
        end
    end
end

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

%imwrite(uint8(imagedes),['resultam',imagename]);
figure,imshow(uint8(imagedes),[0 255]);

%利用亮通道处理透射率
temp=imagelight-imagedark;
for i=1:1:imageres_heigth
    for j=1:1:imageres_length
        if(temp(i,j)<5 && imagedark(i,j)>175)
            image_tran_estimate(i,j)=0.1;
        end
    end
end
figure,imshow(image_tran_estimate,[0 1]);
se = strel('square',floor(window_size-1));
image_tran_estimate = imopen(image_tran_estimate,se);
figure,imshow(image_tran_estimate,[0 1]);
imagedes_r(image_tran_estimate<0.2)=imageres_r(image_tran_estimate<0.2);
imagedes_g(image_tran_estimate<0.2)=imageres_g(image_tran_estimate<0.2);
imagedes_b(image_tran_estimate<0.2)=imageres_b(image_tran_estimate<0.2);
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
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
