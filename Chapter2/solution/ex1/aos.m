function [d, u, l] = aos(diff_c, dim_x, dim_y, delta_t)

%define d, u, l
d = ones(1, dim_x*dim_y);
u = zeros(0, dim_x*dim_y-1);
l = zeros(0, dim_x*dim_y-1);

for ind = 1:dim_y*dim_x
    if mod(ind-1, dim_y) ~= 0 && mod(ind-1, dim_y) ~= dim_y -1
        
        u(ind) = (-diff_c(ind+1) - diff_c(ind)) * delta_t;  
        l(ind-1) = (-diff_c(ind - 1) - diff_c(ind)) * delta_t;     
        d(ind) = d(ind) - (u(ind) +  l(ind-1));
    elseif mod(ind-1, dim_y) == 0
        u(ind) = delta_t * (-diff_c(ind+1) - diff_c(ind)); 
        d(ind) = d(ind) - u(ind);
    else 
        l(ind-1) = delta_t * (-diff_c(ind) - diff_c(ind-1)); 
        d(ind) = d(ind) - l(ind-1);
    end
end
end 
        
        
        
        

