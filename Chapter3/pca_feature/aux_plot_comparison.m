% plot original images and reconstruction
% I used this script to generate images to presentation

clear all

datadir = 'dataset';
recdir = 'reconstructed';

a=140; % size of image
bigim = 255*ones(a*6 + 10*5,a*2*4 + 10*3); % add also some spaces between images
counter = 1; % lazy indexing
for i=1:6
    for j=1:4
        im = imread([datadir '/me_' num2str(counter) '.jpg']);
        im2 = imread([recdir '/me_' num2str(counter) '.jpg']);
        if size(im,3) == 3
            im = rgb2gray(im);
        end
        if size(im2,3) == 3
            im2 = rgb2gray(im2);
        end

        % write images on the right position in big image
        bigim((i-1)*a+1 + (i-1)*10:i*a + (i-1)*10,(j-1)*2*a+1 + (j-1)*10:j*2*a + (j-1)*10) = [im,im2];
        
        counter = counter + 1;
    end
end

imwrite(uint8(bigim),'compare.jpg')  
