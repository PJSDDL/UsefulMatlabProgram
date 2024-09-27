%% �ص��ӿ�ֱ��ͼ����
close all
clear all
clc
%% ͼ�����뼰��������

%ѡ��ͼ��
imagename='5.jpg';
%��ȡԴͼ��
%imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres = imread(['test',imagename]);
figure,imshow(imageres,[0 255]);
%�����ӿ��С
subblockr = 128;
%�����ص��ĳߴ�
overlapr = 0;
%����ʱʹ��
subblockrc = subblockr-1;
%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);
blockcnt = zeros(height,length,3);
%�������´���õ�����
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
%��ʼ���ӿ�
subblock = zeros(subblockr,subblockr);
subblockhis = zeros(subblockr,subblockr);
clear temp;
%% ����
for imagechannel=1:1:3
    %ͼ��ֿ�
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
           %ȡ�ӿ�
           subblock = imageres(datatemp(1):datatemp(2),datatemp(3):datatemp(4),imagechannel);
           %���о���
           subblockhis = histeq(subblock);
           %�ӿ�ϳ�
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
