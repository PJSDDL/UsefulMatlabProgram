clear;
clc;

image = imread('cameraman.tif');

image = double(image);
image = image / max(max(image));

%-------------------------项目一-------------------------
%添加高斯噪声
noise_g = 0.03*randn(256,256)+image;
% imshow(noise_g)
%均值滤波
A = fspecial('average',[3,3]);
y = imfilter(noise_g,A);
% imshow(y)
%中值滤波
y = medfilt2(noise_g,[3 3]);
% imshow(y)

%-------------------------项目二-------------------------
%添加椒盐噪声
noise_p = imnoise(image,'salt & pepper');
% imshow(noise_p)
%均值滤波
A = fspecial('average',[3,3]);
y = imfilter(noise_p,A);
% imshow(y)
%中值滤波
y = medfilt2(noise_p,[3 3]);
imshow(y);

image2 = imread('Isaac.jpg');

image2 = double(image2);
image2 = image2 / max(max(max(image2)));
[row,column,dim] = size(image2);

%-------------------------项目三-------------------------
%截止频率
freqz = 0.16;
row
column
%理想低通滤波频域函数
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
%理想低通滤波器
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_ideal;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_ideal_lp(:,:,i) = img2_single;
end
% imshow(image2_ideal_lp)

%阶数与截止频率
k = 5;
freqz = 60;
%巴特沃斯低通滤波时域函数
h_bt = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = sqrt((i-ceil(row/2))^2+(m-ceil(column/2))^2);
        h_bt(i,m) = 1/(1+(distance/freqz)^(2*k));
    end
end
%巴特沃斯低通滤波
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_bt;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_pt_lp(:,:,i) = img2_single;
end
% imshow(image2_pt_lp)

%截止频率
freqz = 60;
%高斯低通滤波时域函数
h_g = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = (i-ceil(row/2))^2+(m-ceil(column/2))^2;
        h_g(i,m) = exp(-distance/(2*freqz*freqz));
    end
end
%高斯低通滤波
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_g;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_g_lp(:,:,i) = img2_single;
end
% imshow(image2_g_lp)

%-------------------------项目四-------------------------
%截止频率
freqz = 0.16;

%理想高通滤波频域函数
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
%理想高通滤波器
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_ideal;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_ideal_lp(:,:,i) = img2_single;
end
imshow(image2_ideal_lp)

%阶数与截止频率
k = 5;
freqz = 800;
%巴特沃斯高通滤波时域函数
h_bt = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = sqrt((i-ceil(row/2))^2+(m-ceil(column/2))^2);
        h_bt(i,m) = 1 - 1/(1+(distance/freqz)^(2*k));
    end
end
%巴特沃斯高通滤波
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_bt;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_pt_lp(:,:,i) = img2_single;
end
% imshow(image2_pt_lp)

%截止频率
freqz = 800;
%高斯高通滤波时域函数
h_g = zeros(row,column);
for i = 1:row
    for m = 1:column
        distance = (i-ceil(row/2))^2+(m-ceil(column/2))^2;
        h_g(i,m) = 1 - exp(-distance/(2*freqz*freqz));
    end
end
%高斯高通滤波
for i = 1:3
    img2_single = image2(:,:,i);
    %FFT变换
    img2_single_fft = fft2(img2_single);
    img2_single_fft = fftshift(img2_single_fft);
    %滤波
    img2_single_fft = img2_single_fft.*h_g;
    %IFFT变换
    img2_single = ifftshift(img2_single_fft);
    img2_single = ifft2(img2_single_fft);
    img2_single = abs(img2_single);
    img2_single = img2_single / max(max(img2_single));
    %保存
    image2_g_lp(:,:,i) = img2_single;
end
% imshow(image2_g_lp)



