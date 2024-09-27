clc
clear all
close all

[datawav, fs] = wavread('kicksnarecamtritamb .wav');

plot(datawav)

datawav = datawav(:, 1)' ;

%��ȡ��ͬ����ֵ���Ƶ
kickwav = datawav(1: 78010);
snarewav = datawav(81310: 94210);
camwav = datawav(98210: 147200);
triwav = datawav(147200: 203600);
tambwav = datawav(203600: 215600);

%����ƵFFT����
fft_in = snarewav;
fft_x = (1: length(fft_in)) / fs;
% plot(fft_x, fft_in)
% plot(fft_in)
fft_y = log(abs(fft(fft_in)));
fft_y = fft_y(1: floor(length(fft_y)/4));
fft_x = (1: length(fft_y)) / length(fft_y) * fs / 4;
figure
plot(fft_x, fft_y)


%----------Snare�˲�����----------%
fs = 44100;
N = 1001;
w1 = 600/fs*2*pi;    %��������Ƶ��

%�����˲���
h_ideal = ideallp(w1,N);

%������
h_window = hanning(N);

%�����˲�������
[freqz_freq, scale] = freqz(h_ideal.*h_window', [1], 1000, 'whole');
freqz_abs = abs(freqz_freq);

snareLowFreq = conv(fft_in, h_ideal.*h_window');
figure()
plot(snareLowFreq(1: 12000))

% sound(snareLowFreq(1: 12000), fs)
% pause(1)

%----------Snareģ��----------%
%----------�������Ե�Ƶ���Ҳ�
fs = 44100;
f1 = 180/fs;
x = (300/fs) * exp(- [1:11000] / 800);
SnareLow = [1:11000];

for i = 1:11000
    SnareLow(i) = sin(6.28 * (f1 + x(i)) * i);
end

figure
plot(SnareLow)

%----------����ɫ����
noise = randn(1,11000) / 4;
N = 11;
w1 = 10000/fs*2*pi;    %��������Ƶ��
w2 = 15000/fs*2*pi;    %��������Ƶ��
%�����˲���
h_ideal = ideallp(w1,N);
%������
h_window = hanning(N);
% %�����˲�������
% [freqz_freq, scale] = freqz(h_ideal.*h_window', [1], 1000, 'whole');
% freqz_abs = abs(freqz_freq);
% plot(freqz_abs)

noiseSnare = conv(noise, h_ideal.*h_window');
noiseSnare = noiseSnare(1: 11000);
noiseSnare = noiseSnare / max(noiseSnare);
% figure()
% plot(noiseSnare)

%----------ָ������
envelopSnare1 = [ones(1,500), exp(-[1:10500] / 1000)];
envelopSnare2 = exp(-[1:11000] / 7000);

%----------VCA
SnareSynth =  noiseSnare.*envelopSnare2 + SnareLow.*envelopSnare1;

%��һ��
SnareSynth = SnareSynth / max(SnareSynth);

%����ƵFFT����
fft_in_2 = SnareSynth;
fft_x = (1: length(fft_in_2)) / fs;
% plot(fft_x, fft_in)
% plot(fft_in)
fft_y = log(abs(fft(fft_in_2)));
fft_y = fft_y(1: floor(length(fft_y)/4));
fft_x = (1: length(fft_y)) / length(fft_y) * fs / 4;
figure
plot(fft_x, fft_y)

figure
subplot(2,1,1)
plot(fft_in)
subplot(2,1,2)
plot(SnareSynth)

sound(fft_in, fs)
pause(1)
sound(SnareSynth, fs)
pause(1)
