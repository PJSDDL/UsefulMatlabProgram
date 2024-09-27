I = imread('test.jpg');

R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);
R0 = double(R);
G0 = double(G);
B0 = double(B);

[N1, M1] = size(R);

Rlog = log(R0+1);
Rfft2 = fft2(R0);%

sigma1 = 128;
F1 = fspecial('gaussian', [N1,M1], sigma1);
Efft1 = fft2(double(F1));%

DR0 = Rfft2.* Efft1;%
DR = ifft2(DR0);%

DRlog = log(DR +1);%
Rr1 = Rlog - DRlog;%

sigma2 = 256;
F2 = fspecial('gaussian', [N1,M1], sigma2);
Efft2 = fft2(double(F2));

DR0 = Rfft2.* Efft2;
DR = ifft2(DR0);

DRlog = log(DR +1);
Rr2 = Rlog - DRlog;

sigma3 = 512;
F3 = fspecial('gaussian', [N1,M1], sigma3);
Efft3 = fft2(double(F3));

DR0 = Rfft2.* Efft3;
DR = ifft2(DR0);

DRlog = log(DR +1);
Rr3 = Rlog - DRlog;

Rr = (Rr1 + Rr2 +Rr3)/3;

a = 125;
II = imadd(R0, G0);
II = imadd(II, B0);
Ir = immultiply(R0, a);
C = imdivide(Ir, II);
C = log(C+1);

Rr = immultiply(C, Rr);
EXPRr = exp(Rr);
MIN = min(min(EXPRr));
MAX = max(max(EXPRr));
EXPRr = (EXPRr - MIN)/(MAX - MIN);
%EXPRr = adapthisteq(EXPRr);

Glog = log(G0+1);
Gfft2 = fft2(G0);

DG0 = Gfft2.* Efft1;
DG = ifft2(DG0);

DGlog = log(DG +1);
Gg1 = Glog - DGlog;


DG0 = Gfft2.* Efft2;
DG = ifft2(DG0);

DGlog = log(DG +1);
Gg2 = Glog - DGlog;


DG0 = Gfft2.* Efft3;
DG = ifft2(DG0);

DGlog = log(DG +1);
Gg3 = Glog - DGlog;

Gg = (Gg1 + Gg2 +Gg3)/3;

Ig = immultiply(G0, a);
C = imdivide(Ig, II);
C = log(C+1);

Gg = immultiply(C, Gg);
EXPGg = exp(Gg);
MIN = min(min(EXPGg));
MAX = max(max(EXPGg));
EXPGg = (EXPGg - MIN)/(MAX - MIN);
%EXPGg = adapthisteq(EXPGg);

%% 自己改
Blog = log(B0+1);
Bfft2 = fft2(B0);

sigma1 = 128;
F1 = fspecial('gaussian', [N1,M1], sigma1);
Efft1 = fft2(double(F1));

DB0 = Bfft2.* Efft1;
DB = ifft2(DB0);

DBlog = log(DB +1);
Br1 = Blog - DBlog;

sigma2 = 256;
F2 = fspecial('gaussian', [N1,M1], sigma2);
Efft2 = fft2(double(F2));

DB0 = Bfft2.* Efft2;
DB = ifft2(DB0);

DBlog = log(DB +1);
Br2 = Blog - DBlog;

sigma3 = 512;
F3 = fspecial('gaussian', [N1,M1], sigma3);
Efft3 = fft2(double(F3));

DB0 = Bfft2.* Efft3;
DB = ifft2(DB0);

DBlog = log(DB +1);
Br3 = Blog - DBlog;

Br = (Br1 + Br2 +Br3)/3;

a = 125;
II = imadd(R0, G0);
II = imadd(II, B0);
Ib = immultiply(B0, a);
C = imdivide(Ib, II);
C = log(C+1);

Br = immultiply(C, Br);
EXPRb = exp(Br);
MIN = min(min(EXPRb));
MAX = max(max(EXPRb));
EXPRb = (EXPRb - MIN)/(MAX - MIN);
%EXPRb = adapthisteq(EXPRb);

% B通道的处理方法与R和G类似，这里省略

result = cat(3, EXPRr, EXPGg, EXPRb);  
figure, imshow(result);