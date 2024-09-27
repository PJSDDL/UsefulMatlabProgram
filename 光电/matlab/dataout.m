close all
clear all
clc
imagemask=fspecial('gaussian',[3,3]);
gfile = fopen('gfile.txt','a');
for i=1:1:3
    for j=1:1:3
        fprintf(gfile,'%d,',round(imagemask(i,j)*1024));
    end
    
end
