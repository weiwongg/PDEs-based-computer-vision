im = imread('example_2.jpeg');
im = double(im);
sigma=2;    % scale parameter in Gaussian kernel
G=fspecial('gaussian',15,sigma); % Caussian kernel
Img_smooth=conv2(im,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.
figure(1)
imagesc(g,[0, 1]); axis off; axis equal; colormap(gray); hold on;


num_iters = 120;
dim_y = size(g,1);
dim_x = size(g,2);
delta_t = 20;
[dc, uc, lc] = aos(g(:), dim_x, dim_y, delta_t);
tran_g = g';
[dr, ur, lr] = aos(tran_g(:), dim_y, dim_x, delta_t);
phi = zeros(size(im));
phi(50:600,100) = 1;
phi(50:600,500) = 1;
phi(50,100:500) = 1;
phi(600,100:500) = 1;
mask = imfill(phi);
phi = bwdist(phi, 'euclidean') + bwdist(phi, 'euclidean') .* (-2) .*mask;
figure(2)
mesh(phi)
title('Initial level set function')
figure(3)
imagesc(im,[0, 255]); axis off; axis equal; colormap(gray); hold on;  [~, line] = contour(phi, [0,0], 'r'); line.LineWidth = 1.5;
title('Initial curve')

for iter = 1:num_iters
    if mod(iter-1, 10)==0
        for k = 1:10
            phi = redistance_phi(phi, [0,0.5]);
        end
    end
    tic
    phic = phi(:);
    phir = phi';
    phir = phir(:);
    phic = Thomas(dc, uc, lc, phic);
    phir = Thomas(dr, ur, lr, phir);
    phic = reshape(phic, [dim_y, dim_x]);
    phir = reshape(phir, [dim_x, dim_y]);
    phi = (phic + phir')/2;
    toc
    figure(4)
    imagesc(im,[0, 255]); axis off; axis equal; colormap(gray); hold on;  [~, line] = contour(phi, [0,0], 'r'); line.LineWidth = 1.5;
    title('Final curve of segmentation')
end

figure(5)
mesh(phi)
title('Final level set function')