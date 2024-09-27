clc;

rand_seq = [1:16,1:16,1:16]
% rand_seq = [1:16,zeros([1,32])+1]
% rand_seq = [1:16,1:16,zeros([1,16])+1]

%求概率
rand_pro = zeros([1 16]);
for i = 1:16
    for k = 1:48
        if(rand_seq(k) == i)
            rand_pro(i) = rand_pro(i)+1;
        end
    end
end

rand_pro = rand_pro/48;

%信息量
infor = 0;
for i = 1:16
    infor = infor - log(rand_pro(i));
end
infor

%熵
infor = 0;
for i = 1:16
    infor = infor - rand_pro(i)*log(rand_pro(i));
end
infor