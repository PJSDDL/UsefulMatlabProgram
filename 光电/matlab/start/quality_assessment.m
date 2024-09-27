function quality_assessment(img)
    gray_img = rgb2gray(img);
    
    % ��ֵ�����ȣ�
    aver_enhanced = mean2(gray_img);
    
    % ��׼��Աȶȣ�
    std_enhanced = std2(gray_img);
    
    % ������
    img_cl = img_clarity(gray_img);
    
    % ��ʾ
    display(['���Ⱦ�ֵ: ',num2str(aver_enhanced)]);
    display(['��׼��Աȶȣ�: ',num2str(std_enhanced)]);
    display(['������: ',num2str(img_cl)]);
end

%% ͼ�������ȼ��㺯��
function ic = img_clarity(img_in)
% img_in������Ҷ�ͼ��
% ic: ͼ��������

img_in = double(img_in);
[M,N] = size(img_in);

h = fspecial('sobel');

gx = imfilter(img_in,h,'replicate','same');   
gy = imfilter(img_in,h','replicate','same'); 

% for i=1:M
%     for j=1:N
%         gxy(i,j) = abs(sqrt(gx(i,j)*gx(i,j) + gy(i,j)*gy(i,j)));  
%     end
% end
gxy = abs(sqrt(gx.^2+gy.^2));

ic = mean2(gxy);
end