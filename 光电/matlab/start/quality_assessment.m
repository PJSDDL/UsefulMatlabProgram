function quality_assessment(img)
    gray_img = rgb2gray(img);
    
    % 均值（亮度）
    aver_enhanced = mean2(gray_img);
    
    % 标准差（对比度）
    std_enhanced = std2(gray_img);
    
    % 清晰度
    img_cl = img_clarity(gray_img);
    
    % 显示
    display(['亮度均值: ',num2str(aver_enhanced)]);
    display(['标准差（对比度）: ',num2str(std_enhanced)]);
    display(['清晰度: ',num2str(img_cl)]);
end

%% 图像清晰度计算函数
function ic = img_clarity(img_in)
% img_in：输入灰度图像
% ic: 图像清晰度

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