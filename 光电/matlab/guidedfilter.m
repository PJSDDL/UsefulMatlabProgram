function q = guidedfilter(I, p, r, eps)  
%   GUIDEDFILTER   O(1) time implementation of guided filter.  
%  
%   - guidance image: I (should be a gray-scale/single channel image)  
%   - filtering input image: p (should be a gray-scale/single channel image)  
%   - local window radius: r  
%   - regularization parameter: eps  
  
[hei, wid] = size(I);  
N = boxfilter(ones(hei, wid), r) ;% the size of each local patch; N=(2r+1)^2 except for boundary pixels.  
  
mean_I = boxfilter(I, r) ./ N;  
%mean_I = boxmean(I, r);
mean_p = boxfilter(p, r) ./ N;  
%mean_p = boxmean(p, r);
mean_Ip = boxfilter(I.*p, r) ./ N; 
%mean_Ip = boxmean(I.*p, r);
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.  
  
mean_II = boxfilter(I.*I, r) ./ N;  
%mean_II = boxmean(I.*I, r);
var_I = mean_II - mean_I .* mean_I;  
  
a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;  
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;  
figure,imshow(a,[0 max(max(a))]); 
figure,imshow(b,[0 max(max(b))]); 
mean_a = boxfilter(a, r) ./ N;  
mean_b = boxfilter(b, r) ./ N;  
  
q = mean_a .* I + mean_b; % Eqn. (8) in the paper; 

end  