function temp = create_decay_temp(dim_y,dim_x)
max_value = 0.5;
min_value = 0;
margin = 10;
temp = ones(dim_y, dim_x, 3);
weight1 = (max_value-min_value)/margin*[0:margin-1]+min_value;
weight2 = (max_value-min_value)/margin*[margin-1:-1:0]+min_value;

temp(:,1:margin,:) = temp(:,1:margin,:).*(repmat(weight1,dim_y,1,3));
temp(:,dim_x-margin+1:dim_x,:) = temp(:,dim_x-margin+1:dim_x,:).*(repmat(weight2,dim_y,1,3));
temp(1:margin,:,:) = temp(1:margin,:,:).*(repmat(weight1',1,dim_x,3));
temp(dim_y-margin+1:dim_y,:,:) = temp(dim_y-margin+1:dim_y,:,:).*(repmat(weight2',1,dim_x,3));
end