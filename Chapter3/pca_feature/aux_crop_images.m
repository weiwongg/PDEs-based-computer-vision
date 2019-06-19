% I used this script for cropping images from webcam
% I also make these images smaller and BW
% maybe you will find this code usefull

clear all

listing = dir('original');
listing = listing(3:end);

for i=1:length(listing)
    im = imread(['original/' listing(i).name]);
    if size(im,3) == 3
        im = rgb2gray(im);
    end

    im = im(11:710,291:1280-290); % take only part of image with my face
    im = imresize(im,0.2); % make it smaller
    imwrite(im,['dataset/me_' num2str(i) '.jpg'])    
end