clc

% 1.读取已有的浊语音
[input_signal, Fs] = wavread('6.wav');

% 2.同态解卷
% 复倒谱
complex_cepstrum = cceps(input_signal);
plot(complex_cepstrum)
title('复倒谱');
figure

% 同态滤波  矩形窗
len = size(complex_cepstrum);
len = len(1);
cutoff = 9;
complex_cepstrum_L = complex_cepstrum(1: cutoff);
complex_cepstrum_R = complex_cepstrum(len-cutoff+1: len);
excitation = [complex_cepstrum_L; zeros([len-cutoff*2, 1]); complex_cepstrum_R];

% 分离声门激励与声道特性
vocal_tract = complex_cepstrum - excitation;

% 解卷积
excitation_impulse_response = ifft(exp(fft(excitation)));
vocal_tract_impulse_response = ifft(exp(fft(vocal_tract)));

% 3.语音重构
reconstructed_signal = conv(excitation_impulse_response, vocal_tract_impulse_response);

% 4.绘制原始语音与重构的语音波形
time = (0:length(input_signal)-1) / Fs;

subplot(2, 1, 1);
plot(time, input_signal);
xlabel('时间 (秒)');
ylabel('幅度');
title('原始语音波形');

subplot(2, 1, 2);
plot(time, reconstructed_signal(1:length(input_signal)));
xlabel('时间 (秒)');
ylabel('幅度');
title('重构的语音波形');

figure
plot(abs(fft(vocal_tract_impulse_response)));
title('共振峰');

wavwrite(reconstructed_signal, Fs, 'recover.wav')
