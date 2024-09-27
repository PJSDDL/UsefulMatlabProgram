clc
close all

im = imread('�ޱ���7.png');
im = double(im);

%תHSVͼ��
im = rgb2hsv(im);

im_ch1 = im(:, :, 3);

im_ch1 = im_ch1 / max(max(im_ch1));
imshow(im_ch1)

%ȥ�����ȹ��͵Ĳ���
im_ch1_mask = im_ch1 > 0.8;
im_ch1 = im_ch1.* im_ch1_mask
im_ch1 = double(im_ch1);
figure
imshow(im_ch1)

% ������˹΢������
c = [-1 -1 -1     %laplacian����
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

%��ֵ�˲�
H = fspecial('average', [2,2]);%2*2��ֵ�˲�
im_lapas = imfilter(im_lapas, H);
figure
imshow(im_lapas)

%���⻯���ֵ��
im_bw = histeq(im_lapas) > 0.9;
figure
imshow(im_bw)


