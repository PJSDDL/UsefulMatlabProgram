clc
close all

im = imread('�ޱ���4.png');
im = double(im);

% תHSVͼ��
% ɫ��   ����   ����
im = rgb2hsv(im);
im_ch_S = im(:, :, 2);
im_ch_V = im(:, :, 3);

im_ch_S = im_ch_S / max(max(im_ch_S));
imshow(im_ch_S)
im_ch_V = im_ch_V / max(max(im_ch_V));
figure
imshow(im_ch_V)

% ����ͼ��ƽ������
im_mean = mean(mean(im_ch_S))

%����ͼ�񱥺ͶȾ�����ȡ����
threshold = 0.6;

if  im_mean > threshold
    %ͼ�񱳾����ף�ʹ��������˹�㷨��ȡ��Ե
    
else
    %ͼ�񱳾��Ϻڰ�����ȡ��ɫͼ����ⵯĻ
    %���⻯���ֵ��
    im_bw = im_ch_V > 0.7;
    figure
    imshow(im_bw)
    
    %��ֵ�˲�
    H = fspecial('average',[7,7]);
    im_max_ave = imfilter(im_bw, H);

    figure
    imshow(im_max_ave)
end

% % ������˹΢������
% c = [-1 -1 -1     %laplacian����
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

% %��ֵ�˲�
% im_max = ordfilt2(im_bw, 1, true(2));
% % im_max = ordfilt2(im_max, 1, true(2));
% figure
% imshow(im_max)
% 7

