clc
close all

im = imread('无标题4.png');
im = double(im);

% 转HSV图像
% 色调   饱和   明度
im = rgb2hsv(im);
im_ch_S = im(:, :, 2);
im_ch_V = im(:, :, 3);

im_ch_S = im_ch_S / max(max(im_ch_S));
imshow(im_ch_S)
im_ch_V = im_ch_V / max(max(im_ch_V));
figure
imshow(im_ch_V)

% 计算图像平均亮度
im_mean = mean(mean(im_ch_S))

%根据图像饱和度决定提取方法
threshold = 0.6;

if  im_mean > threshold
    %图像背景发白，使用拉普拉斯算法提取边缘
    
else
    %图像背景较黑暗，提取白色图案检测弹幕
    %均衡化与二值化
    im_bw = im_ch_V > 0.7;
    figure
    imshow(im_bw)
    
    %均值滤波
    H = fspecial('average',[7,7]);
    im_max_ave = imfilter(im_bw, H);

    figure
    imshow(im_max_ave)
end

% % 拉普拉斯微分算子
% c = [-1 -1 -1     %laplacian算子
%     -1  8 -1
%     -1 -1 -1];
% c = double(c);
% 
% im_lapas = conv2(c, im_ch1);
% 
% im_lapas_max = max(max(im_lapas));
% im_lapas_min = min(min(im_lapas));
% im_lapas = im_lapas - im_lapas_min;
% im_lapas = im_lapas / (im_lapas_max - im_lapas_min); 
% 
% figure
% imshow(histeq(im_lapas))

% %最值滤波
% im_max = ordfilt2(im_bw, 1, true(2));
% % im_max = ordfilt2(im_max, 1, true(2));
% figure
% imshow(im_max)
% 7

