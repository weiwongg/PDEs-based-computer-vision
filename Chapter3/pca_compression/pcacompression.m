clear all

m = 15; % PCA parameter - dimension of vector subspace
patch_size = 128; % 8,16,32,64,128 (don't be crazy: 512,1024)

im = imread(['illia.jpg']);

% separate RGB
Xim{1} = double(im(:,:,1))/255;
Xim{2} = double(im(:,:,2))/255;
Xim{3} = double(im(:,:,3))/255;

% for fun: plot rgb
if false
    figure
    hold on
    subplot(1,3,1)
    imshow(Xim{1});
    subplot(1,3,2)
    imshow(Xim{2});
    subplot(1,3,3)
    imshow(Xim{3});
    hold off
end

% create dataset - small squares [patch_size x patch_size] and construct matrix X
X = cell(1,3);
for rgb_idx = 1:3 % for each channel
    X{rgb_idx} = from_image_to_X(Xim{rgb_idx},patch_size);
end

% for fun (and for presentation): plot the subimages
if false
    rows = size(Xim{1},1)/patch_size;
    cols = size(Xim{1},2)/patch_size;
    bigim = 255*ones(patch_size*rows + 5*(rows-1),patch_size*cols + 5*(cols-1));
    for i=1:rows
        for j=1:cols
            subimage = Xim{1}((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size);
            bigim((i-1)*patch_size+1 + (i-1)*5:i*patch_size + (i-1)*5,(j-1)*patch_size+1 + (j-1)*5:j*patch_size + (j-1)*5) = subimage;
        end
    end
    
    imwrite(uint8(255*bigim),'subimages.jpg')
end

% compute PCA
Q = cell(1,3);
lambdas = cell(1,3);
Xmean = cell(1,3);
for rgb_idx = 1:3 % for each channel
    [Q{rgb_idx}, lambdas{rgb_idx}, Xmean{rgb_idx}] = mypca(X{rgb_idx},m);
end

% for fun - store and plot eigenfaces
if true
    mymean = zeros(patch_size,patch_size,3);
    mymean(:,:,1) = reshape(Xmean{1},patch_size,patch_size);
    mymean(:,:,2) = reshape(Xmean{2},patch_size,patch_size);
    mymean(:,:,3) = reshape(Xmean{3},patch_size,patch_size);
    imwrite(uint8(255*mymean),'mean.jpg');
    
    for i=1:m
        eigenface = cell(1,3);
        for rgb_idx = 1:3
            eigenface{rgb_idx} = Q{rgb_idx}(:,i);
            
            % map to [0,255]
            mymin = min(eigenface{rgb_idx});
            mymax = max(eigenface{rgb_idx});
            a_tr = 255/(mymax - mymin);
            b_tr = -a_tr*mymin;
            eigenface{rgb_idx} = a_tr*eigenface{rgb_idx} + b_tr;
        end
        
        % save
        bigeigenface = zeros(patch_size,patch_size,1);
        bigeigenface(:,:,1) = reshape(eigenface{1},patch_size,patch_size);
        bigeigenface(:,:,2) = reshape(eigenface{2},patch_size,patch_size);
        bigeigenface(:,:,3) = reshape(eigenface{3},patch_size,patch_size);
        imwrite(uint8(bigeigenface),['eigenface' num2str(i) '.jpg']);
        
    end
end

% compute projection and reconstruction
Xreduced = cell(1,3);
Xrec = cell(1,3);
for rgb_idx = 1:3 % for each channel
    Xreduced{rgb_idx} = Q{rgb_idx}'*(X{rgb_idx} - kron(ones(1,size(X{rgb_idx},2)),Xmean{rgb_idx}));
    Xrec{rgb_idx} = Q{rgb_idx}*Xreduced{rgb_idx} + kron(ones(1,size(X{rgb_idx},2)),Xmean{rgb_idx});
end

% create reconstructed image and save it
im_rec = zeros(size(im));
rows = size(im_rec,1)/patch_size;
cols = size(im_rec,2)/patch_size;
for rgb_idx = 1:3 % for each channel
    im_rec(:,:,rgb_idx) = from_X_to_image(Xrec{rgb_idx},rows,cols,patch_size);
end
imwrite(uint8(255*im_rec),'illia_rec.jpg');
