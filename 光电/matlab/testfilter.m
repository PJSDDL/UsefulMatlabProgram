clear all
clc
imageres=imread('F:\XY\master_thesis\filtertest.bmp');
imagemask=fspecial('gaussian',[3,3]);
tic
imagedes=imfilter(imageres,imagemask,'conv','replicate');
t=toc