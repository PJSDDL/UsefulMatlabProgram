close all
clear all
clc

%%
%参数设置，窗口长度，雾的去除度
window_size=8;
w=0.95;

%%
%选择图像，读取源图像并显示
imagename='1.jpg';
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
imagegray = rgb2gray(imageres);
[imageres_heigth,imageres_length]=size(imageres(:,:,1));
figure,imshow(imageres,[0 255]);

%%
%边缘检测，调用canny函数  
imageedge = edge(imagegray,'canny'); 
figure,imshow(imageedge,[0 1]);

%%
%求取暗通道图像
imagedark=zeros(imageres_heigth,imageres_length);
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
    end
end
clear minimageres;
%figure,imshow(imagedark,[0 255]);

%%
%求取大气光值
[imagedarksort,imagedarkindex]=max(imagedark);
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

%%
%求透射率，和大气光照无特别大的关系，小于0.1的需要特殊处理，有好多位置出现溢出的问题
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
atmo_light_max = max(atmo_light_value);

%导向滤波细化透射率,可以选择用灰度，还是用RGB中的某一个
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;
image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;

%%
%优化大气光值，有天空区域进行大气光值的优化

%判断天空区域是否存在，采用设定顶部区域的范围1/5，结合透射率范围和边沿信息的方式
%不设定顶部区域，透射率范围受到白色物体的影响
index = image_tran_estimate<=0.1;
index(round(imageres_heigth/5):imageres_heigth,:) = 0;
sky_area = sum(sum(index));
edge_num = sum(imageedge(index));
sky_para_edge = edge_num/sky_area;
sky_para_area = (sky_area*5)/(imageres_heigth*imageres_length);

%sky_para_edge接近零为存在天空,sky_para_area接近零不存在天空
%1表示有天空，0表示没有天空
if (sky_para_edge > 0.01 || sky_para_area < 0.1)
    sky_state = 0;
else
    sky_state = 1;
end

if sky_state == 1
    
    %初始化大气光值矩阵
    atmo_light_value = ones(imageres_heigth,imageres_length)*atmo_light_max;
    %atmo_light_value(image_tran_estimate>=0.5) = atmo_light_max;
    
    %选择合适的优化位置
    %这个里面的可变参数很重要，即30
    res = zeros(7,41);
    cnt=0;
    range_loc_flag=0;
    range_loc=0;
    for i=0.1:0.01:0.5
        cnt=cnt+1;
        index = image_tran_estimate<=i;
        %透射率范围设置，用于记录透射率的边界
        res(1,cnt) = i;
        %透射率区域的大小
        res(2,cnt) = sum(sum(index));
        %透射率区域范围内的边缘数量，边沿数量大于imageres_length+imageres_heigth时的数据信息就已经没有什么意义了
        res(3,cnt) = sum(imageedge(index));
        if( res(3,cnt) > (imageres_length+imageres_heigth) )
            %res(3,cnt) = (imageres_length+imageres_heigth);
            if(range_loc_flag==0)
                range_loc_flag=1;
                range_loc=cnt;
            end
        end
    end
    
    %求增量
    res(4,1:(length(res)-1)) = res(2,2:length(res)) -  res(2,1:(length(res)-1));
    res(4,length(res)) = 1;
    res(5,1:(length(res)-1)) = res(3,2:length(res)) -  res(3,1:(length(res)-1));
    res(5,length(res)) = 0;
    
    [atmo_pks,atmo_loc]= findpeaks(res(5,1:range_loc));
    if(length(atmo_loc)~=0)
    
        image_tran_estimate_th = res(1,atmo_loc(length(atmo_loc)))+0.05;

        atmo_light_min = min(imagegray(image_tran_estimate<=image_tran_estimate_th));
        atmo_light_value(image_tran_estimate<=0.1) = atmo_light_min;
        for i=0.11:0.01:image_tran_estimate_th
            convert_x = (i - 0.1)/(image_tran_estimate_th - 0.1);
            convert_y = convert_x*convert_x;
            k = double(atmo_light_max-atmo_light_min);
            pro_result = k*convert_y + atmo_light_min;
            atmo_light_value(image_tran_estimate>(i-0.01) & image_tran_estimate<=i) = pro_result;
        end
    else
        image_tran_estimate_th = 0.1;
        atmo_light_min = min(imagegray(image_tran_estimate<=image_tran_estimate_th));
        atmo_light_value(image_tran_estimate<image_tran_estimate_th) = atmo_light_min;
    end
    %复原图像
    imagedes_r = (imageres_r-atmo_light_value)./image_tran_estimate + atmo_light_value;
    imagedes_g = (imageres_g-atmo_light_value)./image_tran_estimate + atmo_light_value;
    imagedes_b = (imageres_b-atmo_light_value)./image_tran_estimate + atmo_light_value;
    
    imagedes_r = uint8(imagedes_r);
    imagedes_g = uint8(imagedes_g);
    imagedes_b = uint8(imagedes_b);

    imagedes(:,:,1) = imagedes_r;
    imagedes(:,:,2) = imagedes_g;
    imagedes(:,:,3) = imagedes_b;
    figure,imshow(imagedes,[0 255]);
    
    %% 亮度处理
    imagedes_max = max(imagedes_r,imagedes_g);
    imagedes_max = max(imagedes_max,imagedes_b);
    imagedes_hist = zeros(1,25);
    for i=1:1:25
        imagedes_hist(1,i) = sum(sum(imagedes_max(imagedes_max>=(i-1)*10 & imagedes_max<i*10)));
    end
    
    imagedes_gray=rgb2gray(imagedes);
    imagedes_th1 = 200;

    %imagedes_r=(2-1*double(imagedes_r)/imagedes_th1).*double(imagedes_r)/1;
    %imagedes_g=(2-1*double(imagedes_g)/imagedes_th1).*double(imagedes_g)/1;
    %imagedes_b=(2-1*double(imagedes_b)/imagedes_th1).*double(imagedes_b)/1;
  
    imagedes_r(imagedes_gray<=imagedes_th1)=(2-1*double(imagedes_r(imagedes_gray<=imagedes_th1))/imagedes_th1).*double(imagedes_r(imagedes_gray<=imagedes_th1))/1;
    imagedes_g(imagedes_gray<=imagedes_th1)=(2-1*double(imagedes_g(imagedes_gray<=imagedes_th1))/imagedes_th1).*double(imagedes_g(imagedes_gray<=imagedes_th1))/1;
    imagedes_b(imagedes_gray<=imagedes_th1)=(2-1*double(imagedes_b(imagedes_gray<=imagedes_th1))/imagedes_th1).*double(imagedes_b(imagedes_gray<=imagedes_th1))/1;
    imagedes(:,:,1)=uint8(imagedes_r);
    imagedes(:,:,2)=uint8(imagedes_g);
    imagedes(:,:,3)=uint8(imagedes_b);
    
    %figure,plot(imagedes_hist);
    figure,imshow(imagedes,[0 255]);
    
