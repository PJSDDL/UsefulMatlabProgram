close all;clear all;clc;

%% ��������
fs=10e3;Ts=1/fs;;T=2048*Ts;
lambda=3e8/24.15e9; % �״﷢�䲨��
N=600; % ����ȡ������ȡ����
t=(0:N-1)*Ts;
f=(0:N-1)*fs/N;

%% ��ȡ����
raw_data=load('2.txt');
figure(1);
plot(raw_data)

% data = raw_data(1:600,:);  %1.txt
% data = raw_data(1:600,:);  %2.txt
data = raw_data(1:600,:);  %3.txt
x=data(:,1);y=data(:,2);
I=x-mean(x);Q=y-mean(y); % ȥֱ��
echo=I+1i*Q;
figure(2);
subplot(211)
plot(t,real(echo))
subplot(212)
plot(t,imag(echo))

%% �ز��źŵ�Ƶ��
echo_fft=fftshift(fft(echo));
f=(0:N-1)/N*fs-fs/2; % ��0����������������
v=f*lambda/2; % Ƶ������ת��Ϊ�ٶ�
figure(3);
plot(v,abs(echo_fft))

