clear;
clc;

image = imread('cameraman.tif');
% imshow(image)

%reshape
image_2 = reshape(image,1024,8,8);
image_3 = reshape(image,1024,64);
image_4 = image_3.';

%KL变换
image_4 = double(image_4);
[coef,score,latent] = princomp(image_4);

cov_matrix = cov(image_4);
% imshow(cov_matrix)
% imshow(coef)
% size(score)
% imshow(score)
% plot(log(latent+1))
plot(latent)
latent(1:3) / sum(latent)

%KL反变换
k = 128;  %决定抛弃多少因子
score = horzcat(score(:,1:1024-k), zeros(64,k));
for i = 1:64
    mean_image(i,:) = mean(image_4);
end
image_y = score*(coef.')+mean_image;
image_y = ceil(image_y);

image_5 = image_y.';
image_6 = reshape(image_5,256,256);

% imshow(image_6/max(max(image_6)))
