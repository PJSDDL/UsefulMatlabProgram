clear;
clc;

image = imread('cameraman.tif');

image = double(image);
image = image / max(max(image));

%-------------------------��Ŀһ-------------------------
%��Ӹ�˹����
noise_g = 0.03*randn(256,256)+image;
% imshow(noise_g)
%��ֵ�˲�
A = fspecial('average',[3,3]);
y = imfilter(noise_g,A);
% imshow(y)
%��ֵ�˲�
y = medfilt2(noise_g,[3 3]);
% imshow(y)

%-------------------------��Ŀ��-------------------------
%��ӽ�������
noise_p = imnoise(image,'salt & pepper');
% imshow(noise_p)
%��ֵ�˲�
A = fspecial('average',[3,3]);
y = imfilter(noise_p,A);
% imshow(y)
%��ֵ�˲�
y = medfilt2(noise_p,[3 3]);
imshow(y);

image2 = imread('Isaac.jpg');

image2 = double(image2);
image2 = image2 / max(max(max(image2)));
[row,column,dim] = size(image2);

%-------------------------��Ŀ��-------------------------
%��ֹƵ��
freqz = 0.16;
row
column
%�����ͨ�˲�Ƶ����
h_ideal = zeros(row,column);
for i = 1:row
    for m = 1:column
        if i>(row/2-freqz*row) && i<(row/2+freqz*row) && m>(column/2-freqz*column) && m<(column/2+freqz*column)
            h_ideal(i,m) = 1;
        else
            h_ideal(i,m) = 0;
        end
    end
end
%�����ͨ�˲���
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_ideal;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_ideal_lp(:,:,i) = img2_single;
end
% imshow(image2_ideal_lp)

%�������ֹƵ��
k = 5;
freqz = 60;
%������˹��ͨ�˲�ʱ����
h_bt = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = sqrt((i-ceil(row/2))^2+(m-ceil(column/2))^2);
        h_bt(i,m) = 1/(1+(distance/freqz)^(2*k));
    end
end
%������˹��ͨ�˲�
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_bt;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_pt_lp(:,:,i) = img2_single;
end
% imshow(image2_pt_lp)

%��ֹƵ��
freqz = 60;
%��˹��ͨ�˲�ʱ����
h_g = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = (i-ceil(row/2))^2+(m-ceil(column/2))^2;
        h_g(i,m) = exp(-distance/(2*freqz*freqz));
    end
end
%��˹��ͨ�˲�
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_g;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_g_lp(:,:,i) = img2_single;
end
% imshow(image2_g_lp)

%-------------------------��Ŀ��-------------------------
%��ֹƵ��
freqz = 0.16;

%�����ͨ�˲�Ƶ����
h_ideal = zeros(row,column);
for i = 1:row
    for m = 1:column
        if i>(row/2-freqz*row) && i<(row/2+freqz*row) && m>(column/2-freqz*column) && m<(column/2+freqz*column)
            h_ideal(i,m) = 0;
        else
            h_ideal(i,m) = 1;
        end
    end
end
%�����ͨ�˲���
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_ideal;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_ideal_lp(:,:,i) = img2_single;
end
imshow(image2_ideal_lp)

%�������ֹƵ��
k = 5;
freqz = 800;
%������˹��ͨ�˲�ʱ����
h_bt = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = sqrt((i-ceil(row/2))^2+(m-ceil(column/2))^2);
        h_bt(i,m) = 1 - 1/(1+(distance/freqz)^(2*k));
    end
end
%������˹��ͨ�˲�
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_bt;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_pt_lp(:,:,i) = img2_single;
end
% imshow(image2_pt_lp)

%��ֹƵ��
freqz = 800;
%��˹��ͨ�˲�ʱ����
h_g = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = (i-ceil(row/2))^2+(m-ceil(column/2))^2;
        h_g(i,m) = 1 - exp(-distance/(2*freqz*freqz));
    end
end
%��˹��ͨ�˲�
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT�任
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %�˲�
    img2_single_fft = img2_single_fft.*h_g;
    %IFFT�任
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %����
    image2_g_lp(:,:,i) = img2_single;
end
% imshow(image2_g_lp)



