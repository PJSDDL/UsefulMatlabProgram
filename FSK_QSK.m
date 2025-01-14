clc;
clear;

n=3000;
N=50;
b=randint(1,n);
f1=1;f2=2;
t=0:1/30:1-1/30;

%ASK
sa1=sin(2*pi*f1*t);
E1=sum(sa1.^2);
sa1=1.414*sa1/sqrt(E1); %unit energy 
sa0=0*sin(2*pi*f1*t);
%FSK
sf0=sin(2*pi*f1*t);
E=sum(sf0.^2);
sf0=1.414*sf0/sqrt(E);
sf1=sin(2*pi*f2*t);
E=sum(sf1.^2);
sf1=1.414*sf1/sqrt(E);
%PSK
sp0=-1.414*sin(2*pi*f1*t)/sqrt(E1);
sp1=1.414*sin(2*pi*f1*t)/sqrt(E1);

%MODULATION
ask=[];psk=[];fsk=[];
for i=1:n
    if b(i)==1
        ask=[ask sa1];
        psk=[psk sp1];
        fsk=[fsk sf1];
    else
        ask=[ask sa0];
        psk=[psk sp0];
        fsk=[fsk sf0];
    end
end
figure(1)
subplot(411)
stairs(0:10,[b(1:10) b(10)],'linewidth',1.5)
axis([0 10 -0.5 1.5])
title('Message Bits');grid on
subplot(412)
tb=0:1/30:10-1/30;
plot(tb, ask(1:10*30),'b','linewidth',1.5)
title('ASK Modulation');grid on
subplot(413)
plot(tb, fsk(1:10*30),'r','linewidth',1.5)
title('FSK Modulation');grid on
subplot(414)
plot(tb, psk(1:10*30),'k','linewidth',1.5)
title('PSK Modulation');grid on
xlabel('Time');ylabel('Amplitude')

% AWGN
for snr=0:N
    askn=awgn(ask,10/N*snr);
    pskn=awgn(psk,10/N*snr);
    fskn=awgn(fsk,10/N*snr);

    %DETECTION
    A=[];F=[];P=[];
    for i=1:n
        %ASK Detection
        if sum(sa1.*askn(1+30*(i-1):30*i))>1.414*0.5
            A=[A 1];
        else
            A=[A 0];
        end
        %FSK Detection
        if sum(sf1.*fskn(1+30*(i-1):30*i))>sum(sf0.*fskn(1+30*(i-1):30*i))
            F=[F 1];
        else
            F=[F 0];
        end
        %PSK Detection
        if sum(sp1.*pskn(1+30*(i-1):30*i))>0
            P=[P 1];
        else
            P=[P 0];
        end
    end

    %BER
    errA=0;errF=0; errP=0;
    for i=1:n
        if A(i)==b(i)
            errA=errA;
        else
            errA=errA+1;
        end
        if F(i)==b(i)
            errF=errF;
        else
            errF=errF+1;
        end
        if P(i)==b(i)
            errP=errP;
        else
            errP=errP+1;
        end
    end
    BER_A(snr+1)=errA/n;
    BER_F(snr+1)=errF/n;
    BER_P(snr+1)=errP/n;
end
snr = 10/N*(0:N);
snr = snr/10;
snr = 10.^snr;

ideal_A = 0.5*erfc(sqrt(snr/4));
ideal_F = 0.5*erfc(sqrt(snr/2));
ideal_P = 0.5*erfc(sqrt(snr/1));

figure(2)
subplot(411)
stairs(0:10,[b(1:10) b(10)],'linewidth',1.5)
axis([0 10 -0.5 1.5]);grid on
title('Received signal after AWGN Channel')
subplot(412)
tb=0:1/30:10-1/30;
plot(tb, askn(1:10*30),'b','linewidth',1.5)
title('Received ASK signal');grid on
subplot(413)
plot(tb, fskn(1:10*30),'r','linewidth',1.5)
title('Received FSK signal');grid on
subplot(414)
plot(tb, pskn(1:10*30),'k','linewidth',1.5)
title('Received PSK signal');grid on

figure(3)
semilogy(10/N*(0:N),BER_A, 'b','linewidth',2)
title('BER Vs SNR')
grid on;
hold on
semilogy(10/N*(0:N),BER_F,'r','linewidth',2)
semilogy(10/N*(0:N),BER_P, 'g','linewidth',2)
xlabel('Eo/No(dB)')
semilogy(10/N*(0:N),ideal_A, 'k','linewidth',2)
semilogy(10/N*(0:N),ideal_F, 'k','linewidth',2)
semilogy(10/N*(0:N),ideal_P, 'k','linewidth',2)
ylabel('BER')
hold off
legend('ASK','FSK','PSK','ideal_A','ideal_F','ideal_P');


%------------------------------------------------%
%------------------------------------------------%
%------------------------------------------------%

figure(4);
subplot(2,2,1)
ask_fft = fft(ask);
ask_abs = abs(ask_fft);
ask_abs = log(ask_abs/max(ask_abs));
plot(ask_abs);
title('ASK FFT')
subplot(2,2,2)
fsk_fft = fft(fsk);
fsk_abs = abs(fsk_fft);
fsk_abs = log(fsk_abs/max(fsk_abs));
plot(fsk_abs);
title('FSK FFT')
subplot(2,2,3)
psk_fft = fft(psk);
psk_abs = abs(psk_fft);
psk_abs = log(psk_abs/max(psk_abs));
plot(psk_abs);
title('PSK FFT')
subplot(2,2,4)
psk_2_fft = fft(psk.^2);
psk_2_abs = abs(psk_2_fft);
psk_2_abs = log(psk_2_abs/max(psk_2_abs));
plot(psk_2_abs,'x', 'MarkerSize',10);
title('PSK^2 FFT')

