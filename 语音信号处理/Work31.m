clc
close all

% ��ȡ���е�������
[y, fs] = wavread('10.wav');

% ���ò���
frame_length = 30; % ÿ֡�ĳ��ȣ����룩
frame_shift = 10; % ֡�ƣ����룩
window_type = 'hamming'; % ����������

frame_len = round(frame_length * fs / 1000); % ��֡����ת��Ϊ������
frame_shift_len = round(frame_shift * fs / 1000); % ��֡��ת��Ϊ������

% ��֡
num_frames = floor((length(y) - frame_len) / frame_shift_len) + 1;
frames = zeros(frame_len, num_frames);
for i = 1:num_frames
    start_idx = (i - 1) * frame_shift_len + 1;
    frames(:, i) = y(start_idx:start_idx+frame_len-1);
end

% �����ʱ����غ���
autocorr_frames = xcorr(frames, 'biased');
autocorr_frames = autocorr_frames(frame_len:end, :); % ֻ�����Ǹ��ӳٲ���

% �������ڹ���
[, pitch_periods] = max(autocorr_frames); % ��������Ϊ����غ������ֵ���ڵ��ӳ�λ��

% ��������  �ѷ���С�Ĳ���ȥ��
center_clipping_threshold = 0.35; % ����������ֵ
clipped_frames = zeros(size(frames));
for i = 1:num_frames
    frame = frames(:, i);
    max_amp = max(abs(frame));
    center_clipping_level = center_clipping_threshold * max_amp;
    clipped_frames(:, i) = frame .* (abs(frame) > center_clipping_level);
end

% ���Ʋ���
figure();

subplot(4, 1, 1);
plot(y);
title('ԭʼ��������');

subplot(4, 1, 2);
size(autocorr_frames)
plot(autocorr_frames);
title('��ʱ����غ�������');

subplot(4, 1, 3);
plot(pitch_periods);
title('�������ڹ��Ʋ���');

subplot(4, 1, 4);
clipped_signal = reshape(clipped_frames, [], 1);
plot(clipped_signal);
title('����������Ĳ���');
