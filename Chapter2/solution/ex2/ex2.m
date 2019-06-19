im = imread('image.png');
im_mask = imread('image_mask.png');
im = rgb2gray(im);
im = im2double(im);
im_mask = rgb2gray(im_mask);
im_mask = im2double(im_mask);
%mask the pixels with 0 where there exist text
mask = abs(im_mask - im)<0.05;
noise = rand(size(im));
u  = mask.*im + (1-mask).*noise;
epsilon = 1.0;
dt = 0.7;
lambda = 1.0;
g = u;
figure(1)
imshow(im_mask)
title('Original Image')
for i = 1:500
    [Ix,Iy]=gradient(u);
    [Ixx, Ixy] = gradient(Ix);
    [Iyx, Iyy] = gradient(Iy);
    numerator = Ixx.*Iy.^2 - (Ixy + Iyx).*Ix.*Iy + Iyy.*Ix.^2 + epsilon * (Ixx + Iyy);
    denominator = (Ix.^2 + Iy.^2 + epsilon).^(1.5);
    u = u  - dt * mask.*(u - g) + lambda * dt * numerator./denominator;
    figure(2)
    imshow(u)
    title('Inpainted Image')
end
    