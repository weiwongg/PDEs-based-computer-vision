clear all;
close all;
clc;

img=imread('lena.png');
img=rgb2gray(img);
[m n]=size(img);
figure(1)
gf =fspecial('gaussian',5,2);
img_f = conv2(img,gf,'same');
imshow(mat2gray(img_f));
%windows size is 5*5
n_img = bf(img,2,2,25);
figure(2);
imshow(n_img);
figure(3);
%windows size is 21*21
n_img1 = bf(img,10,1000,50);
imshow(n_img1)
figure(4);
%windows size is 21*21
n_img2 = bf(img,10,2,50);
imshow(n_img2)
