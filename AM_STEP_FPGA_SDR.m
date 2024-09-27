loTable = [1,2,1,0];
signal = sin(1.001*6.2831853*0.75*[1:8192]);

for i=0:10
    loTable = horzcat(loTable,loTable);
end

%混频
mixed_signal = loTable(1:8192).*signal;
%滤波
filtered_signal = conv(mixed_signal,[25,52,71,71,52,25]);
filtered_signal = filtered_signal/256;

%画波形
plot(filtered_mix_signal)
fft_loTable = fft(filtered_mix_signal);
plot(log(abs(fft_loTable)+eps))

%重采样
for i=1:81
    output(i) = filtered_signal(i*100);
end

%画波形
%plot(output)

