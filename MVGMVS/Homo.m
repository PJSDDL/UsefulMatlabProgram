clc
close all

%���㵥Ӧ����
%BV1Mg4y1v7E5

%��ȡͼƬ
I_L = imread('1.jpg');
I_R = imread('2.jpg');

%��ʾͼƬ
subplot(2,1,1)
imshow(I_L)
%ѡ��
[x_L, y_L] = getpts
%��ʾͼƬ
subplot(2,1,2)
imshow(I_R)
%ѡ��
[x_R, y_R] = getpts


%ƥ���
p1_L = [x_L(1), y_L(1)];
p1_R = [x_R(1), y_R(1)];
p2_L = [x_L(2), y_L(2)];
p2_R = [x_R(2), y_R(2)];
p3_L = [x_L(3), y_L(3)];
p3_R = [x_R(3), y_R(3)];
p4_L = [x_L(4), y_L(4)];
p4_R = [x_R(4), y_R(4)];

%������
%����ƥ�����ⵥӦ����
%��h33 = 1
A = [
    p1_L(1), p1_L(2), 1, 0, 0, 0, -p1_L(1)*p1_R(1), -p1_L(2)*p1_R(1);
    0, 0, 0, p1_L(1), p1_L(2), 1, -p1_L(1)*p1_R(2), -p1_L(2)*p1_R(2);
    p2_L(1), p2_L(2), 1, 0, 0, 0, -p2_L(1)*p2_R(1), -p2_L(2)*p2_R(1);
    0, 0, 0, p2_L(1), p2_L(2), 1, -p2_L(1)*p2_R(2), -p2_L(2)*p2_R(2);
    p3_L(1), p3_L(2), 1, 0, 0, 0, -p3_L(1)*p3_R(1), -p3_L(2)*p3_R(1);
    0, 0, 0, p3_L(1), p3_L(2), 1, -p3_L(1)*p3_R(2), -p3_L(2)*p3_R(2);
    p4_L(1), p4_L(2), 1, 0, 0, 0, -p4_L(1)*p4_R(1), -p4_L(2)*p4_R(1);
    0, 0, 0, p4_L(1), p4_L(2), 1, -p4_L(1)*p4_R(2), -p4_L(2)*p4_R(2);
];

b = [
    p1_R(1); p1_R(2); p2_R(1); p2_R(2); p3_R(1); p3_R(2); p4_R(1); p4_R(2);
];

H_ = eye(8) / A * b;

H = [
    H_(1), H_(2), 0;
    H_(4), H_(5), 0;
    H_(7), H_(8), 1
];

tform = maketform('affine', H);
I_tran = imtransform(I_L, tform);

imwrite(I_tran, '3.jpg')

