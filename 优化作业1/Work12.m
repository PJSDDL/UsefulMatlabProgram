function Work12
    clc
    
    %��ʼ��
    x1_start = 10;
    x2_start = 10;

    x1 = x1_start;
    x2 = x2_start;
    
    x_trace = [];
    
    %��ʼ����
    for i = 1:10
        %�ݶ�
        [dy1, dy2] = df(x1, x2);
        
        %x = x - a * df
        %�󵼼����a��ֵ
        a = (dy1 + 0.5*dy2 + x1*dy1 + 2*x2*dy2)/(dy1*dy1 + 2*dy2*dy2);
        
        %����x��ֵ
        x1 = x1 - a * dy1;
        x2 = x2 - a * dy2;
        
        x_trace = [x_trace; [x1, x2]];
    end
    
    x_trace
    scatter(x_trace(:,1), x_trace(:,2))
    xlim([-1,1]);
    ylim([-1,1]);
end

function [y] = f(x1, x2)
    y = x1 + 0.5*x2 + 0.5*x1*x1 + x2*x2 + 3;
end

function [y1, y2] = df(x1, x2)
    y1 = 1 + x1;
    y2 = 0.5 + 2*x2;
end













