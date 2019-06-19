image = imread('mri.png');
image = rgb2gray(image);
image = im2double(image);
dim_y = size(image,1);
dim_x = size(image,2);
%origin image
figure(1)
imshow(image)
title('Original Image')
%implementing explicit scheme K = 0.01, dt = 0.25
im = image;
K = 0.01;
dt = 0.25;
num_iters = 200;
for i = 1:num_iters
    [Ix, Iy] = gradient(im);
    C = 1./(1 + (Ix.^2 + Iy.^2)/(K^2));
    [Ixx, ~] = gradient(Ix.*C);
    [~, Iyy] = gradient(Iy.*C);
    im = im + dt * (Ixx + Iyy);
    figure(2)
    imshow(im)
    title('Explicit: K = 0.01, dt = 0.25, iters = 200')
end

%implementing semi-implicit scheme K = 0.01, dt = 5
im = image;
K = 0.01;
dt = 5;
num_iters = 10;
for i = 1:num_iters
    [Ix, Iy] = gradient(im);
    C = 1./(1 + (Ix.^2 + Iy.^2)/K);
    size(C)
    [dc, uc, lc] = aos(C(:), dim_x, dim_y, dt);
    tran_C = C';
    [dr, ur, lr] = aos(tran_C(:), dim_y, dim_x, dt);
    imc = im(:);
    imr = im';
    imr = imr(:);
    imc = Thomas(dc, uc, lc, imc);
    imr = Thomas(dr, ur, lr, imr);
    imc = reshape(imc, [dim_y, dim_x]);
    imr = reshape(imr, [dim_x, dim_y]);
    im = (imc + imr')/2;
    figure(3)
    imshow(im)
    title('semi-implicit: K = 0.01, dt = 5, iters = 10')
end
%implementing explicit scheme K = 0.1, dt = 5
im = image;
K = 0.1;
dt = 5;
num_iters = 200;
for i = 1:num_iters
    [Ix, Iy] = gradient(im);
    C = 1./(1 + (Ix.^2 + Iy.^2)/K);
    [Ixx, ~] = gradient(Ix.*C);
    [~, Iyy] = gradient(Iy.*C);
    im = im + dt * (Ixx + Iyy);
    figure(4)
    imshow(im)
    title('Explicit: K = 0.1, dt = 5')
end
%implementing semi-implicit scheme K = 0.01, dt = 5
im = image;
K = 0.1;
dt = 5;
num_iters = 200;
for i = 1:num_iters
    [Ix, Iy] = gradient(im);
    C = 1./(1 + (Ix.^2 + Iy.^2)/K);
    size(C)
    [dc, uc, lc] = aos(C(:), dim_x, dim_y, dt);
    tran_C = C';
    [dr, ur, lr] = aos(tran_C(:), dim_y, dim_x, dt);
    imc = im(:);
    imr = im';
    imr = imr(:);
    imc = Thomas(dc, uc, lc, imc);
    imr = Thomas(dr, ur, lr, imr);
    imc = reshape(imc, [dim_y, dim_x]);
    imr = reshape(imr, [dim_x, dim_y]);
    im = (imc + imr')/2;
    figure(5)
    imshow(im)
    title('semi-implicit: K = 0.1, dt = 5, iters = 200')
end
