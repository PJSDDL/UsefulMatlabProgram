clear;
clc;

fs = 44100;

signal = sin(6.28*262/fs*[1:2*fs])+sin(6.28*330/fs*[1:2*fs])+sin(6.28*392/fs*[1:2*fs]);
signal =  signal/3;
carrier = sin(6.28*1046/fs*[1:2*fs]);

wavwrite(signal,fs,'signal'); 
wavwrite(carrier,fs,'carrier'); 

%AM
AM_signal = (1+0.1*signal).*carrier;
wavwrite(AM_signal,fs,'AM'); 

%DSB
DSB_signal = 0.5*signal.*carrier;
plot(carrier);
wavwrite(DSB_signal,fs,'DSB');

%SSB
carrier_Q = imag(hilbert(carrier));
signal_Q = imag(hilbert(signal));
SSB_signal = carrier.*signal+carrier_Q.*signal_Q;
wavwrite(SSB_signal,fs,'SSB');

%PM
PM_signal = sin(6.28*1046/fs*[1:2*fs]+signal);
wavwrite(PM_signal,fs,'PM');

%FM
acc = 0;
for i = 1:2*fs
    acc = acc+signal(i);%积分
    signal_p(i) = acc;
end
signal_p = signal_p/max(signal_p);%归一化
signal_p = signal_p-mean(signal_p);%去除直流分量
FM_signal = sin(6.28*1046/fs*[1:2*fs]+signal_p);
wavwrite(FM_signal,fs,'FM');

fs