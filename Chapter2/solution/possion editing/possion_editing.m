target_im = double(imread('target.jpg'));
source_im = double(imread('source.png'));
target_im = imresize(target_im, [400,800]);
dims_target = size(target_im);
dims_src = size(source_im);
%Laplacian operator
lapfilter = [0, 1, 0; 1, -4, 1; 0, 1, 0];
div_R = conv2(source_im(:,:,1), double(lapfilter), 'same');
div_G = conv2(source_im(:,:,2), double(lapfilter), 'same');
div_B = conv2(source_im(:,:,3), double(lapfilter), 'same');

%location of pasting 
des_y = 20;
des_x = 500;
%initial f
f = target_im(des_y:des_y+dims_src(1) - 1,des_x:des_x+dims_src(2) -1,:);
origin = f;
%filter for Jacobi iteration
jacobifilter = [0, 1, 0; 1, 0, 1; 0, 1, 0];
figure(1)
imshow(uint8(target_im));
figure(2)
target_im(des_y:des_y+dims_src(1)-1,des_x:des_x+dims_src(2)-1,:) = source_im;
imshow(uint8(target_im));

%create template which decay on edges, in interior points it is 1.0
temp = create_decay_temp(dims_src(1), dims_src(2));

%Jacobi iteration main function
for n = 1:10000
    g = conv2(f(:,:,1),double(jacobifilter),'same');
    f(:,:,1) = (g - div_R)/4.0;
    g = conv2(f(:,:,2),double(jacobifilter),'same');
    f(:,:,2) = (g - div_G)/4.0;
    g = conv2(f(:,:,3),double(jacobifilter),'same');
    f(:,:,3) = (g - div_B)/4.0;
    %paste f to target image
    f = temp .* f + (1-temp).*origin;
    target_im(des_y:des_y+dims_src(1)-1,des_x:des_x+dims_src(2)-1,:) = f;
    figure(3)
    imshow(uint8(target_im));
end