function [X] = from_image_to_X(Xim,patch_size)
    T = (size(Xim,1)/patch_size)*(size(Xim,2)/patch_size); % I assume that width/patch_size and height/patch_size are integers

    X = zeros(patch_size*patch_size,T);
    t = 1; % sorry, I am too lazy to derive t = some_formula(i,j)
    for i=1:size(Xim,1)/patch_size
        for j=1:size(Xim,2)/patch_size
            subimage = Xim((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size);
            X(:,t) = reshape(subimage,patch_size*patch_size,1);
            t = t + 1; % my lazy counter :)
        end
    end
end

