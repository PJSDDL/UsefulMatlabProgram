function Iout = DCP(Iin,w,r,eps_t)
% ���룺Iin,����ҹ��ͼ��RGB,uint8��
%       w,ȥ����
%       r,��Сֵ�˲����ڰ뾶
%       eps_t,͸��������ֵ
% �����Iout,���ҹ��ͼ��RGB,uint8��

%% ����ȡ��
img_d = double(Iin);

inv_img = img_d;
inv_r = inv_img(:,:,1);
inv_g = inv_img(:,:,2);
inv_b = inv_img(:,:,3);

%% ����ȫ�ִ�����(�Ұ�ͨ�������ֵ��Ӧ�ĵ�)
inv_dark = (dark_channel(inv_img,r))';     % ע��ת��
max_inv_dark = max(max(inv_dark));
[p1,p2] = find(inv_dark==max_inv_dark);   % find�����õ���p2Ϊ��С��������
A(1) = double(inv_r(p2(1),p1(1)));
A(2) = double(inv_g(p2(1),p1(1)));
A(3) = double(inv_b(p2(1),p1(1)));

%% ���Ƴ�ʼ͸����
t_dark = dark_channel(cat(3,(inv_r/A(1)),(inv_g/A(1)),(inv_b/A(3))),r);   

t_rough = 1-w*t_dark;

%% �Ż�͸����
r_g = 4*r;  %Ϊ��ʹ͸����ͼ���Ӿ�ϸ���������r_g��ȡֵ��С�ڽ�����Сֵ�˲��İ뾶��4��
guide_img = double(rgb2gray(uint8(inv_img)))/255;  % ����ͼ����ѡ��Ҷ�ͼ��ĳһ��ͨ��
% guide_img = Iin(:,:,1)/255;  % ����ͼ����ѡ��Ҷ�ͼ��ĳһ��ͨ��
t = guidedfilter(guide_img, t_rough, r_g, eps_t);  

t(t<eps_t) = eps_t;
t(t>1) = 1;

%% ȥ�����
inv_dehaze = Iin;
inv_dehaze(:,:,1) = (inv_r-A(1))./t + A(1);
inv_dehaze(:,:,2) = (inv_g-A(2))./t + A(2);
inv_dehaze(:,:,3) = (inv_b-A(3))./t + A(3);

%% ȡ�����
Iout = uint8(inv_dehaze);
end