clear;
clc;

fs = 44100;
f1 = 880/fs;
rate = 0.02;

time_seq = linspace(1, 1*fs, 1*fs);

phase = 880; %1相位等于 40000/44100Hz
tri_flag = 0;
y_reg = -20000;

%OSC1
y1 = [];
for i = time_seq
    if(tri_flag == 0)
        y_reg = y_reg + phase;
    else
        y_reg = y_reg - phase;
    end
    
    if(y_reg > 20000)
        tri_flag = 1;
    elseif(y_reg < -20000)
        tri_flag = 0;
    end
    
    y1 = [y1, y_reg];
end

%OSC2 moudulate by OSC1
y2 = [];
y2_phase = 0;
y2_reg = 0;
for i = time_seq
    if(y2_phase < 40000)  %累加相位
        y2_phase = y2_phase + phase + y1(i)*rate;
    else
        y2_phase = 0;
    end
    
    if(y2_phase < 20000)  %计算不同相位对应的波形
        y2_reg = y2_phase / 20000;
    else
        y2_reg = 2 - y2_phase / 20000;
    end
    
    y2 = [y2, y2_reg];
end

plot(y2)

wavwrite(y2, fs, 'FM');
sound(y2, fs);
