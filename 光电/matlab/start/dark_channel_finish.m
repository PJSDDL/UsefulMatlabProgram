close all
clear all
clc

%窗口长度
window_size=8;

%雾的去除度
w=0.95;

%选择图像
imagename='2.jpg';

%读取源图像
%imageres=imread('test12.jpg');
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
imagegray = rgb2gray(imageres);

figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);
tic
%{
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
%}
%求取暗通道数据
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%暗通道图像
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab自带的最小值滤波
imagedark = double(imagedark);

toc
figure,imshow(imagedark,[0 255]);
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

figure,imshow(image_tran_estimate,[0 1]);

%导向滤波,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;

image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;

image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;


image_index1 = (image_tran_estimate > 0.5);
imshow(image_index1,[0 1]);

%{

image_index2 = (image_tran_estimate <= 0.2) & (image_tran_estimate > 0.1);
image_index3 = (image_tran_estimate <= 0.3) & (image_tran_estimate > 0.2);
image_index4 = (image_tran_estimate <= 0.5) & (image_tran_estimate > 0.3);

image_index = image_tran_estimate<0.1;

temp_r = double(imageres(:,:,1)).*double(image_index);
mean_temp = round(mean(mean(temp_r(image_index))));
max_temp = round(max(max(temp_r(image_index))));
min_temp = round(min(min(temp_r(image_index))));
figure,imshow(temp_r,[0 255]);
image_index_up = image_index & (temp_r>mean_temp);
image_index_down = image_index & (temp_r<=mean_temp);
temp_r(image_index_up) = max_temp;%mean_temp + (max_temp-mean_temp)*log((temp_r(image_index_up)-mean_temp)/(max_temp-mean_temp))/log(200);
temp_r(image_index_down) = min_temp-40 + (mean_temp-min_temp+40)*(((temp_r(image_index_down)-min_temp)/(mean_temp-min_temp)).^5);
figure,imshow(temp_r,[0 255]);
image_temp = zeros(imageres_heigth,imageres_length,3);
image_temp(:,:,1) = temp_r;
image_temp(:,:,2) = temp_r;
image_temp(:,:,3) = temp_r;
figure,imshow(uint8(image_temp),[0 1]);
%}
%%
image_tran_estimate(image_tran_estimate<0.5) = 1 - image_tran_estimate(image_tran_estimate<0.5);
figure,imshow(image_tran_estimate,[0 1]);

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
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;

imagedes = uint8(imagedes);
%clear imagedes_r imagedes_g imagedes_b;

%imwrite(imagedes,['image_fm',imagename]);
%imwrite(imagedes,['compare-darkmodify-',imagename]);
figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'enhanceres3.bmp');


%{
info_entropy = ImgEntropy(imagedes);
display(['信息熵: ',num2str(info_entropy)]);
quality_assessment(imagedes);
%}

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

%{
image_tran_temp(a) = 1;
figure,imshow(image_tran_temp,[0 1]);

image_tran_temp = zeros(imageres_heigth,imageres_length);
image_tran_temp(image_tran_estimate_temp<0.1) = 1;
figure,imshow(image_tran_temp,[0 1]);

image_tran_estimate_temp(image_tran_estimate<0.1)=0.2;
image_tran_temp = zeros(imageres_heigth,imageres_length);
image_tran_temp(image_tran_estimate_temp<0.2) = 1;
figure,imshow(image_tran_temp,[0 1]);

image_tran_estimate_temp(image_tran_estimate<0.2)=0.3;
image_tran_temp = zeros(imageres_heigth,imageres_length);
image_tran_temp(image_tran_estimate_temp<0.3) = 1;
figure,imshow(image_tran_temp,[0 1]);

image_tran_estimate_temp(image_tran_estimate<0.3)=0.4;
image_tran_temp = zeros(imageres_heigth,imageres_length);
image_tran_temp(image_tran_estimate_temp<0.4) = 1;
figure,imshow(image_tran_temp,[0 1]);

image_tran_estimate_temp(image_tran_estimate<0.4)=0.5;
image_tran_temp = zeros(imageres_heigth,imageres_length);
image_tran_temp(image_tran_estimate_temp<0.5) = 1;
figure,imshow(image_tran_temp,[0 1]);

%%

imagedown = zeros(imageres_heigth,imageres_length,3);
for i=1:1:3
    imageres_temp = double(imageres(:,:,i));
    imageres_temp1 = imageres_temp;
    image_tran_max = max(imageres_temp(image_tran_estimate<0.5));
    image_tran_min = min(imageres_temp(image_tran_estimate<0.5));
    max_min = image_tran_max - image_tran_min;
    imageres_temp1(image_tran_estimate<0.5) = (imageres_temp(image_tran_estimate<0.5)-image_tran_min).*(imageres_temp(image_tran_estimate<0.5)-image_tran_min)/image_tran_min+image_tran_min;
    imagedown(:,:,i) = imageres_temp1;
end
imagedown = uint8(imagedown);
figure,imshow(imagedown,[0 1]);
%}