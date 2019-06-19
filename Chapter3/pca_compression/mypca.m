function [Q, lambdas, Xmean, lambdas_all_sum] = mypca(X,m)

[n,T] = size(X);
Xmean = sum(X,2)/T;

% substract mean
X = X - kron(ones(1,T),Xmean);

% compute covariance matrix
mycov = X*X'; % dimension n,n

%[U,D] = eig(mycov); % do this and Matlab will go crazy :(
disp(['computing ' num2str(m) ' eigenvectors of matrix ' num2str(size(mycov,1)) ' x ' num2str(size(mycov,2))])
tic
[Q,D] = eigs(mycov,m);
disp([' it took ' num2str(toc) 's'])

lambdas = diag(D);
lambdas_all_sum = trace(mycov);

end

