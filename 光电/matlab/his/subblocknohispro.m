%% ���ص��ӿ�ֱ��ͼ����
close all
clear all
clc
%% ͼ�����뼰��������

%ѡ��ͼ��
imagename='1.jpg';
%��ȡԴͼ��
imageres = imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
figure,imshow(imageres,[0 255]);
%�����ӿ��С
subblockr = 64;
%����ʱʹ��
subblockrc = subblockr-1;
%�õ�ͼ��ĳ��Ϳ�
[height,length]=size(imageres(:,:,1));
%���ó������ͼ��
imagedes = zeros(height,length,3);

%% ����
for imagechannel=1:1:3
    
    imagegray = imageres(:,:,imagechannel);
    %ͼ��ֿ�
    for i=1:1:floor(height/subblockr)
        for j=1:1:floor(length/subblockr)
           subblock{i,j}=imagegray(i+subblockrc*(i-1):i+subblockrc*i,j+subblockrc*(j-1):j+subblockrc*j);
        end
    end
    
    %�������
    for i=1:1:floor(height/subblockr)
        for j=1:1:floor(length/subblockr)
            subblockhis{i,j}=histeq(subblock{i,j});
        end
    end
    
    %���ӿ�ϳ�
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
