%根据三个点计算三角函数系数
% A * sin(wt + d) + B

w = 2 * 3.1415 * 50;
A = 2.113
d = 0.113
B = 4.011

%产生三个点
t1 = 0.1;
t2 = 0.101;
t3 = 0.102;

y1 = A * sin(w * t1 + d) + B;
y2 = A * sin(w * t2 + d) + B;
y3 = A * sin(w * t3 + d) + B;

%计算参数，求解三角函数
k1 = sin(w * t1) - sin(w * t2);
k2 = cos(w * t1) - cos(w * t2);
k3 = sin(w * t1) - sin(w * t3);
k4 = cos(w * t1) - cos(w * t3);
Y1 = y1 - y2;
Y2 = y1 - y3;

Asind = (Y1 * k3 - Y2 * k1) / (k2 * k3 - k4 * k1);
Acosd = (Y1 - Asind * k2) / k1; 

A_c = sqrt(Asind * Asind + Acosd * Acosd)
d_c = asin(Asind / A_c)
B_c = y1 - A_c * sin(w * t1 + d_c)

