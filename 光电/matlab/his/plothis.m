%% 绘制直方图
close all
clear all
clc
%读取源图像
imageres = imread('speedtestsmall7.jpg');

imagegray=rgb2gray(imageres); 
imhist(imagegray); 