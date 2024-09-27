clc

% 1.��ȡ���е�������
[input_signal, Fs] = wavread('6.wav');

% 2.̬ͬ���
% ������
complex_cepstrum = cceps(input_signal);
plot(complex_cepstrum)
title('������');
figure

% ̬ͬ�˲�  ���δ�
len = size(complex_cepstrum);
len = len(1);
cutoff = 9;
complex_cepstrum_L = complex_cepstrum(1: cutoff);
complex_cepstrum_R = complex_cepstrum(len-cutoff+1: len);
excitation = [complex_cepstrum_L; zeros([len-cutoff*2, 1]); complex_cepstrum_R];

% �������ż�������������
vocal_tract = complex_cepstrum - excitation;

% ����
excitation_impulse_response = ifft(exp(fft(excitation)));
vocal_tract_impulse_response = ifft(exp(fft(vocal_tract)));

% 3.�����ع�
reconstructed_signal = conv(excitation_impulse_response, vocal_tract_impulse_response);

% 4.����ԭʼ�������ع�����������
time = (0:length(input_signal)-1) / Fs;

subplot(2, 1, 1);
plot(time, input_signal);
xlabel('ʱ�� (��)');
ylabel('����');
title('ԭʼ��������');

subplot(2, 1, 2);
plot(time, reconstructed_signal(1:length(input_signal)));
xlabel('ʱ�� (��)');
ylabel('����');
title('�ع�����������');

figure
plot(abs(fft(vocal_tract_impulse_response)));
title('�����');

wavwrite(reconstructed_signal, Fs, 'recover.wav')
