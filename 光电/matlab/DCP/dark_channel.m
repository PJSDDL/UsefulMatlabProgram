function Idark = dark_channel(Iin,r)
% ���ܣ���������ͼ��İ�ͨ��
% ���룺Iin,����ͼ�񣨲�ɫ��double��
%       r����Сֵ�˲�����뾶
% �����Idark��ͼ��ͨ����double��

%% 
% ��ʼ��
Rin = Iin(:,:,1);
Gin = Iin(:,:,2);
Bin = Iin(:,:,3);
% [row,col] = size(Rin);

% ��RGB��Сͨ��
Imin = min(Rin,min(Gin,Bin));

% tic;
% Idark = MinFilter(Imin,row,col,r);
Idark = ordfilt2(Imin,1,ones(2*r+1,2*r+1)); % matlab�Դ�����Сֵ�˲�
% toc;

end

%% �Զ�����Сֵ�˲�
function i_out = MinFilter(i_in,row,col,r)
    i_ext = ReflectEdge(i_in,r);
    i_out = i_in;
    for i=1+r:row+r
        for j=1+r:col+r
            i_near = i_ext(i-r:i+r,j-r:j+r);  % ȡ��ǰ���ص�����
            min_near = min(min(i_near));
            
            i_out(i-r,j-r) = min_near;      %��Сֵ  
        end
    end
 
end
