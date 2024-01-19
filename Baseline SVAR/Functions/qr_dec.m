%%% QR factorization with non-negative diagonals in R:

function Q = qr_dec(drawW)

[Q,R] = qr(drawW);

for i = 1:size(drawW,1)
    
    if R(i,i)<0
        
        Q(:,i)=-Q(:,i);
        
    end
end