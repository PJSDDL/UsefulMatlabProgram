N = 5;
wc = pi/4;

h_ideal = ideallp(wc,N);
h_rec = rectwin(N); 
h_tri = triang(N);
h_han = hann(N);

h_ideal.*h_tri'

subplot(3,3,1);
plot(h_ideal.*h_rec');
subplot(3,3,2);
plot(h_ideal.*h_tri');
subplot(3,3,3);
plot(h_ideal.*h_han');

[freqz_rec,w] = freqz(h_ideal.*h_rec',[1],1000,'whole');
[freqz_tri,w] = freqz(h_ideal.*h_tri',[1],1000,'whole');
[freqz_han,w] = freqz(h_ideal.*h_han',[1],1000,'whole');

freqz_rec_abs = abs(freqz_rec);
freqz_tri_abs = abs(freqz_tri);
freqz_han_abs = abs(freqz_han);

subplot(3,3,4);
plot(w,20*log10(freqz_rec_abs/max(freqz_rec_abs)));
subplot(3,3,5);
plot(w,20*log10(freqz_tri_abs/max(freqz_tri_abs)));
subplot(3,3,6);
plot(w,20*log10(freqz_han_abs/max(freqz_han_abs)));

subplot(3,3,7);
plot(w,phase(freqz_rec));
subplot(3,3,8);
plot(w,phase(freqz_tri));
subplot(3,3,9);
plot(w,phase(freqz_han));