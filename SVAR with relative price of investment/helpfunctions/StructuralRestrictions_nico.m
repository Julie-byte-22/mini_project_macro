function y = StructuralRestrictions_nico(x,Z,info)
%
%  Z - n x 1 cell of z_j x k matrices
%  f(x) - stacked A0, impulse responses, or both
%  
%  restrictions:
%
%     Z{j}*f(x)*e_j = 0
%

nvar=info.nvar;
nlag=info.nlag;

n=size(Z,1);
total_zeros=0;
for j=1:n
    total_zeros=total_zeros+size(Z{j},1);
end


A0           = reshape(x(1:n*n),n,n);
m            = info.npredetermined;
Aplus        = reshape(x(1+n*n:end),m,n);
tmp          = zeros(n);
for i=1:info.nlag
    tmp = tmp + Aplus(1+(i-1)*n:i*n,:);
end
Linf         = (A0'-tmp')\eye(n); % see Rubio-Ramirez Waggoner and Zha (2010)



  A=cell(nlag,1);
  q=nlag;
  R=cell(16,1);
  
    for i=1:q
        A{i}=Aplus((i-1)*nvar+1:i*nvar,:);
        X = A0\A{i};
        for j=1:i-1
            X = X + R{j}*A{i-j};
        end
        R{i}=X/A0;
    end
    
    for i=nlag+1:16
        if nlag > 0
            X = R{i-nlag}*A{nlag};
        else
            X = zeros(nvar,nvar);
        end
        for j=1:nlag-1
            X = X + R{i-j}*A{j};
        end
        R{i}=X/A0;
    end
    
    L0=eye(nvar,nvar)/A0+R{1}+R{2}+R{3}+R{4}+R{5}+R{6}+R{7}+R{8}+R{9}+R{10}+R{11}+R{12}+R{13}+R{14}+R{15}+R{16};
    
    
f            = [L0';Linf];

y=zeros(total_zeros,1);
ib=1;
for j=1:n
    ie=ib+size(Z{j},1);  
    y(ib:ie-1)=Z{j}*f(:,j);
    ib=ie;
end