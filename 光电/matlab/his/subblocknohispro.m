%% 非重叠子块直方图均衡
close all
clear all
clc
%% 图像输入及参数设置

%选择图像
imagename='1.jpg';
%读取源图像
imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
figure,imshow(imageres,[0 255]);
%设置子块大小
subblockr = 64;
%计算时使用
subblockrc = subblockr-1;
%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);

%% 处理
for imagechannel=1:1:3
    
    imagegray = imageres(:,:,imagechannel);
    %图像分块
    for i=1:1:floor(height/subblockr)
        for j=1:1:floor(length/subblockr)
           subblock{i,j}=imagegray(i+subblockrc*(i-1):i+subblockrc*i,j+subblockrc*(j-1):j+subblockrc*j);
        end
    end
    
    %各块均衡
    for i=1:1:floor(height/subblockr)
        for j=1:1:floor(length/subblockr)
            subblockhis{i,j}=histeq(subblock{i,j});
        end
    end
    
    %将子块合成
    for i=1:1:floor(height/subblockr)
        for j=1:1:floor(length/subblockr)
            imagedes(i+subblockrc*(i-1):i+subblockrc*i,j+subblockrc*(j-1):j+subblockrc*j,imagechannel)=subblockhis{i,j};
        end
    end
end
imagedes(imagedes>255)=255;
imagedes(imagedes<0)=0;
imagedes=uint8(imagedes);
figure,imshow(imagedes,[0 255]);
imwrite(imagedes,'subblocknohis64-1.jpg');