else
    imagedes_r = (imageres_r-atmo_light_value(1))./image_tran_estimate + atmo_light_value(1);
    imagedes_g = (imageres_g-atmo_light_value(2))./image_tran_estimate + atmo_light_value(2);
    imagedes_b = (imageres_b-atmo_light_value(3))./image_tran_estimate + atmo_light_value(3);
    
    imagedes_r = uint8(imagedes_r);
    imagedes_g = uint8(imagedes_g);
    imagedes_b = uint8(imagedes_b);

    imagedes(:,:,1) = imagedes_r;
    imagedes(:,:,2) = imagedes_g;
    imagedes(:,:,3) = imagedes_b;
    figure,imshow(imagedes,[0 255]);
    
    %%
    %进行亮度调整,使用杨晓莉的算法，可以在进行修改（有的时候太亮）,原作者是使用RGB的均值，我是用V（亮度）通道
    a=rgb2hsv(imagedes);
    imagedes_avg=a(:,:,3);

    imagedes_r=(8-3*imagedes_avg).*imagedes_avg.*double(imagedes_r)/8+double(imagedes_r);
    imagedes_g=(8-3*imagedes_avg).*imagedes_avg.*double(imagedes_g)/8+double(imagedes_g);
    imagedes_b=(8-3*imagedes_avg).*imagedes_avg.*double(imagedes_b)/8+double(imagedes_b);
        
    imagedes(:,:,1)=uint8(imagedes_r);
    imagedes(:,:,2)=uint8(imagedes_g);
    imagedes(:,:,3)=uint8(imagedes_b);
    figure,imshow(uint8(round(imagedes)),[0 255]);
    
end


%{
a=rgb2hsv(imagedes);
imagedes_avg=a(:,:,3);
max(max(imagedes_avg))
min(min(imagedes_avg))
imagedes_avg=(2-imagedes_avg).*imagedes_avg;
a(:,:,3)=imagedes_avg;
imagedes=hsv2rgb(a);
figure,imshow(imagedes,[0 255]);

imagedes_r=(2-imagedes_r/255).*imagedes_r;
imagedes_g=(2-imagedes_g/255).*imagedes_g;
imagedes_b=(2-imagedes_b/255).*imagedes_b;
imagedes(:,:,1)=imagedes_r;
imagedes(:,:,2)=imagedes_g;
imagedes(:,:,3)=imagedes_b;
figure,imshow(uint8(round(imagedes)),[0 255]);
%}