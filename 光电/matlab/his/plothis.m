%% ����ֱ��ͼ
close all
clear all
clc
%��ȡԴͼ��
imageres = imread('speedtestsmall7.jpg');

imagegray=rgb2gray(imageres); 
imhist(imagegray); 