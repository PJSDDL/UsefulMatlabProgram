
%% �Ľ�͸���ʣ�ʹ�õ����˲�
close all
clear all
clc

%���ڰ뾶
window_size=7;

%���ȥ����
w=0.95;
eps_t = 10^-4;
%ѡ��ͼ��
imagename='2.jpg';

%��ȡԴͼ��
%imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres=imread('test.jpg');
figure,imshow(imageres,[0 255]);
%�õ�ͼ��ĳ��Ϳ�
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%��ȡ��ͨ������
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%��ͨ��ͼ��
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab�Դ�����Сֵ�˲�
imagedark = double(imagedark);

%��������ͨ��
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%% ����ȫ�ִ�����(�Ұ�ͨ�������ֵ��Ӧ�ĵ�)
max_inv_dark = max(max(imagedark));
[p1,p2] = find(imagedark==max_inv_dark);   % find�����õ���p2Ϊ��С��������
A(1) = double(imageres_r(p1(1),p2(1)));
A(2) = double(imageres_g(p1(1),p2(1)));
A(3) = double(imageres_b(p1(1),p2(1)));

%% ���Ƴ�ʼ͸����
t_dark = dark_channel(cat(3,(imageres_r/A(1)),(imageres_g/A(1)),(imageres_b/A(3))),window_size);   

t_rough = 1-w*t_dark;

%% �Ż�͸����
r_g = 4*window_size;  %Ϊ��ʹ͸����ͼ���Ӿ�ϸ���������r_g��ȡֵ��С�ڽ�����Сֵ�˲��İ뾶��4��
guide_img = double(rgb2gray(uint8(imageres)))/255;  % ����ͼ����ѡ��Ҷ�ͼ��ĳһ��ͨ��
% guide_img = Iin(:,:,1)/255;  % ����ͼ����ѡ��Ҷ�ͼ��ĳһ��ͨ��
t = guidedfilter(guide_img, t_rough, r_g, eps_t);  

t(t<eps_t) = eps_t;
t(t>1) = 1;

%% ȥ�����
inv_dehaze = imageres;
inv_dehaze(:,:,1) = (imageres_r-A(1))./t + A(1);
inv_dehaze(:,:,2) = (imageres_g-A(2))./t + A(2);
inv_dehaze(:,:,3) = (imageres_b-A(3))./t + A(3);

%% ȡ�����
DCP_Img = uint8(inv_dehaze);

figure('NumberTitle','off','Name','ԭDCP�㷨���ͼ');
imshow(DCP_Img,'border','tight','initialmagnification','fit');
axis normal;