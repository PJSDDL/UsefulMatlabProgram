clc;
close all;

x = [3, 4, 5, 6, 7, 8, 9];
y = [2.01, 2.98, 3.50, 5.02, 5.47, 6.02, 7.05];

%拟合形式：y = kx + c
k11 = 1*5;
k21 = sum(x);
k22 = sum(x.*x);

k1y = sum(y);
k2y = sum(x.*y);

%解二元方程组
A = [k11, k21; k21, k22];
b = [k1y; k2y];

result = b' / A;
k = result(2) 
c = result(1)

plot([3:9], k*[3:9]+c);
hold
plot(x, y, 'r');