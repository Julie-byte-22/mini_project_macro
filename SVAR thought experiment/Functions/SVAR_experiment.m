% Set up the loop for each draw :

PI=zeros(n*p+c,n,drawfin);
BigA=zeros(n*p,n*p,drawfin);
Sigma=zeros(n,n,drawfin);
errornorm=zeros(T-p,n,drawfin);
fittednorm=zeros(T-p,n,drawfin);

% Set up 4-D matrices for the IRFs to be filled in the loop:

candidateirf=zeros(n,n,hor,drawfin); % candidate impulse responses
C=zeros(n,n,hor,drawfin); % Reduced-form IRFs
D=zeros(n,n,hor,drawfin); % Cholesky IRFs
S=zeros(n,n,drawfin); % Cholesky decomposition of the var-cov matrix Sigma
Q=zeros(n,n,drawfin); % Orhogonal matrix Q

tic

h = waitbar(0,'Please wait, results are on the way!');

k=0;

while k<drawfin
    
k=k+1;

count_d=-1;

while count_d<0
    
stable=-1;
    
while stable<0
    
% Estimate the reduced-form VAR:
    
[PI(:,:,k),BigA(:,:,k),Sigma(:,:,k),errornorm(:,:,k),fittednorm(:,:,k)]=BVAR_diffuse(y,p,c);
    
if abs(eig(BigA(:,:,k)))<1
        stable=1; % keep only stable draws
end

end

% Reduced-form IRFs:

for j=1:hor
    BigC=BigA(:,:,k)^(j-1);
    C(:,:,j,k)=BigC(1:n,1:n); 
end

% Cholesky factorization:

S(:,:,k)=chol(Sigma(:,:,k),'lower'); % Lower triangular matrix s.t S S' = Sigma

for i=1:hor
    D(:,:,i,k)=C(:,:,i,k)*S(:,:,k); 
end

% Sign Restrictions Loop:

control=0;
count=0;

