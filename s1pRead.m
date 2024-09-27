clear;
clc;
close all;

x = importdata('1-1.s1p');
plot(x(:,1),20*log(x(:,2)/max(x(:,2))));

figure;
x = importdata('1-2.s1p');
plot(x(:,1),20*log(x(:,2)/max(x(:,2))));

figure;
x = importdata('1-3.s1p');
plot(x(:,1),20*log(x(:,2)/max(x(:,2))));