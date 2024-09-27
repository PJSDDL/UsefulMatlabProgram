clear all; 
close all;  
f0=imread('dark_1.jpg');
figure(1);  
subplot(2,2,1);
imshow(f0);  
title('ԭͼ��');
subplot(2,2,2);
imhist(f0);  
axis off;
title('ԭͼ���ֱ��ͼ');
f1= histeq(f0);  
subplot(2,2,3);
imshow(f1);    
title('ֱ��ͼ���⻯���ͼ��');
subplot(2,2,4);
imhist(f1);  
axis off;
title('���⻯���ֱ��ͼ');
figure(2);   
[m,n]=size(f0);  
I1=f0(1:fix(m/2),1:fix(n/2));  
I2=f0(1:fix(m/2),1+fix(n/2):n);  
I3=f0(1+fix(m/2):m,1:fix(n/2));  
I4=f0(1+fix(m/2):m,1+fix(n/2):n);    
subplot(2,4,1);
imshow(I1);title('��ͼ1');  
subplot(2,4,2);
imhist(I1);title('��ͼ1ֱ��ͼ');
subplot(2,4,3);
imshow(I2);title('��ͼ2');  
subplot(2,4,4);
imhist(I2);title('��ͼ2ֱ��ͼ');
subplot(2,4,5);
imshow(I3);title('��ͼ3');  
subplot(2,4,6);
imhist(I3);title('��ͼ3ֱ��ͼ');
subplot(2,4,7);
imshow(I4);title('��ͼ4');  
subplot(2,4,8);
imhist(I4);title('��ͼ4ֱ��ͼ');  
figure(3);
J1=histeq(I1);  
J2=histeq(I2);  
J3=histeq(I3);  
J4=histeq(I4);  
subplot(2,4,1); 
imshow(J1);title('��ͼ1���⻯');  
subplot(2,4,2);
imhist(J1);title('��ͼ1���⻯ֱ��ͼ');
subplot(2,4,3); 
imshow(J2);title('��ͼ2���⻯');  
subplot(2,4,4);
imhist(J2);title('��ͼ2���⻯ֱ��ͼ'); 
subplot(2,4,5);
imshow(J3);title('��ͼ3���⻯');  
subplot(2,4,6);
imhist(J3);title('��ͼ3���⻯ֱ��ͼ');
subplot(2,4,7);
imshow(J4);title('��ͼ4���⻯');  
subplot(2,4,8);
imhist(J4);title('��ͼ4���⻯ֱ��ͼ');
figure(4);
J=uint8(zeros(size(f0)));  
J(1:fix(m/2),1:fix(n/2))=J1;  
J(1:fix(m/2),1+fix(n/2):n)=J2;  
J(1+fix(m/2):m,1:fix(n/2))=J3;  
J(1+fix(m/2):m,1+fix(n/2):n)=J4;  
subplot(1,2,1);
imshow(J);title('�ֲ����⻯ͼ��');  
subplot(1,2,2);
imhist(J);title('�ֲ����⻯ͼ��ֱ��ͼ'); 