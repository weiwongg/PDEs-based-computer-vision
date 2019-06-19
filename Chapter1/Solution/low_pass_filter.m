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
n_rows = rows+5-1;
n_cols = cols+5-1;
image = zeros(n_rows,n_cols);
image(1:rows,1:cols) = I;
filter = zeros(n_rows,n_cols);
filter(1:5,1:5) = gf;
I_fq = ifft2(fft2(image).*fft2(filter));
I_fq = I_fq(3:rows+2,3:cols+2);
figure(2)
imshow(I_fq);
title('filtering in frequencies domain')
MSE = sum(sum((I_fq-I_sp).^2))/(rows*cols);
disp(['MSE is ', num2str(MSE)])

