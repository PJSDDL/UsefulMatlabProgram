clear all;
close all;

%%
%ѡ��ͼ��
imagename='12.jpg';

%%
%��ȡԴͼ��
image_res_rgb=imread(['test',imagename]);
figure,imshow(image_res_rgb,[0 255]);
image_res_rgb = double(image_res_rgb);

%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(image_res_rgb(:,:,1));
 %����rggb��bayerͼ��
image_bayer_rggb = double(zeros(imageres_heigth,imageres_length));                                                    
image_turnback = double(zeros(imageres_heigth,imageres_length,3));    

%%
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

figure,imshow(uint8(round(image_bayer_rggb)),[0,255]);
imwrite(uint8(round(image_bayer_rggb)),'test12.bmp');
image_bayer_rggb = double(image_bayer_rggb);

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%�ָ����е����ɫ����

for i = 3:2:imageres_heigth-2                                                                                                                  %�����еĺ�ɫ��ظ���ɫ����
    for j = 3:2:imageres_length-2
              
%        tidu_x_r = abs(double(2*image_res_rgb(i,j,1) - image_res_rgb(i,j-2,1) - image_res_rgb(i,j+2,1)));            %x�����ݶȣ�5*5ģ��
%        tidu_y_r = abs(double(2*image_res_rgb(i,j,1) - image_res_rgb(i-2,j,1) - image_res_rgb(i+2,j,1)));            %y�����ݶȣ�5*5ģ��
       
       tidu_x_r = abs(double(image_bayer_rggb(i,j-1) - image_bayer_rggb(i,j+1)));            %x�����ݶȣ�3*3ģ��
       tidu_y_r = abs(double(image_bayer_rggb(i-1,j) - image_bayer_rggb(i+1,j)));            %y�����ݶȣ�3*3ģ��       
        
       if(tidu_x_r > tidu_y_r)
           image_turnback(i,j,2) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;
       elseif(tidu_x_r < tidu_y_r)
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;
       else
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1)+image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/4;
       end
        
    end
    end

for i = 4:2:imageres_heigth-2                                                                                                                   %�����е���ɫ��ظ���ɫ����
    for j = 4:2:imageres_length-2
        
%        tidu_x_b = abs(double(2*image_res_rgb(i,j,3) - image_res_rgb(i,j-2,3) - image_res_rgb(i,j+2,3)));            %x�����ݶȣ�5*5ģ��
%        tidu_y_b = abs(double(2*image_res_rgb(i,j,3) - image_res_rgb(i-2,j,3) - image_res_rgb(i+2,j,3)));            %y�����ݶȣ�5*5ģ��
       
       tidu_x_b = abs(double(image_bayer_rggb(i,j-1) - image_bayer_rggb(i,j+1)));            %x�����ݶȣ�3*3ģ��
       tidu_y_b = abs(double(image_bayer_rggb(i-1,j) - image_bayer_rggb(i+1,j)));            %y�����ݶȣ�3*3ģ��
       
       if(tidu_x_b > tidu_y_b)
           image_turnback(i,j,2) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/2;
       elseif(tidu_x_b < tidu_y_b)
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1))/2;
       else
           image_turnback(i,j,2) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1)+image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j))/4;
       end
    end
end

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%�ָ���ɫ����ɫ����

for i = 3:2:imageres_heigth-1                                                                                                                   %�����е���ɫ��ָ���ɫ��������ɫ����
    for j = 4:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) - image_turnback(i,j-1,2) - image_turnback(i,j+1,2))/2  + image_bayer_rggb(i,j);          %��ɫ
        image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) - image_turnback(i-1,j,2) - image_turnback(i+1,j,2))/2  + image_bayer_rggb(i,j);          %��ɫ
    end
end

for i = 4:2:imageres_heigth-1
    for j = 3:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j) + image_bayer_rggb(i+1,j) - image_turnback(i-1,j,2) - image_turnback(i+1,j,2))/2  + image_bayer_rggb(i,j);          %��ɫ
        image_turnback(i,j,3) = double(image_bayer_rggb(i,j-1) + image_bayer_rggb(i,j+1) - image_turnback(i,j-1,2) - image_turnback(i,j+1,2))/2  + image_bayer_rggb(i,j);          %��ɫ
    end
end

for i = 4:2:imageres_heigth-1                                                                                                                   %�����е���ɫ��ָ���ɫ����
    for j = 4:2:imageres_length-1
        image_turnback(i,j,1) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) - image_turnback(i-1,j-1,2) - image_turnback(i-1,j+1,2) - image_turnback(i+1,j-1,2) - image_turnback(i+1,j+1,2))/4  + image_turnback(i,j,2);
    end
end

for i = 3:2:imageres_heigth-2                                                                                                                  %�����еĺ�ɫ��ظ���ɫ����
    for j = 3:2:imageres_length-2
         image_turnback(i,j,3) = double(image_bayer_rggb(i-1,j-1) + image_bayer_rggb(i-1,j+1) + image_bayer_rggb(i+1,j-1) + image_bayer_rggb(i+1,j+1) - image_turnback(i-1,j-1,2) - image_turnback(i-1,j+1,2) - image_turnback(i+1,j-1,2) - image_turnback(i+1,j+1,2))/4  + image_turnback(i,j,2);    
    end
end

% r = image_turnback(:,:,1);
% r_1 = image_res_rgb(:,:,1);
% g = image_turnback(:,:,2);
% g_1 = image_res_rgb(:,:,2);
% b = image_turnback(:,:,3);
% b_1 = image_res_rgb(:,:,3);
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
MES = 0;
for i = 2 : imageres_heigth-1    
    for j = 2 : imageres_length-1
        MES = (image_turnback(i,j,1) -  image_res_rgb(i,j,1))^2 + (image_turnback(i,j,2) -  image_res_rgb(i,j,2))^2 + (image_turnback(i,j,3) -  image_res_rgb(i,j,3))^2 + MES;
    end
end
MES = MES/(3*(imageres_heigth-1)*(imageres_length-1));
PSNR = 10*log(255^2/round(MES));






