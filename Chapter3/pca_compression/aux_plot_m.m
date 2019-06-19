% analysis of spectral properties of Cov matrix
% I used this script to generate figures in presentation

clear all

patch_size = 16; % 8,16,32,64,128,512,1024

im = imread(['illia.jpg']);

% separate RGB
Xim{1} = double(im(:,:,1))/255;
Xim{2} = double(im(:,:,2))/255;
Xim{3} = double(im(:,:,3))/255;

% create dataset - small squares [patch_size x patch_size] and construct matrix X
X = cell(1,3);
for rgb_idx = 1:3 % for each channel
    X{rgb_idx} = from_image_to_X(Xim{rgb_idx},patch_size);
end


m = 50;

% compute PCA
Q = cell(1,3);
lambdas = cell(1,3);
lambdas_all_sum = cell(1,3);
Xmean = cell(1,3);
for rgb_idx = 1:3 % for each channel
    [Q{rgb_idx}, lambdas{rgb_idx}, Xmean{rgb_idx}, lambdas_all_sum{rgb_idx}] = mypca(X{rgb_idx},m);
end

figure
hold on
plot(1:m,lambdas{1},'s-', 'LineWidth',1.5, 'Color', [0.8,0,0])
plot(1:m,lambdas{2},'s-', 'LineWidth',1.5, 'Color', [0,0.6,0])
plot(1:m,lambdas{3},'s-', 'LineWidth',1.5, 'Color', [0,0,0.8])
xlabel('index of eigenvalue')
ylabel('eigenvalue')
legend('red','green','blue')
set(gca,'yscale','log')
hold off

relative_error = cell(1,3);
info_size = cell(1,3);
for rgb_idx = 1:3 % for each channel
    relative_error{rgb_idx} = zeros(size(lambdas{rgb_idx}));
    info_size{rgb_idx} = zeros(size(lambdas{rgb_idx}));
    for i=1:length(lambdas{rgb_idx})
        relative_error{rgb_idx}(i) = (lambdas_all_sum{rgb_idx} - sum(lambdas{rgb_idx}(1:i)))/lambdas_all_sum{rgb_idx};
        info_size{rgb_idx}(i) = (1 - relative_error{rgb_idx}(i))*100;
    end
end

figure
hold on
plot(1:m,relative_error{1},'s-', 'LineWidth',1.5, 'Color', [0.8,0,0])
plot(1:m,relative_error{2},'s-', 'LineWidth',1.5, 'Color', [0,0.6,0])
plot(1:m,relative_error{3},'s-', 'LineWidth',1.5, 'Color', [0,0,0.8])
xlabel('number of used eigenvalues')
ylabel('relative error')
legend('red','green','blue')
hold off

figure
hold on
plot(1:m,info_size{1},'s-', 'LineWidth',1.5, 'Color', [0.8,0,0])
plot(1:m,info_size{2},'s-', 'LineWidth',1.5, 'Color', [0,0.6,0])
plot(1:m,info_size{3},'s-', 'LineWidth',1.5, 'Color', [0,0,0.8])
xlabel('number of used eigenvalues')
ylabel('remained information [%]')
legend('red','green','blue')
hold off



% compute projection and reconstruction for every m
rec_error = zeros(1,m);
compression = zeros(1,m);
for mm = 1:m
    Xreduced = cell(1,3);
    Xrec = cell(1,3);
    for rgb_idx = 1:3 % for each channel
        Xreduced{rgb_idx} = Q{rgb_idx}(:,1:mm)'*(X{rgb_idx} - kron(ones(1,size(X{rgb_idx},2)),Xmean{rgb_idx}));
        Xrec{rgb_idx} = Q{rgb_idx}(:,1:mm)*Xreduced{rgb_idx} + kron(ones(1,size(X{rgb_idx},2)),Xmean{rgb_idx});
    end
    
    for rgb_idx = 1:3 % for each channel
        rec_error(mm) = rec_error(mm) + sum(sum((Xrec{rgb_idx} - X{rgb_idx}).^2));
        compression(mm) = compression(mm) + (m+1)*patch_size*patch_size + size(Xreduced{rgb_idx},1)*size(Xreduced{rgb_idx},2);
    end
    rec_error(mm) = rec_error(mm)/(size(X{1},1)*size(X{1},2)*3);
    compression(mm) = (3*size(Xim{1},1)*size(Xim{1},2))/compression(mm);
end


figure
hold on
plot(1:m,compression,'s-', 'LineWidth',1.5, 'Color', [0.8,0,0])
xlabel('number of used eigenvalues')
ylabel('compression ratio')
hold off