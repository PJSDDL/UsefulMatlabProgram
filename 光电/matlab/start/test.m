close all
clear all
clc
%{
x = 0.2:0.01:0.3;
y(1,:) = x;
y1(1,:) = x;
x = (x - 0.2)*10;
y(2,:) = (1-x).^4;
y(2,:) = 1 - y(2,:);
y(2,:) = round(y(2,:)*15+15);
hold on,plot(x,y(2,:));
%y1(2,:) = sqrt(1-x.^2);%x;
%y1(2,:) = round(fliplr(y1(2,:))*15+15);%round(y1(2,:)*30+30);
hold on,plot(x,y1(2,:),'r');
%}
x=-pi/2:0.01:pi/2;
y=cos(x);
plot(y);