%------------------------------------------------%
%------------------------------------------------%
%------------------------------------------------%


%干扰信号
noise_1 = 0.1*sin(2*pi*f1/30*[1:30*n]);  %定频干扰
E1=sum(noise_1.^2);
noise_1=1.414*noise_1/sqrt(E1/n); %unit energy 

max(noise_1)

noise_2 = 0.1*sin(2*pi*f1/30*[1:30*n] + 0.01*[1:30*n].*[1:30*n]);  %线性调频干扰
E2=sum(noise_2.^2);
noise_2=1.414*noise_2/sqrt(E1/n); %unit energy 

figure(5);
subplot(2,2,1)
plot(noise_1);
title('定频信号')
subplot(2,2,2)
plot(noise_2);
title('线性调频信号')
subplot(2,2,3)
noise_1_fft = fft(noise_1.^2);
noise_1_abs = abs(noise_1_fft);
noise_1_abs = log(noise_1_abs/max(noise_1_abs));
plot(noise_1_abs,'x', 'MarkerSize',10);
title('定频信号频谱')
subplot(2,2,4)
noise_2_fft = fft(noise_2);
noise_2_abs = abs(noise_2_fft);
noise_2_abs = log(noise_2_abs/max(noise_2_abs));
plot(noise_2_abs);
title('线性调频信号频谱')

% 使用信号1进行干扰
for snr=0:N
    %分贝换算为幅度
    k = 10/N*snr/20;
    k = 10^k;
    
    askn=awgn(ask,10)+k*noise_1;
    pskn=awgn(psk,10)+k*noise_1;
    fskn=awgn(fsk,10)+k*noise_1;

    %DETECTION
    A=[];F=[];P=[];
    for i=1:n
        %ASK Detection
        if sum(sa1.*askn(1+30*(i-1):30*i))>1.414*0.5
            A=[A 1];
        else
            A=[A 0];
        end
        %FSK Detection
        if sum(sf1.*fskn(1+30*(i-1):30*i))>sum(sf0.*fskn(1+30*(i-1):30*i))
            F=[F 1];
        else
            F=[F 0];
        end
        %PSK Detection
        if sum(sp1.*pskn(1+30*(i-1):30*i))>0
            P=[P 1];
        else
            P=[P 0];
        end
    end

    %BER
    errA=0;errF=0; errP=0;
    for i=1:n
        if A(i)==b(i)
            errA=errA;
        else
            errA=errA+1;
        end
        if F(i)==b(i)
            errF=errF;
        else
            errF=errF+1;
        end
        if P(i)==b(i)
            errP=errP;
        else
            errP=errP+1;
        end
    end
    BER_A(snr+1)=errA/n;
    BER_F(snr+1)=errF/n;
    BER_P(snr+1)=errP/n;
end
snr = 10/N*(0:N);
snr = snr/10;
snr = 10.^snr;

ideal_A = 0.5*erfc(sqrt(snr/4));
ideal_F = 0.5*erfc(sqrt(snr/2));
ideal_P = 0.5*erfc(sqrt(snr/1));

figure(6)
semilogy(10/N*(0:N),BER_A, 'b','linewidth',2)
title('BER Vs JNR')
grid on;
hold on
semilogy(10/N*(0:N),BER_F,'r','linewidth',2)
semilogy(10/N*(0:N),BER_P, 'g','linewidth',2)
xlabel('JER(dB)')
ylabel('BER')
hold off
legend('ASK','FSK','PSK');

% 使用信号2进行干扰
for snr=0:N
    %分贝换算为幅度
    k = 10/N*snr/20;
    k = 10^k;
    
    askn=awgn(ask,10)+k*noise_2;
    pskn=awgn(psk,10)+k*noise_2;
    fskn=awgn(fsk,10)+k*noise_2;

    %DETECTION
    A=[];F=[];P=[];
    for i=1:n
        %ASK Detection
        if sum(sa1.*askn(1+30*(i-1):30*i))>1.414*0.5
            A=[A 1];
        else
            A=[A 0];
        end
        %FSK Detection
        if sum(sf1.*fskn(1+30*(i-1):30*i))>sum(sf0.*fskn(1+30*(i-1):30*i))
            F=[F 1];
        else
            F=[F 0];
        end
        %PSK Detection
        if sum(sp1.*pskn(1+30*(i-1):30*i))>0
            P=[P 1];
        else
            P=[P 0];
        end
    end

    %BER
    errA=0;errF=0; errP=0;
    for i=1:n
        if A(i)==b(i)
            errA=errA;
        else
            errA=errA+1;
        end
        if F(i)==b(i)
            errF=errF;
        else
            errF=errF+1;
        end
        if P(i)==b(i)
            errP=errP;
        else
            errP=errP+1;
        end
    end
    BER_A(snr+1)=errA/n;
    BER_F(snr+1)=errF/n;
    BER_P(snr+1)=errP/n;
end

figure(7)
semilogy(10/N*(0:N),BER_A, 'b','linewidth',2)
title('BER Vs JNR')
grid on;
hold on
semilogy(10/N*(0:N),BER_F,'r','linewidth',2)
semilogy(10/N*(0:N),BER_P, 'g','linewidth',2)
xlabel('JER(dB)')
ylabel('BER')
hold off
legend('ASK','FSK','PSK');

figure(8)
plot(askn)

