% example: detail enhancement
% figure 6 in our paper

close all;

I = double(imread('.\img_enhancement\imagedes2_gf.jpg')) / 255;
p = I;

r = 64;
eps = 0.1^2;

q = zeros(size(I));

q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);

I_enhanced = (I - q) * 5 + q;

figure();
imshow(I_enhanced, [0, 1]);
imwrite(I_enhanced, 'image_gfenhance.jpg');
