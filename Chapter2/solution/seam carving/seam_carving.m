clc;
clear;
origin =imread('seam.png');
Im = origin;
figure(1),imshow(Im);
for i = 1:100
    [m,n,c]=size(Im)
    %gray image to compute Energy in each pixels
    Gray=rgb2gray(Im);
    Gray = double(Gray);

    %sobel filter
    hx = [1,0,-1;2,0,-2;1,0,-1];
    hy = [1,2,1;0,0,0;-1,-2,-1];
    hx=hy';
    Iy=imfilter(Gray,hy,'replicate');
    Ix=imfilter(Gray,hx,'replicate');
    E=sqrt(Ix.^2+Iy.^2);
    %normalize
    max_value=max(max(E));
    E=E./max_value;

    [T, P] = dynamic_find(E);
    %back track
    [~, col] = min(T(m,:));
    %delete pixels
    for i=m:-1:1
        Im(i, 1: end-1,:) = Im(i,[1:col-1, col+1:end],:);
        col=col+P(i,col);
    end
    Im=Im(:,1:end-1,:);
    %Im
    figure(2),imshow(Im);
end