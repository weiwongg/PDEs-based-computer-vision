clc
close all
clear all
RGB=imread('lena.png');
I=rgb2gray(RGB); % convert the image to grey 
I = im2double(I);
gf =fspecial('gaussian',5,2);
sum(sum(gf))
I_sp = conv2(I,gf,'same');
figure(1)
imshow(I_sp);
title('filtering in space domain')
rows = size(I,1)
cols = size(I,2)
filter = zeros(rows,cols);
filter(1:5,1:5) = gf;
I_fq = ifft2(fft2(I).*fft2(filter));
figure(2)
imshow(I_fq);
title('filtering in frequencies domain')
MSE = sum(sum((I_fq-I_sp).^2))/(rows*cols);
disp(['MSE is ', num2str(MSE)])