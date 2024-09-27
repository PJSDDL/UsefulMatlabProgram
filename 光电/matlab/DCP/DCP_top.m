
%% 改进透射率，使用导向滤波
close all
clear all
clc

%窗口半径
window_size=7;

%雾的去除度
w=0.95;
eps_t = 10^-4;
%选择图像
imagename='2.jpg';

%读取源图像
%imageres=imread(['F:\XY\master_thesis\speedtestimage\speedtestsmall',imagename]);
imageres=imread('test.jpg');
figure,imshow(imageres,[0 255]);
%得到图像的长和宽
[imageres_heigth,imageres_length]=size(imageres(:,:,1));

%求取暗通道数据
Imin = min(imageres(:,:,1),min(imageres(:,:,2),imageres(:,:,3)));
%暗通道图像
imagedark = ordfilt2(Imin,1,ones(2*window_size+1,2*window_size+1)); % matlab自带的最小值滤波
imagedark = double(imagedark);

%分离三个通道
imageres_r=double(imageres(:,:,1));
imageres_g=double(imageres(:,:,2));
imageres_b=double(imageres(:,:,3));

%% 估计全局大气光(找暗通道中最大值对应的点)
max_inv_dark = max(max(imagedark));
[p1,p2] = find(imagedark==max_inv_dark);   % find函数得到的p2为从小到大排列
A(1) = double(imageres_r(p1(1),p2(1)));
A(2) = double(imageres_g(p1(1),p2(1)));
A(3) = double(imageres_b(p1(1),p2(1)));

%% 估计初始透射率
t_dark = dark_channel(cat(3,(imageres_r/A(1)),(imageres_g/A(1)),(imageres_b/A(3))),window_size);   

t_rough = 1-w*t_dark;

%% 优化透射率
r_g = 4*window_size;  %为了使透射率图更加精细，建议这个r_g的取值不小于进行最小值滤波的半径的4倍
guide_img = double(rgb2gray(uint8(imageres)))/255;  % 引导图可以选择灰度图或某一个通道
% guide_img = Iin(:,:,1)/255;  % 引导图可以选择灰度图或某一个通道
t = guidedfilter(guide_img, t_rough, r_g, eps_t);  

t(t<eps_t) = eps_t;
t(t>1) = 1;

%% 去雾计算
inv_dehaze = imageres;
inv_dehaze(:,:,1) = (imageres_r-A(1))./t + A(1);
inv_dehaze(:,:,2) = (imageres_g-A(2))./t + A(2);
inv_dehaze(:,:,3) = (imageres_b-A(3))./t + A(3);

%% 取反输出
DCP_Img = uint8(inv_dehaze);

figure('NumberTitle','off','Name','原DCP算法结果图');
imshow(DCP_Img,'border','tight','initialmagnification','fit');
axis normal;