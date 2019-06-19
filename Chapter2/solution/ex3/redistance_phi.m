function re_phi = redistance_phi(phi, tspan)
dim_y = size(phi,1);
dim_x = size(phi,2);
phi_0 = phi;
[t,y] = ode23(@(t,y) odefcn(t,y,phi_0,dim_x, dim_y), tspan, phi_0);
re_phi = reshape(y(end,:), dim_y, dim_x);
end
%define sign(\phi_0)(1-\norm{\nabla \phi}_2)
function dy = odefcn(t,y, phi_0, dim_x, dim_y)
im = reshape(y,[dim_y,dim_x]);
[Ix,Iy]=gradient(im);
f=sqrt(Ix.^2+Iy.^2);
dy = (1-f(:)) .* sign(phi_0(:));
end
