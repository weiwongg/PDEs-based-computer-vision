function n_img = bf(img, r,sigma_d,sigma_r)
[m n]=size(img);
%radius of filter, size of filter         
n_img=zeros(m+2*r,n+2*r);
n_img(r+1:m+r,r+1:n+r)=img;
[x,y] = meshgrid(-r:r,-r:r);
w_d=exp(-(x.^2+y.^2)/(2*sigma_d^2));     

%Implementing BF
for i=r+1:m+r
    for j=r+1:n+r        
        w_r=exp(-(n_img(i-r:i+r,j-r:j+r)-n_img(i,j)).^2/(2*sigma_r^2)); 
        w=w_d.*w_r;
        
        s=n_img(i-r:i+r,j-r:j+r).*w;
        n_img(i,j)=sum(sum(s))/sum(sum(w));
    
    end
end
n_img = mat2gray(n_img(r+1:m+r,r+1:n+r));
end

