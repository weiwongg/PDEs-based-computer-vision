function [Xim] = from_X_to_image(X, rows, cols,patch_size)

    Xim = zeros(patch_size*rows,patch_size*cols);
    t = 1; % sorry, I am too lazy to derive t = some_formula(i,j)
    for i=1:rows
        for j=1:cols
            Xim((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size) = reshape(X(:,t),patch_size,patch_size);
            t = t + 1; % my lazy counter :)
        end
    end
end

