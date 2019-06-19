function [T, P] = dynamic_find(E)
[m,n] = size(E);
T = zeros(m,n);
%Restore path information
P=zeros(m,n);
%Dynamic algorithm finding the path along which the sum energy is minimal
for i=1:m
    for j=1:n
        if(i==1)
            %initialize for the fisrt row
            T(i,j)=E(i,j);
            P(i,j)=0;
        else
            if(j==1)
                [tmp, offset] = min([T(i-1,j),T(i-1,j+1)]);
                T(i,j)=E(i,j)+ tmp;
                P(i,j)=offset - 1;
            elseif(j==n)
                [tmp, offset] = min([T(i-1,j-1),T(i-1,j)]);
                T(i,j)= E(i,j) + tmp;
                P(i,j)=offset - 2;
            else
                [tmp, offset] = min([T(i-1,j-1),T(i-1,j),T(i-1,j+1)]);
                T(i,j)=E(i,j)+tmp;
                P(i,j)=offset-2;
            end
        end
    end
end
max_value =max(max(T));
T=T./max_value;
end
