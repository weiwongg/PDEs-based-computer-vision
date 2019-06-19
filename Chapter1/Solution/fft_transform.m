clear all
close all
%loading image
RGB = imread('lena.png');
gray = rgb2gray(RGB);
doub = im2double(gray);
%padding image with zeros
powers = nextpow2(size(doub));
n_size = 2.^powers;
image = zeros(n_size);
rows = size(doub,1);
cols = size(doub,2);
image(1:rows,1:cols) = doub;
%DFT
ff = FFTIM(image);
%inverse DFT
im = invFFTIM(ff);
im = real(im);
figure(1)
imshow(doub)
title('Original Image')
figure(2)
imshow(im(1:rows,1:cols))
title('Reconstructed Image')
%computing the MSE
MSE = sum(sum((image(1:rows,1:cols)-doub).^2))/(rows*cols);
disp(['MSE is ', num2str(MSE)])


