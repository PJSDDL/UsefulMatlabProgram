close all
clear all
clc

%%
%�������ã����ڳ��ȣ����ȥ����
window_size=8;
w=0.95;

%%
%ѡ��ͼ�񣬶�ȡԴͼ����ʾ
imagename='1.jpg';
imageres = imread(['F:\XY\master_thesis\speedtestimage\mytest',imagename]);
imagegray = rgb2gray(imageres);
[imageres_heigth,imageres_length]=size(imageres(:,:,1));
figure,imshow(imageres,[0 255]);

%%
%��Ե��⣬����canny����  
imageedge = edge(imagegray,'canny'); 
figure,imshow(imageedge,[0 1]);

%%
%��ȡ��ͨ��ͼ��
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
%��ȡ������ֵ
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
%��͸���ʣ��ʹ����������ر��Ĺ�ϵ��С��0.1����Ҫ���⴦���кö�λ�ó������������
image_tran_estimate=1-w*imagedark/max(atmo_light_value);
atmo_light_max = max(atmo_light_value);

%�����˲�ϸ��͸����,����ѡ���ûҶȣ�������RGB�е�ĳһ��
image_gary = rgb2gray(imageres);
image_gary = double(image_gary)/255;
image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
image_tran_estimate=image_tran_estimate/255;
image_tran_estimate(image_tran_estimate<0.1)=0.1;
image_tran_estimate(image_tran_estimate>1)=1;

%%
%�Ż�������ֵ�������������д�����ֵ���Ż�

%�ж���������Ƿ���ڣ������趨��������ķ�Χ1/5�����͸���ʷ�Χ�ͱ�����Ϣ�ķ�ʽ
%���趨��������͸���ʷ�Χ�ܵ���ɫ�����Ӱ��
index = image_tran_estimate<=0.1;
index(round(imageres_heigth/5):imageres_heigth,:) = 0;
sky_area = sum(sum(index));
edge_num = sum(imageedge(index));
sky_para_edge = edge_num/sky_area;
sky_para_area = (sky_area*5)/(imageres_heigth*imageres_length);

%sky_para_edge�ӽ���Ϊ�������,sky_para_area�ӽ��㲻�������
%1��ʾ����գ�0��ʾû�����
if (sky_para_edge > 0.01 || sky_para_area < 0.1)
    sky_state = 0;
else
    sky_state = 1;
end

if sky_state == 1
    
    %��ʼ��������ֵ����
    atmo_light_value = ones(imageres_heigth,imageres_length)*atmo_light_max;
    %atmo_light_value(image_tran_estimate>=0.5) = atmo_light_max;
    
    %ѡ����ʵ��Ż�λ��
    %�������Ŀɱ��������Ҫ����30
    res = zeros(7,41);
    cnt=0;
    range_loc_flag=0;
    range_loc=0;
    for i=0.1:0.01:0.5
        cnt=cnt+1;
        index = image_tran_estimate<=i;
        %͸���ʷ�Χ���ã����ڼ�¼͸���ʵı߽�
        res(1,cnt) = i;
        %͸��������Ĵ�С
        res(2,cnt) = sum(sum(index));
        %͸��������Χ�ڵı�Ե������������������imageres_length+imageres_heigthʱ��������Ϣ���Ѿ�û��ʲô������
        res(3,cnt) = sum(imageedge(index));
        if( res(3,cnt) > (imageres_length+imageres_heigth) )
            %res(3,cnt) = (imageres_length+imageres_heigth);
            if(range_loc_flag==0)
                range_loc_flag=1;
                range_loc=cnt;
            end
        end
    end
    
    %������
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
    %��ԭͼ��
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
    
    %% ���ȴ���
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
    %�������ȵ���,ʹ����������㷨�������ڽ����޸ģ��е�ʱ��̫����,ԭ������ʹ��RGB�ľ�ֵ��������V�����ȣ�ͨ��
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