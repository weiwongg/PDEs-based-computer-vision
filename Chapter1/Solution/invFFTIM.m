function im = invFFTIM(ff)
im = invFFT2D(ff);
im = invFFT2D(im');
im = im'/(size(ff,1)*size(ff,2));
end 

function fx = invFFT2D(image)
nx = size(image,1);
ny = size(image,2);
if nx == 1
    fx = image;
    return;
end
fx_even = invFFT2D(image(1:2:end,:));
fx_odd = invFFT2D(image(2:2:end, :));

k = [0:1:nx/2-1]';
factor = repmat(exp(2j*pi*k/(nx)), 1, ny);

fx = [fx_even + factor .* fx_odd; fx_even - factor .* fx_odd];
end 