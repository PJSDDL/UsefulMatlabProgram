function image_turnback = bayer2rgb_3block(image_bayer_rggb)

[imageres_heigth,imageres_length]=size(image_bayer_rggb);

image_turnback = double(zeros(imageres_heigth,imageres_length,3));   

%����3*3�������˫���Բ�ֵ
for i = 3:2:imageres_heigth-1                                                                                                                   %�����еĺ�ɫ���в�ֵ
    for j = 3:2:imageres_length-1
        image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) + image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) )/4;               %�ָ���ɫ��ֵ
        image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) )/4;               %�ָ���ɫ��ֵ
    end
end

for i = 2:2:imageres_heigth-1                                                                                                                   %�����е���ɫ���в�ֵ
    for j = 2:2:imageres_length-1
        image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) + image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) )/4;               %�ָ���ɫ��ֵ
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) )/4;               %�ָ���ɫ��ֵ
    end
end

for i = 3:2:imageres_heigth-1                                                                                                                   %�����е���ɫ���в�ֵ
    for j = 2:2:imageres_length-1
         image_turnback(i,j,1) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;       %�ָ���ɫ��ֵ
         image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;       %�ָ���ɫ��ֵ
    end
end

for i = 2:2:imageres_heigth-1
    for j = 3:2:imageres_length-1
         image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;       %�ָ���ɫ��ֵ
         image_turnback(i,j,3) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;       %�ָ���ɫ��ֵ
    end
end

figure,imshow(uint8(round(image_turnback)),[0,255]);     %�����ָ����ȫ��ͼ��