while control==0
    
    % If you can't find Qr after 100000 repetitions of the algorithm, then
    % pass to the next draw:
    
    count=count+1;
    
    if count>=100000
        control=1;
    end
       
    % STEP 1:
   
    W=mvnrnd(zeros(n),eye(n)); % draw an independent standard normal nxn matrix
    Qr=qr_dec(W); % QR decomposition with the the diagonal of R normalized to be positive
    
    % STEP 2 - Compute candidate IRFs:
    
    for i=1:hor
            candidateirf(:,:,i,k)=D(:,:,i,k)*Qr';
    end
    
    % Cumulate the IRFs to obtain the IRFs for the log levels:
    
    candidateirf(:,:,:,k)=cumsum(candidateirf(:,:,:,k),3);
    
    % STEP 3 - Check if the candidates satisfy all the sign restrictions:
    
    % N.B. : In what follows, following RWZ (2010), I use, to gain
    % efficiency, the fact that changing the sign of any of the columns of
    % matrix Q results in another orthogonal matrix. If all of the
    % candidate IRFs have wrong signs, then, by changing the sign of, say,
    % column j of Q, we obtain a new rotation matrix that, multiplied by D
    % will give us a candidate that satisfies the sign restrictions.

    %%%%%%%%%%%%% Responses to a Wage Markup Shock %%%%%%%%%%%%%:
   
    a = (candidateirf(1,1,restr,k) > 0).* (candidateirf(2,1,restr,k) < 0).* (candidateirf(3,1,restr,k) > 0).* ((candidateirf(2,1,restr,k)+candidateirf(3,1,restr,k)-candidateirf(1,1,restr,k)) > 0);
    if (max(a)==0)
      %--- Swiching the sign of the shock.
      am = (candidateirf(1,1,restr,k) < 0).* (candidateirf(2,1,restr,k) > 0).* (candidateirf(3,1,restr,k) < 0).* ((candidateirf(2,1,restr,k)+candidateirf(3,1,restr,k)-candidateirf(1,1,restr,k)) < 0);
      
      if (min(am)==0)
         continue;   %The restrictions are not satisfied.  Go to the beginning to redraw.
      else
         %--- Normalizing according to the switched sign.
         Qr(1,:) = -Qr(1,:); 
      end
    elseif (min(a)==0)
      continue;  %The restrictions are not satisfied.  Go to the beginning to redraw.
    end
   
    %%%%%%%%%%%%% Responses to an Automation Shock %%%%%%%%%%%%%:
   
    a = (candidateirf(1,2,restr,k) > 0).* (candidateirf(2,2,restr,k) < 0).* (candidateirf(3,2,restr,k) < 0);
    if (max(a)==0)
      %--- Swiching the sign of the shock.
      am = (candidateirf(1,2,restr,k) < 0).* (candidateirf(2,2,restr,k) > 0).* (candidateirf(3,2,restr,k) > 0);
      
      if (min(am)==0)
         continue;   %The restrictions are not satisfied.  Go to the beginning to redraw.
      else
         %--- Normalizing according to the switched sign.
         Qr(2,:) = -Qr(2,:); 
      end
    elseif (min(a)==0)
      continue;  %The restrictions are not satisfied.  Go the beginning to redraw.
    end
   
    %%%%%%%%%%%%% Responses to a Price Markup Shock %%%%%%%%%%%%%:
   
    a = (candidateirf(1,3,restr,k) > 0) .* (candidateirf(2,3,restr,k) > 0).* (candidateirf(4,3,restr,k) < 0);
    if (max(a)==0)
      %--- Swiching the sign of the shock.
      am = (candidateirf(1,3,restr,k) < 0) .* (candidateirf(2,3,restr,k) < 0).* (candidateirf(4,3,restr,k) > 0);
      
      if (min(am)==0)
         continue;   %The restrictions are not satisfied.  Go to the beginning to redraw.
      else
         %--- Normalizing according to the switched sign.
         Qr(3,:) = -Qr(3,:); 
      end
    elseif (min(a)==0)
      continue;  %The restrictions are not satisfied.  Go to the beginning to redraw.
    end
    
     %%%%%%%%%%%%% Responses to an Investment Specific Technology Shock %%%%%%%%%%%%%:
   
    a = (candidateirf(1,4,restr,k) > 0).* (candidateirf(2,4,restr,k) > 0).* (candidateirf(4,4,restr,k) > 0).* ((candidateirf(2,4,restr,k)+candidateirf(3,4,restr,k)-candidateirf(1,4,restr,k)) < 0);
    if (max(a)==0)
      %--- Swiching the sign of the shock.
      am = (candidateirf(1,4,restr,k) < 0).* (candidateirf(2,4,restr,k) < 0).* (candidateirf(4,4,restr,k) < 0).* ((candidateirf(2,4,restr,k)+candidateirf(3,4,restr,k)-candidateirf(1,4,restr,k)) > 0);
      
      if (min(am)==0)
         continue;   %The restrictions are not satisfied.  Go to the beginning to redraw.
      else
         %--- Normalizing according to the switched sign.
         Qr(4,:) = -Qr(4,:); 
      end
    elseif (min(a)==0)
      continue;  %The restrictions are not satisfied.  Go to the beginning to redraw.
    end

   % Terminating condition: all restrictions are satisfied.
   
   control=1;
   
end

   if count>=100000
       count_d=-1;
   else, count_d=1; 
   end

   % Given the properly selected Qr matrix, compute the responses that
   % satisfy (jointly) all the sign restrictions and store these:
   
    for i=1:hor
            candidateirf(:,:,i,k)=D(:,:,i,k)*Qr';
    end
    
    Q(:,:,k)=Qr'; % Store the orthogonal matrix
    candidateirf(:,:,:,k)=cumsum(candidateirf(:,:,:,k),3); % Cumulated IRFs
    
    waitbar(k/drawfin,h,sprintf('Please wait, results are on the way! Percentage completed %2.2f',(k/drawfin)*100))
    
end

end

toc