clear all

m = 10; % PCA parameter, dimension of subspace

datadir = 'dataset';
recdir = 'reconstructed';
eigenfacedir = 'eigenfaces';

a = 140; % size of image, should be implemented in smarter way
T = 24; % number of images
n = a*a; % data dimension
X = zeros(n,T); % here store loaded data, columns are images

disp('loading data')
tic
for t=1:T
   im = imread([datadir '/me_' num2str(t) '.jpg']);
   if size(im,3) == 3
       im = rgb2gray(im); % if image is RGB, then transform it to BW
   end
   
   X(:,t) = double(reshape(im,n,1))/255; % map to [0,1]
end
disp([' it took ' num2str(toc) 's'])

% compute "mean" image
Xmean = sum(X,2)/T;

% for fun: save mean image
imwrite(uint8(255*reshape(Xmean,a,a)),[eigenfacedir '/mean_image.jpg']); 

% substract mean image from images stored in X
X = X - kron(ones(1,T),Xmean);

% compute covariance matrix
mycov = X*X'; % dimension n,n

%[U,D] = eig(mycov); % do this and Matlab will go crazy :(
disp(['computing ' num2str(m) ' eigenvectors of matrix ' num2str(size(mycov,1)) ' x ' num2str(size(mycov,2))])
tic
[Q,D] = eigs(mycov,m); % compute only largest m eigenvalues
disp([' it took ' num2str(toc) 's'])

% for fun - store and plot eigenfaces
for i=1:m
    eigenface = Q(:,i);
    
    % map to [0,255]
    mymin = min(eigenface);
    mymax = max(eigenface);
    a_tr = 255/(mymax - mymin);
    b_tr = -a_tr*mymin;
    eigenface = a_tr*eigenface + b_tr;
    
    % save
    imwrite(uint8(reshape(eigenface,a,a)),[eigenfacedir '/q' num2str(i) '.jpg']); 
end

% compute projection
Xreduced = Q'*X;

% compute reconstruction
Xrec = Q*Xreduced + kron(ones(1,T),Xmean);

% save reconstructed images
for t=1:T
    imwrite(uint8(reshape(255*Xrec(:,t),a,a)),[recdir '/me_' num2str(t) '.jpg']);
end


