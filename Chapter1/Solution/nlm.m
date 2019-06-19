clc;
clear all;
close all;


img=imread('lena.png');
img=rgb2gray(img);
img=im2double(img)
figure
imshow(img)
title('original image')


[m,n]=size(img);
%weight block is 5*5
ds=2;
%searching block is 11*11
Ds=5;
%std = 0.01
h=0.01;
%padding img
offset=ds+Ds;
pad_img = padarray(img,[offset,offset],'symmetric','both');

%kernel
[x,y]=meshgrid(-ds:ds,-ds:ds);
kernel=ones(2*ds+1,2*ds+1);
%normalize
kernel=kernel./((2*ds+1)*(2*ds+1));
n_img=zeros(m,n);% output

%NLM PART
p_bar = waitbar(0,'wait...');
for i=1:m
    for j=1:n
        
   
        i1=i+offset;
        j1=j+offset;
        M1=pad_img(i1-ds:i1+ds,j1-ds:j1+ds);
        

        weight=zeros(2*Ds+1,2*Ds+1);
        image=pad_img(i1-Ds:i1+Ds,j1-Ds:j1+Ds);

        for r=-Ds:Ds
            for s=-Ds:Ds
                

                if(r==0&&s==0)
                    continue;
                end
                

                i2=i1+r;
                j2=j1+s;
                M2=pad_img(i2-ds:i2+ds,j2-ds:j2+ds);
                distance=sqrt(sum(sum(kernel.*(M1-M2).*(M1-M2))));
                if (r==0 && s==0)
                    weight(r+Ds+1,s+Ds+1)=1.0;
                end 
                weight(r+Ds+1,s+Ds+1)=exp(-distance/(h));
            end
        end
        weight=weight/(sum(weight(:)));
        
        n_img(i,j)=sum(sum(image.*weight));
    end
    waitbar(i/m);
end
close(p_bar);
figure
imshow(mat2gray(n_img))
title('NLM');
