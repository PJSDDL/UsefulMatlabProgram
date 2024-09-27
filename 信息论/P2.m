clc

img = imread('th.jfif');

%ºÚ°×»¯
img = single(img);
img = (img(:,:,1));
imshow(uint8(img))

%Ëã¸ÅÂÊ
size_img = size(img);
img = reshape(img,1,[]);

count = zeros([1,256]);

for i = 1:length(img)
    pixel = img(i)+1;
    count(pixel) = count(pixel)+1;
end

count =  count/length(img);

%ËãìØ
en = sum(-count.*log(count+eps))

%¼ÓÔëÉù
a = 1;
noise = ceil(256*rand(size_img));
img_new = (1-a) * reshape(img,size_img) + a*noise;
img_new = uint8(img_new);

figure(2)
imshow(uint8(img_new))

%Ëã¸ÅÂÊ
img_new = reshape(img_new,1,[]);

count = zeros([1,256]);

for i = 1:length(img_new)
    pixel = img_new(i)+1;
    count(pixel) = count(pixel)+1;
end

count =  count/length(img);

%ËãìØ
en = sum(-count.*log(count+eps))