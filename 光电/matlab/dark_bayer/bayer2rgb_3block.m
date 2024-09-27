function image_turnback = bayer2rgb_3block(image_bayer_rggb)

[imageres_heigth,imageres_length]=size(image_bayer_rggb);

image_turnback = double(zeros(imageres_heigth,imageres_length,3));   

%利用3*3邻域进行双线性插值
for i = 3:2:imageres_heigth-1                                                                                                                   %给所有的红色进行插值
    for j = 3:2:imageres_length-1
        image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) + image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) )/4;               %恢复绿色插值
        image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) )/4;               %恢复蓝色插值
    end
end

for i = 2:2:imageres_heigth-1                                                                                                                   %给所有的蓝色进行插值
    for j = 2:2:imageres_length-1
        image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) + image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) )/4;               %恢复绿色插值
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) )/4;               %恢复红色插值
    end
end

for i = 3:2:imageres_heigth-1                                                                                                                   %给所有的绿色进行插值
    for j = 2:2:imageres_length-1
         image_turnback(i,j,1) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;       %恢复红色插值
         image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;       %恢复蓝色插值
    end
end

for i = 2:2:imageres_heigth-1
    for j = 3:2:imageres_length-1
         image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;       %恢复红色插值
         image_turnback(i,j,3) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;       %恢复蓝色插值
    end
end

figure,imshow(uint8(round(image_turnback)),[0,255]);     %画出恢复后的全彩图像