clc
close all

% 读取已有的浊语音
[y, fs] = wavread('10.wav');

% 设置参数
frame_length = 30; % 每帧的长度（毫秒）
frame_shift = 10; % 帧移（毫秒）
window_type = 'hamming'; % 窗函数类型

frame_len = round(frame_length * fs / 1000); % 将帧长度转换为样本数
frame_shift_len = round(frame_shift * fs / 1000); % 将帧移转换为样本数

% 分帧
num_frames = floor((length(y) - frame_len) / frame_shift_len) + 1;
frames = zeros(frame_len, num_frames);
for i = 1:num_frames
    start_idx = (i - 1) * frame_shift_len + 1;
    frames(:, i) = y(start_idx:start_idx+frame_len-1);
end

% 计算短时自相关函数
autocorr_frames = xcorr(frames, 'biased');
autocorr_frames = autocorr_frames(frame_len:end, :); % 只保留非负延迟部分

% 基音周期估计
[, pitch_periods] = max(autocorr_frames); % 基音周期为自相关函数最大值所在的延迟位置

% 中心削波  把幅度小的波形去掉
center_clipping_threshold = 0.35; % 中心削波阈值
clipped_frames = zeros(size(frames));
for i = 1:num_frames
    frame = frames(:, i);
    max_amp = max(abs(frame));
    center_clipping_level = center_clipping_threshold * max_amp;
    clipped_frames(:, i) = frame .* (abs(frame) > center_clipping_level);
end

% 绘制波形
figure();

subplot(4, 1, 1);
plot(y);
title('原始语音波形');

subplot(4, 1, 2);
size(autocorr_frames)
plot(autocorr_frames);
title('短时自相关函数波形');

subplot(4, 1, 3);
plot(pitch_periods);
title('基音周期估计波形');

subplot(4, 1, 4);
clipped_signal = reshape(clipped_frames, [], 1);
plot(clipped_signal);
title('中心削波后的波形');
