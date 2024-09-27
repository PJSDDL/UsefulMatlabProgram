clear all;
close all;


%ѡ��ͼ��
imagename='3.bmp';

%��ȡԴͼ��
image_res_rgb=imread(['E:/test3/test',imagename]);
figure,imshow(image_res_rgb,'border','tight','initialmagnification','fit');axis normal;
image_res_rgb = double(image_res_rgb);

%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(image_res_rgb(:,:,1));

image_bayer_rggb = double(zeros(imageres_heigth,imageres_length));                                                      %����rggb��bayerͼ��
image_turnback = double(zeros(imageres_heigth,imageres_length,3));    

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%����ԭͼ����RGGB��ʽ���BAYERͼ��
for i = 1:2:imageres_heigth                                                                                                                   %�����еĺ�ɫ��ֵ
    for j = 1:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,1);
        image_turnback(i,j,1) = image_res_rgb(i,j,1);
    end
end

for i = 2:2:imageres_heigth                                                                                                                   %�����е���ɫ��ֵ
    for j = 2:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,3);
        image_turnback(i,j,3) = image_res_rgb(i,j,3);
    end
end

for i = 1:2:imageres_heigth                                                                                                                   %�����е���ɫ��ֵ
    for j = 2:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,2);
        image_turnback(i,j,2) = image_res_rgb(i,j,2);
    end
end

for i = 2:2:imageres_heigth
    for j = 1:2:imageres_length
        image_bayer_rggb(i,j) = image_res_rgb(i,j,2);
        image_turnback(i,j,2) = image_res_rgb(i,j,2);
    end
end

figure,imshow(uint8(round(image_bayer_rggb)),[0,255],'border','tight','initialmagnification','fit');axis normal;      %����bayerͼ��
%imwrite(uint8(round(image_bayer_rggb)),'3_1.bmp','bmp');
image_bayer_rggb = double(image_bayer_rggb);

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

figure,imshow(uint8(round(image_turnback)),[0,255],'border','tight','initialmagnification','fit');axis normal;      %�����ָ����ȫ��ͼ��

% A_1 = image_turnback(:,:,1);
% A_2 = image_turnback(:,:,2);
% A_3 = image_turnback(:,:,3);
% B_1 = image_res_rgb(:,:,1);
% B_2 = image_res_rgb(:,:,2);
% B_3 = image_res_rgb(:,:,3);
% 
% A_d = A_1 - B_1;
% B_d = A_2 - B_2;
% C_d = A_3 - B_3;
% MES = 0;
% for i = 2 : imageres_heigth-1    
%     for j = 2 : imageres_length-1
%         MES = (image_turnback(i,j,1) -  image_res_rgb(i,j,1))^2 + (image_turnback(i,j,2) -  image_res_rgb(i,j,2))^2 + (image_turnback(i,j,3) -  image_res_rgb(i,j,3))^2 + MES;
%     end
% end
% MES = MES/(3*(imageres_heigth-1)*(imageres_length-1));
% PSNR = 10*log(255^2/round(MES));






