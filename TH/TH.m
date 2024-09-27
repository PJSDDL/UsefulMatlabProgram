clc
close all

im = imread('无标题7.png');
im = double(im);

%转HSV图像
im = rgb2hsv(im);

im_ch1 = im(:, :, 3);

im_ch1 = im_ch1 / max(max(im_ch1));
imshow(im_ch1)

%去除亮度过低的部分
im_ch1_mask = im_ch1 > 0.8;
im_ch1 = im_ch1.* im_ch1_mask
im_ch1 = double(im_ch1);
figure
imshow(im_ch1)

% 拉普拉斯微分算子
c = [-1 -1 -1     %laplacian算子
    -1  8 -1
    -1 -1 -1];
c = double(c);

im_lapas = conv2(c, im_ch1);

im_lapas_max = max(max(im_lapas));
im_lapas_min = min(min(im_lapas));
im_lapas = im_lapas - im_lapas_min;
im_lapas = im_lapas / (im_lapas_max - im_lapas_min); 

im_lapas = histeq(im_lapas);

figure
imshow(im_lapas)

%均值滤波
H = fspecial('average', [2,2]);%2*2均值滤波
im_lapas = imfilter(im_lapas, H);
figure
imshow(im_lapas)

%均衡化与二值化
im_bw = histeq(im_lapas) > 0.9;
figure
imshow(im_bw)


