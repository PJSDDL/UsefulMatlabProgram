clear all
clc
imagename = 'test5.jpg';
imageres = imread(['E:\XY\master_thesis\testimage\',imagename]);
[hei,len] = size(imageres(:,:,1));
if(mod(hei,2)~=0)
    imageres = imageres(1:(hei-1),:,:);
end
if(mod(len,2)~=0)
    imageres = imageres(:,1:(len-1),:);
end
[hei,len] = size(imageres(:,:,1));
imagedes=zeros(ceil(hei/16)*16,len,3);
imagedes1=zeros(ceil(hei/16)*16,ceil(len/16)*16,3);

if(mod(hei,16)~=0)
    lessnum = 16-mod(hei,16);
    for i=1:1:ceil(lessnum/2)
        imagedes(i,:,:)=imageres(1,:,:);
    end
    imagedes((ceil(lessnum/2)+1):(ceil(lessnum/2)+hei),:,:)=imageres(:,:,:);
    for i=1:1:floor(lessnum/2)
        imagedes((i+ceil(lessnum/2+hei)),:,:)=imageres(hei,:,:);
    end
else
    imagedes = imageres;
end

if(mod(len,16)~=0)
    lessnum = 16-mod(len,16);
    for i=1:1:ceil(lessnum/2)
        imagedes1(:,i,:)=imagedes(:,1,:);
    end
    imagedes1(:,(ceil(lessnum/2)+1):(ceil(lessnum/2)+len),:)=imagedes(:,:,:);
    for i=1:1:floor(lessnum/2)
        imagedes1(:,(i+ceil(lessnum/2+len)),:)=imagedes(:,len,:);
    end
end
    
if(mod(len,16)~=0)
    imwrite(uint8(imagedes1),imagename);
    imshow(uint8(imagedes1),[0 255]);
else
    if(mod(hei,16)~=0)
        imwrite(uint8(imagedes),imagename);
        imshow(uint8(imagedes),[0 255]);
    else
        imwrite(uint8(imageres),imagename);
        imshow(uint8(imageres),[0 255]);
    end
end