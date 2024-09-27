close all
clear all
clc

%窗口长度
window_size=8;

%雾的去除度
w=0.95;

mov = VideoReader('F:\XY\master_thesis\video\test.avi');
numFrames = mov.NumberOfFrames;

for k = 1:1:numFrames
    imageres = read(mov,k);
    tic
    [imageres_heigth,imageres_length]=size(imageres(:,:,1));
    
    Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
    imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab自带的最小值滤波
    imagedark = double(imagedark);
    
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
    
    image_tran_estimate=1-w*imagedark/max(atmo_light_value);
    image_tran_estimate = guidedfilter((imageres_r),image_tran_estimate*255,10,0.0001);  
    image_tran_estimate = image_tran_estimate/255;
    image_tran_estimate(image_tran_estimate<0.1)=0.1;
    image_tran_estimate(image_tran_estimate>1)=1;
    imagedes_r = (imageres_r-atmo_light_value(1))./image_tran_estimate + atmo_light_value(1);
    imagedes_g = (imageres_g-atmo_light_value(2))./image_tran_estimate + atmo_light_value(2);
    imagedes_b = (imageres_b-atmo_light_value(3))./image_tran_estimate + atmo_light_value(3);

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
    toc
    imshow(imagedes,[0 255]);   
    
end


