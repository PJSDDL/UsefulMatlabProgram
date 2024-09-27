clc
clear

%-------初始参数------
% 天线电感  uH  不参与优化
L1 = 264;
% 天线双联并联电容  pF
Cp = 10;
% 本振电感  uH
L2 = 10;
% 垫整电容  pF
Ct = 10;
% 本振双联并联电容  pF
Co = 10;
% 等容双联容值 pF
C  = 1:400;

%-------计算出高低端频率对应的电容值------
Cmin = 1e6/(1.605*1.605*6.28*6.28*L1)
Cmax = 1e6/(0.525*0.525*6.28*6.28*L1)

%-------1 、设定L2 Cp初始值 ------
for L2 = 10:L1
    for Cp = 5:50 
        %-------2 、解二次方程，求Ct Co------
        %-------频率单位Hz-------
        Kmax = 1e-6 * L2 * (456000*6.28 + 1e9/sqrt(L1*(Cmax+Cp)))^2;
        Kmin = 1e-6 * L2 * (456000*6.28 + 1e9/sqrt(L1*(Cmin+Cp)))^2;  
        
        a = 1; b = (Cmin + Cmax)*1e-12; 
        c = Cmin*Cmax*1e-24 + 1e-12*(Cmin-Cmax)/(Kmin-Kmax); % 二次方程系数
       
        if(b^2 - 4*a*c < 0)
            continue
        end
        
        Co = (-b + sqrt(b^2 - 4*a*c)) / (2*a); % 求Co
        
        Ct = 1 / ( Kmax - 1/(1e-12*Cmax + Co) ); % 求Ct
        
        Co = Co*1e12; % 单位转换
        Ct = Ct*1e12;

        %-------3、性能评价------
        % 计算频率差 单位MHz
        CL = 1./(1/Ct + 1./(Co+C)); % 本振电容值
        Ci = Cp + C; % 天线电容值
        fL = 1000./(6.28*sqrt(L2*CL));
        fi = 1000./(6.28*sqrt(L1*Ci));

        %  计算当前误差，采用均方误差公式
        freq_err = fL-fi-0.456;
        sum(abs(freq_err));
        err = sum(abs(freq_err))/length(C);

        % 满足条件停止算法
        if(err < 0.003)
            err
            Co 
            Cp
            Ct
            L2
            
%             解除注释可以计算特定电容电感值的频率差
%             Co = 220+33
%             Cp = 220
%             Ct = 660
%             L2 = 114
            
            % 画出当前本振与天线回路频率差
            % 频率差 MHz
            CL = 1./(1/Ct + 1./(Co+C)); % 本振电容值
            Ci = Cp+C; % 天线电容值
            fL = 1000./(6.28*sqrt(L2*CL));
            fi = 1000./(6.28*sqrt(L1*Ci));

            close all
            figure(2)
            plot(fL-fi)

            'Ctrl+C终止程序'
            pause;
        end
    end
end

'未找到值，请改变L1后再尝试'

