clc

%-------------------香农编码-------------------
p=randsample(100,16);    %随机生成16个数字
p=p/sum(p);              %归一化处理使之成为符号概率
p=sort(p,'descend');     %倒叙排列
len=length(p);
for i=1:len
    P(i)=sum(p(1:i))-p(i);
end
K=ceil(-log2(p));

for i=1:len
    code{i}='';
end

for i=1:len     
  while length(code{i})<K(i)
      if P(i)*2>=1
          code{i}=[code{i},'1'];
          P(i)=2*P(i)-1;
      else
          P(i)=2*P(i);
          code{i}=[code{i},'0'];
      end
  end
end
h=sum(p.*(-log2(p)));k_anv=sum(p.*K);eff=h/k_anv;

fprintf('%s     ','符号概率');fprintf('  %s    ','累加概率');
fprintf('%s   ','码字长度');fprintf('%s     \n','香农编码');
for i=1:len
    fprintf('%f     ',p(i));
    fprintf(' %f      ',P(i));
    fprintf(' %d        ',K(i));
    disp(code{i});
end
fprintf('平均码长为%f',k_anv);




%-------------------霍夫曼编码-------------------
fprintf('\n\n\n\n霍夫曼编码');
%信源
symbols = (1:16); % Alphabet vector
prob = p; % Symbol probability vector
[dict,avglen] = huffmandict(symbols, prob);
fprintf('平均码长为%f \n', avglen);
%符号表
for i =1:16
    s = cell2mat(dict(i, 2));
    fprintf('符号：%d  ', i);
    for i = 1:length(s)
        fprintf('%d  ', fix(s(i)));
    end
    fprintf('\n');
end


