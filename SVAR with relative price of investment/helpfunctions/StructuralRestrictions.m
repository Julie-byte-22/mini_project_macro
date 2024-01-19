function y = StructuralRestrictions(x,Z,info)
%
%  Z - n x 1 cell of z_j x k matrices
%  f(x) - stacked A0, impulse responses, or both
%  
%  restrictions:
%
%     Z{j}*f(x)*e_j = 0
%

n=size(Z,1);
total_zeros=0;
for j=1:n
    total_zeros=total_zeros+size(Z{j},1);
end


A0           = reshape(x(1:n*n),n,n);
L0           = inv(A0)';
m            = info.npredetermined;
Aplus        = reshape(x(1+n*n:end),m,n);
tmp          = zeros(n);
for i=1:info.nlag
    tmp = tmp + Aplus(1+(i-1)*n:i*n,:);
end
Linf         = (A0'-tmp')\eye(n); % see Rubio-Ramirez Waggoner and Zha (2010)

f            = [L0;Linf];

y=zeros(total_zeros,1);
ib=1;
for j=1:n
    ie=ib+size(Z{j},1);  
    y(ib:ie-1)=Z{j}*f(:,j);
    ib=ie;
end