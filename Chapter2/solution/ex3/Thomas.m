function x = Thomas(d,u,l,b)
n = length(d);
for i = 1:n-1
    %Normalize by dividing d(i)
    u(i) = u(i)/d(i);
    b(i) = b(i)/d(i);
    d(i) = 1;

    %Using Gaussian Elimination
    alpha = l(i);
    l(i) = 0;
    d(i+1) = d(i+1) - alpha*u(i);
    b(i+1) = b(i+1) - alpha*b(i);
end
%Back-substitution
 x=zeros(n,1);
 x(n) = b(n)/d(n);
for i = n-1:-1:1
    x(i) = b(i) - u(i)*x(i+1);
end
end

