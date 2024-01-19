%%% BVAR - Diffuse/Uninformative Prior (Uniform -inf, +inf)
%%% Author: Nicolo' Maffei Faccioli

function [PI,BigA,Sigma,errornorm,fittednorm]=BVAR_diffuse(y,p,c)

    [Traw,n]=size(y);
    
    T=Traw-p; % first p observations are discarded

    [pi_hat,Y,X,~,~,err]=VAR(y,p,c); % ML = OLS estimate 
    
    S=err'*err; % SSE
    
    % Draw Q from IW ~ (S,v), where v = T-(n*p+1):
    
    Sigma=iwishrnd(S,T-size(X,2)); 
    
    % Compute the Kronecker product Q x inv(X'X) and vectorize the matrix
    % pi_hat in order to obtain vec(pi_hat):
    
    XX=kron(Sigma,inv(X'*X)); 
    s=size(pi_hat)';
    vec_pi_hat=reshape(pi_hat,s(1)*s(2),1);
    
    % Draw PI from a multivariate normal distribution with mean vec(pi_hat)
    % and variance Sigma x inv(X'X):
    
    PI=mvnrnd(vec_pi_hat,XX,1);
    PI=PI';
    PI=reshape(PI,[n*p+c,n]); % reshape PI such that Y=X*PI+e ,
                              % i.e. PI is (n*p+c)x(n).
                              
    % Create the companion form representation matrix A:
    
    BigA=[PI(1+c:end,:)'; eye(n*p-n) zeros(n*p-n,n)]; % (n*p)x(n*p) matrix
    
    % Store errors and fitted values:
    
    errornorm=Y-X*PI;
    fittednorm=X*PI;
    
end
    
    
    
    
    


