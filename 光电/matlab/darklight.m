close all;
clear all;
clc;
imagedark=imread('imagedark12.jpg');
imagelight=imread('imagelight12.jpg');
[x y]=size(imagedark);
temp=imagelight-imagedark;
imagedes=zeros(x,y);
for i=1:1:x
    for j=1:1:y
        if(temp(i,j)<5 && imagedark(i,j)>175)
            imagedes(i,j)=1;
        end
    end
end
figure,imshow(imagedes,[0 1]);
window_size=8;
se = strel('square',floor(window_size-1));
imagedes = imclose(imagedes,se);
figure,imshow(imagedes,[0 1]);
%image_tran_estimate = medfilt2(image_tran_estimate,[20,20]); 
%figure(2);imdilate
%imshow(image_tran_estimate,[0 255]);
%image_tran_estimate=double(image_tran_estimate)/255;
