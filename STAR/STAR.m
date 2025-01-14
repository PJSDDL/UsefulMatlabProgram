clc
close all

filename = '4.jpg'
y = imread(filename);
y_r = y(:, :, 1);
[i_x, i_y] = size(y_r);

thr = 100
for x = 1: i_x
    for y = 1: i_y
        if y_r(x, y) < thr
            y_r(x, y) = 0;
        end   
    end
end

imshow(y_r)

imwrite(y_r, ['y', filename])