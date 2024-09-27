%% 重叠子块直方图均衡
close all
clear all
clc
%% 图像输入及参数设置

%选择图像
imagename='5.jpg';
%读取源图像
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread(['test',imagename]);
figure,imshow(imageres,[0 255]);
%设置子块大小
subblockr = 128;
%设置重叠的尺寸
overlapr = 0;
%计算时使用
subblockrc = subblockr-1;
%得到图像的长和宽
[height,length]=size(imageres(:,:,1));
%设置出处理后图像
imagedes = zeros(height,length,3);
blockcnt = zeros(height,length,3);
%进行如下处理得到数量
height_ternal = subblockrc-overlapr;
length_ternal = subblockrc-overlapr;
temp1 = 1:(height_ternal+1):height-subblockrc;
heightloopr = size(temp1,2);
temp2 = 1:(length_ternal+1):length-subblockrc;
lengthloopr = size(temp2,2);
if(temp1(heightloopr) ~= height)
    heightloopr=heightloopr+1;
end

if(temp2(lengthloopr) ~= length)
    lengthloopr=lengthloopr+1;
end
%初始化子块
subblock = zeros(subblockr,subblockr);
subblockhis = zeros(subblockr,subblockr);
clear temp;
%% 处理
for imagechannel=1:1:3
    %图像分块
    for i=1:1:heightloopr
        for j=1:1:lengthloopr
           datatemp(1) = i+height_ternal*(i-1);
           datatemp(2) = datatemp(1)+subblockrc;
           if(datatemp(2)>height)
              datatemp(2)=height;
           end
           datatemp(3) = j+length_ternal*(j-1);
           datatemp(4) = datatemp(3)+subblockrc;
           if(datatemp(4)>length)
              datatemp(4)=length;
           end
           %取子块
           subblock = imageres(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel);
           %进行均衡
           subblockhis = histeq(subblock);
           %子块合成
           imagedes(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel)=imagedes(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel)+double(subblockhis);
           blockcnt(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel)=blockcnt(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel)+1;
        end
    end   
end

imagedes = round(imagedes./blockcnt);
imagedes = uint8(imagedes);
imagedes(imagedes>255)=255;
imagedes(imagedes<0)=0;
figure,imshow(imagedes,[0 255]);
%imwrite(imagedes,'subblockhis128-120-1.jpg');
imwrite(imagedes,['compare-sub-',imagename]);
