MiddleDsquare=reshape(permute(prctile(candidateirf,50,4),[3 2 1]),hor,n*n,[]).^2;
denom=zeros(hor,n);

for k=[1:n;1:n:n*n]
    
    denom(:,k(1))=cumsum(sum(MiddleDsquare(:,k(2):k(2)+n-1),2));
    
end

denomtot=zeros(hor,n*n);

for k=[1:n;1:n:n*n]
    
    denomtot(:,k(2):k(2)+n-1)=denom(:,k(1)).*ones(hor,n);
    
end

vardec=zeros(hor,n*n);

for j=1:n*n
    
    vardec(:,j)=cumsum(MiddleDsquare(:,j))./denomtot(:,j);
    
end

vardecden_noLS=zeros(hor,n);
vardec_noLS=zeros(hor,n);

for j=1:n
    
vardecden_noLS(:,j)=(reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),50,4),[3 2 1]),hor,1,[])).^2;

end

vardecden_noLS=cumsum(sum(vardecden_noLS,2));

for j=1:n
   

vardec_noLS(:,j)=cumsum((reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),50,4),[3 2 1]),hor,1,[])).^2)./vardecden_noLS;


end