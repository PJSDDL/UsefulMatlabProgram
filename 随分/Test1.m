function [ output_args ] = Untitled1( input_args )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here

%��Ҫ����
N = 25;
EX=0;
DX=0;

%����25����̬�ֲ�
x = randn(1,N);
x = sqrt(2)*x;
%EXDX(x,N)
%hist(x);
%plot(x);

%����1000����̬�ֲ�
N=1000;
x = randn(1,N);
x = sqrt(2)*x;
EXDX(x,N)
%hist(x,10);
%hold
%plot(x);

%����1000�����ȷֲ�
N=1000;
x = rand(1,N);
x = sqrt(24)*x-sqrt(24)/2;
EXDX(x,N)
hist(x,10);
plot(x);

fprintf('Done\n\n\n');

%����������ȷֲ����۲���͵ķֲ�
N=100000;
x1 = rand(1,N);
x2 = rand(1,N);
x3 = rand(1,N);
x4 = rand(1,N);
x5 = rand(1,N);

%hist(x1+x2,100)
%hist(x1+x2+x3+x4+x5,100)

end

%�������뷽��
function [EX,DX] = EXDX(x,N)
    sum = 0;
    for i = 1:N
        sum = sum+x(i);
    end
    fprintf('EX=%f \n',sum/N);

    sum = 0;
    for i = 1:N
        sum = sum+(x(i)-0)^2;
    end
    fprintf('DX=%f \n',sum/N);
end

%��߽׾�
function [EX,DX] = EXDX2(x,N)
    sum = 0;
    for i = 1:N
        sum = sum+(x(i)-0)^3;
    end
    fprintf('EX2=%f \n',sum/N);

    sum = 0;
    for i = 1:N
        sum = sum+(x(i)-0)^4;
    end
    fprintf('DX2=%f \n',sum/N);
end