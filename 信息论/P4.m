clc

%监督矩阵
H = [
    1, 1, 1, 0, 1, 0, 0;
    1, 1, 0, 1, 0, 1, 0;
    1, 0, 1, 1, 0, 0, 1;
]

%生成矩阵
G = H(1:3, 1:4);
G = G';
size_G = size(G);
size_G = size_G(1);
G = [eye(size_G) G]

%一个消息的编码
i = [1, 0, 1, 0]
k = mod(i*G, 2) % 模2运算代替异或

%纠错
E = eye(7) * H';  %错误图样
k(4) = ~k(4)
error = mod(H*(k'), 2)'
for i = 1:7  %与错误图样比较
    if(E(i,:) == error)
        i
    end
end