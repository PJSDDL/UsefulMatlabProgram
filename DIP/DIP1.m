clear;
clc;

%-------------------------��Ŀһ-------------------------
image1 = imread('lena.jpg');
% imshow(image1)
hist1 = imhist(image1);
gause = normpdf([-1.28:0.01:1.27]).';
img_gause = histeq(image1,gause);
% plot(hist1);hold
imshow(img_gause)

hist_gause = imhist(img_gause);
% plot(hist_gause,'r')

%-------------------------��Ŀ��-------------------------
image2 = imread('rose.jpg');
%��ֱ��ͼ
hist1 = imhist(image1);
hist2 = imhist(image2);

%ֱ��ͼ�涨��
img1_img2 = histeq(image1,hist2);
imshow(img1_img2)
img2_img1 = histeq(image2,hist1);
imshow(img2_img1)

%��ֱ��ͼ
hist12 = imhist(img1_img2);
hist21 = imhist(img2_img1);
%�Ƚ�ֱ��ͼ����
% plot(hist2); hold;
% plot(hist12,'r');
plot(hist1); hold;
plot(hist21,'r');

%-------------------------��Ŀ��-------------------------
dark1 = imread('dark_3.jpg');

[row,column] = size(dark1);
bright_area = zeros(row,column);
dark_area = zeros(row,column);

%ͼ��ֿ�
for i = 1:row
    for k =1:column
        if(dark1(i,k) > 100)
            bright_area(i,k) = dark1(i,k);
        elseif(dark1(i,k) > 5)
            dark_area(i,k) = dark1(i,k);
        else
            %�����ǳ���������
        end
    end
end

dark_area = dark_area/max(max(dark_area));
bright_area = bright_area/max(max(bright_area));

gause = normpdf([4-2.55:0.01:4]).';
new_image = histeq(dark_area,gause)+bright_area;
new_image = new_image/max(max(new_image));
% imshow(new_image)
    