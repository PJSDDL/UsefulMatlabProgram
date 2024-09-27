close all
clear all
clc

for i=1:1:16
    imageres1 = imread(['F:\XY\master_thesis\speedtestimage\mytest',num2str(i),'.jpg']);
    imageres2 = imread(['F:\XY\中期\mid-com1-',num2str(i),'.jpg']);
    imageres3 = imread(['F:\XY\中期\mid-com2-',num2str(i),'.jpg']);
    imagedes = cat(2,imageres1,imageres2,imageres3);
    %imshow(imagedes,[0 255]);
    imwrite(imagedes,['F:\XY\中期\mid-com-',num2str(i),'.jpg']);
end

x = 0:1:255;
y = x;

y(x<100)=uint8(x(x<100)*2);
y(x>200)=uint8(-x(x>200)+400);

wfid = fopen('imagedata.txt','w+');
for i=1:1:256
    fprintf(wfid,'%d : %d;\n',i-1,y(i));
end
fclose(wfid);

figure,plot(x);
hold on,plot(y);



