% plot eigen values, reconstruction error
% I used this script to generate figures to presentation

clear all

m = 20; % max PCA parameter, dimension of subspace

datadir = 'dataset';

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

% substract mean image from images stored in X
X = X - kron(ones(1,T),Xmean);

% compute covariance matrix
mycov = X*X'; % dimension n,n

%[U,D] = eig(mycov); % do this and Matlab will go crazy :(
disp('computing eigenvectors')
tic
[Q,D] = eigs(mycov,m);
disp([' it took ' num2str(toc) 's'])

lambdas = diag(D);
lambdas_all_sum = trace(mycov);

figure
hold on
plot(1:m,lambdas,'s-', 'LineWidth',1.5)
xlabel('index of eigenvalue')
ylabel('eigenvalue')
hold off

relative_error = zeros(size(lambdas));
info_size = zeros(size(lambdas));
for i=1:length(lambdas)
   relative_error(i) = (lambdas_all_sum - sum(lambdas(1:i)))/lambdas_all_sum;
   info_size(i) = (1 - relative_error(i))*100;
end

figure
hold on
plot(1:m,relative_error,'s-', 'LineWidth',1.5)
xlabel('number of used eigenvalues')
ylabel('relative error')
hold off

figure
hold on
plot(1:m,info_size,'s-', 'LineWidth',1.5)
xlabel('number of used eigenvalues')
ylabel('remained information [%]')
hold off
