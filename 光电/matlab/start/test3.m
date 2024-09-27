close all
clear all
clc

imageres = imread('C:\Users\XY\Desktop\´¦ÀíÇ°.png');
figure,imshow(imageres,[0 255]);
imageres = rgb2ycbcr(imageres);

imagey = imageres(:,:,1);
imagecb = imageres(:,:,2);
imagecr = imageres(:,:,3);

imagey = double(imagey);
imagey_new = imagey;
imagey_new(imagey<100)=uint8(imagey(imagey<100)*2);
imagey_new(imagey>=100 & imagey<200)=uint8(imagey(imagey>=100 & imagey<200)/2+150);
imagey_new = histeq(uint8(imagey_new));
%imagey_new(imagey>150) = 20;
imageres(:,:,1)=imagey_new;

imagecb_new = imagecb;
imagecr_new = imagecr;

temp = imagecr-imagecb;
index1 = abs(temp)>10;
index2 = ~index1;
imagcr_new(index1) = imagecr(index1) + temp(index1)*2;
imagcr_new(index2) = imagecr(index2) + temp(index2)*4;
imagcr_new = imresize(imagcr_new,[1080,1920]);
imagecb_new(index1) = imagecb(index1) - temp(index1)*2;
imagecb_new(index2) = imagecb(index2) - temp(index2)*4;
imageres(:,:,2)=uint8(imagecb_new);
imageres(:,:,3)=uint8(imagcr_new);

imageres = ycbcr2rgb(imageres);
figure,imshow(imageres,[0 255]);



imagey_new(imagey<75)=uint8(imagey(imagey<75)/3);
imagey_new(imagey<150 & imagey>=75)=uint8((imagey(imagey<150 & imagey>=75)*7-450)/3);
imagey_new(imagey<200 & imagey>=150)=uint8((imagey(imagey<200 & imagey>=150)-150)/2+200);
imagey_new(imagey>200) = 100;
imageres(:,:,1)=imagey_new;

imagecb = double(imagecb);
imagecr = double(imagecr);




imageres = ycbcr2rgb(imageres);
figure,imshow(imageres,[0 255]);