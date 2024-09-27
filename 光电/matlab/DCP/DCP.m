function Iout = DCP(Iin,w,r,eps_t)
% 输入：Iin,输入夜间图像（RGB,uint8）
%       w,去雾率
%       r,最小值滤波窗口半径
%       eps_t,透射率下限值
% 输出：Iout,输出夜间图像（RGB,uint8）

%% 输入取反
img_d = double(Iin);

inv_img = img_d;
inv_r = inv_img(:,:,1);
inv_g = inv_img(:,:,2);
inv_b = inv_img(:,:,3);

%% 估计全局大气光(找暗通道中最大值对应的点)
inv_dark = (dark_channel(inv_img,r))';     % 注意转置
max_inv_dark = max(max(inv_dark));
[p1,p2] = find(inv_dark==max_inv_dark);   % find函数得到的p2为从小到大排列
A(1) = double(inv_r(p2(1),p1(1)));
A(2) = double(inv_g(p2(1),p1(1)));
A(3) = double(inv_b(p2(1),p1(1)));

%% 估计初始透射率
t_dark = dark_channel(cat(3,(inv_r/A(1)),(inv_g/A(1)),(inv_b/A(3))),r);   

t_rough = 1-w*t_dark;

%% 优化透射率
r_g = 4*r;  %为了使透射率图更加精细，建议这个r_g的取值不小于进行最小值滤波的半径的4倍
guide_img = double(rgb2gray(uint8(inv_img)))/255;  % 引导图可以选择灰度图或某一个通道
% guide_img = Iin(:,:,1)/255;  % 引导图可以选择灰度图或某一个通道
t = guidedfilter(guide_img, t_rough, r_g, eps_t);  

t(t<eps_t) = eps_t;
t(t>1) = 1;

%% 去雾计算
inv_dehaze = Iin;
inv_dehaze(:,:,1) = (inv_r-A(1))./t + A(1);
inv_dehaze(:,:,2) = (inv_g-A(2))./t + A(2);
inv_dehaze(:,:,3) = (inv_b-A(3))./t + A(3);

%% 取反输出
Iout = uint8(inv_dehaze);
end