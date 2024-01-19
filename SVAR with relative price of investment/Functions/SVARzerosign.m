% The following code performs the zero and sign restrictions presented in
% the paper. The code is a modification of the code of Arias, Rubio-Ramirez
% and Waggoner (2019) - Econometrica, that allows for restrictions at a 
% horizon different from the impact for the cumulated IRFs. The original 
% code of Arias, Rubio-Ramirez and Waggoner (2019) doesn't have this
% feature. We are grateful to Jonas Arias for sharing the original code 
% with us.

data  = y;
num     = data;        % get variables to be used in SVAR

%==========================================================================
%% model setup
%==========================================================================
nlag      = 4;               % number of lags
nvar      = 5;               % number of endogenous variables
nex       = 1;               % set equal to 1 if a constant is included; 0 otherwise
m         = nvar*nlag + nex; % number of exogenous variables
nd        = 2*1e7;             % number of orthogonal-reduced-form (B,Sigma,Q) draws
iter_show = 10000;            % display iteration every iter_show draws
horizon   = 40;              % maximum horizon for IRFs
NS        = 2;               % number of objects in F(THETA) to which we impose sign and zero restrictios: F(THETA)=[L_{0};L_{infinity}]
e         = eye(nvar);       % create identity matrix
maxdraws  = 1e5;             % max number of importance sampling draws
conjugate = 'structural';    % structural or irfs or empty

%==========================================================================
%% identification: declare Ss and Zs matrices
%==========================================================================
% restrictions on IRFs
% horizons to restrict
horizons = [0,Inf];

% sign restrictions
S = cell(nvar,1);
for ii=1:nvar
    S{ii}=zeros(0,nvar*NS);
end

% Wage Markup

ns1  = 3; 
S{1} = zeros(ns1,nvar*NS);
S{1}(1,1) = 1;
S{1}(2,2) = -1;
S{1}(3,3) = 1;

% Automation

ns2  = 3; 
S{2} = zeros(ns2,nvar*NS);
S{2}(1,1) = 1;
S{2}(2,2) = -1;
S{2}(3,3) = -1;

% Price Markup

ns3  = 3; 
S{3} = zeros(ns3,nvar*NS);
S{3}(1,1) = 1;
S{3}(2,2) = 1;
S{3}(3,4) = -1;

% TFP

ns4  = 3; 
S{4} = zeros(ns4,nvar*NS);
S{4}(1,1) = 1;
S{4}(2,2) = 1;
S{4}(3,4) = 1;

% Investment Specific Technology

ns5  = 3; 
S{5} = zeros(ns5,nvar*NS);
S{5}(1,1) = 1;
S{5}(2,2) = 1;
S{5}(3,4) = 1;


% Zero restrictions

Z=cell(nvar,1);
for i=1:nvar
    Z{i}=zeros(0,numel(horizons)*nvar);
end

% All shocks but IST have no LR effect on P_i:

nz1=1; 
Z{1}=zeros(nz1,numel(horizons)*nvar);

Z{1}(1,nvar+5)=1; % long-run zero restriction on P_i

nz2=1; 
Z{2}=zeros(nz2,numel(horizons)*nvar);
Z{2}(1,nvar+5)=1; % long-run zero restriction on P_i

nz3=1; 
Z{3}=zeros(nz3,numel(horizons)*nvar);
Z{3}(1,nvar+5)=1; % long-run zero restriction on P_i

nz4=1; 
Z{4}=zeros(nz4,numel(horizons)*nvar);
Z{4}(1,nvar+5)=1; % long-run zero restriction on P_i

%==========================================================================
%% Setup info
%==========================================================================
info=SetupInfo(nvar,m,Z,@(x)chol(x));

% ZIRF()
info.nex=nex;
info.nlag     = nlag;
info.horizons = horizons;
info.ZF       = @(x,y)ZIRF(x,y);

% functions useful to compute the importance sampler weights
fs      = @(x)ff_h(x,info);
r       = @(x)ZeroRestrictions(x,info);

if strcmp(conjugate,'irfs')==1
    fo              = @(x)f_h(x,info);
    fo_str2irfs     = @(x)StructuralToIRF(x,info);
    fo_str2irfs_inv = @(x)IRFToStructural(x,info);
    r_irfs          = @(x)IRFRestrictions(x,info); 
end


% function useful to check the sign restrictions
fh_S_restrictions  = @(y)StructuralRestrictions_nico(y,S,info);

%==========================================================================
%% write data in Rubio, Waggoner, and Zha (RES 2010)'s notation
%==========================================================================
% yt(t) A0 = xt(t) Aplus + constant + et(t) for t=1...,T;
% yt(t)    = xt(t) B     + ut(t)            for t=1...,T;
% x(t)     = [yt(t-1), ... , yt(t-nlag), constant];
% matrix notation yt = xt*B + ut;
% xt=[yt_{-1} ones(T,1)];
yt = num(nlag+1:end,:);
T  = size(yt,1);
xt = zeros(T,nvar*nlag+nex);
for i=1:nlag
    xt(:,nvar*(i-1)+1:nvar*i) = num((nlag-(i-1)):end-i,:) ;
end
if nex>=1
    xt(:,nvar*nlag+nex)=ones(T,1);
end
% write data in Zellner (1971, pp 224-227) notation
Y = yt; % T by nvar matrix of observations
X = xt; % T by (nvar*nlag+1) matrix of regressors


%% prior for reduced-form parameters
nnuBar              = 0;
OomegaBarInverse    = zeros(m);
PpsiBar             = zeros(m,nvar);
PphiBar             = zeros(nvar);

%% posterior for reduced-form parameters
nnuTilde            = T +nnuBar;
OomegaTilde         = (X'*X  + OomegaBarInverse)\eye(m);
OomegaTildeInverse  =  X'*X  + OomegaBarInverse;
PpsiTilde           = OomegaTilde*(X'*Y + OomegaBarInverse*PpsiBar);
PphiTilde           = Y'*Y + PphiBar + PpsiBar'*OomegaBarInverse*PpsiBar - PpsiTilde'*OomegaTildeInverse*PpsiTilde;
PphiTilde           = (PphiTilde'+PphiTilde)*0.5;


%% useful definitions
% definitios used to store orthogonal-reduced-form draws, volume elements, and unnormalized weights
Bdraws         = cell([nd,1]); % reduced-form lag parameters
Sigmadraws     = cell([nd,1]); % reduced-form covariance matrices
Qdraws         = cell([nd,1]); % orthogonal matrices
storevefh      = zeros(nd,1);  % volume element f_{h}
storevegfhZ    = zeros(nd,1);  % volume element g o f_{h}|Z
uw             = zeros(nd,1);  % unnormalized importance sampler weights

if strcmp(conjugate,'irfs')==1
    storevephi      = zeros(nd,1);  % volume element f_{h}
    storevegphiZ    = zeros(nd,1);  % volume element g o f_{h}|Z
end

% definitions related to IRFs; based on page 12 of Rubio, Waggoner, and Zha (RES 2010)
J      = [e;repmat(zeros(nvar),nlag-1,1)];
A      = cell(nlag,1);
extraF = repmat(zeros(nvar),1,nlag-1);
F      = zeros(nlag*nvar,nlag*nvar);
for l=1:nlag-1
    F((l-1)*nvar+1:l*nvar,nvar+1:nlag*nvar)=[repmat(zeros(nvar),1,l-1) e repmat(zeros(nvar),1,nlag-(l+1))];
end

% definition to facilitate the draws from B|Sigma
hh              = info.h;
cholOomegaTilde = hh(OomegaTilde)'; % this matrix is used to draw B|Sigma below

%% initialize counters to track the state of the computations
counter = 1;
record  = 1;
count   = 0;

while record<=nd
    
    
    %% step 1 in Algorithm 2
    Sigmadraw     = iwishrnd(PphiTilde,nnuTilde);
    cholSigmadraw = hh(Sigmadraw)';
    Bdraw         = kron(cholSigmadraw,cholOomegaTilde)*randn(m*nvar,1) + reshape(PpsiTilde,nvar*m,1);
    Bdraw         = reshape(Bdraw,nvar*nlag+nex,nvar);
    % store reduced-form draws
    Bdraws{record,1}     = Bdraw;
    Sigmadraws{record,1} = Sigmadraw;
    
   
    %% steps 2:4 of Algorithm 2
    w           = DrawW(info);   
    x           = [vec(Bdraw); vec(Sigmadraw); w];
    structpara  = ff_h_inv(x,info);
    
    % store the matrix Q associated with step 3
    Qdraw            = SpheresToQ(w,info,Bdraw,Sigmadraw);
    Qdraw           = reshape(Qdraw,nvar,nvar);
    %Qdraws{record,1} = reshape(Qdraw,nvar,nvar);

n=size(Z,1);
A0           = reshape(structpara(1:n*n),n,n);
m            = info.npredetermined;
Aplus        = reshape(structpara(1+n*n:end),m,n);
tmp          = zeros(n);


  A=cell(nlag,1);
  q=nlag;
  R=cell(16,1);
  
    for i=1:q
        A{i}=Aplus((i-1)*nvar+1:i*nvar,:);
        X = A{i}; % here I took A0\ away
        for j=1:i-1
            X = X + R{j}*A{i-j};
        end
        R{i}=X; % here I took /A0 away
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
        R{i}=X; % here I took /A0 away
    end
    
    L0=eye(nvar,nvar)+R{1}+R{2}+R{3}+R{4}+R{5}+R{6}+R{7}+R{8}+R{9}+R{10}+R{11}+R{12}+R{13}+R{14}+R{15}+R{16};
    %L0=L0';
    
    %% Eficiency
    
    L0 = (L0*info.h(Sigmadraw))'*Qdraw;
    if L0(1,1)<0 && L0(2,1)>0 && L0(3,1)<0
        Qdraw(:,1)=-Qdraw(:,1);
    end
    
    L0 = (L0*info.h(Sigmadraw))'*Qdraw;
    if L0(1,2)<0 && L0(2,2)>0 && L0(3,2)>0
        Qdraw(:,2)=-Qdraw(:,2);
    end
    
    L0 = (L0*info.h(Sigmadraw))'*Qdraw;
    if L0(1,3)<0 && L0(2,3)<0 && L0(4,3)>0
        Qdraw(:,3)=-Qdraw(:,3);
    end
    
    L0 = (L0*info.h(Sigmadraw))'*Qdraw;
    if L0(1,4)<0 && L0(2,4)<0 && L0(4,4)<0
        Qdraw(:,4)=-Qdraw(:,4);
    end
    
    L0 = (L0*info.h(Sigmadraw))'*Qdraw;
    if L0(1,5)<0 && L0(2,5)<0 && L0(4,5)<0 && L0(5,5)>0
        Qdraw(:,5)=-Qdraw(:,5);
    end
    
    Qdraws{record,1} = Qdraw;

    x           = [vec(Bdraw); vec(Sigmadraw); vec(Qdraw)];
    structpara  = f_h_inv(x,info);
    
    %% check if sign restrictions hold
    signs      = fh_S_restrictions(structpara);
    
    
    if (sum(signs>0))==size(signs,1)
        
        count=count+1;
  
        %% compute importance sampling weights
        
        switch conjugate
            
            case 'structural'
                
                
                storevefh(record,1)   = (nvar*(nvar+1)/2)*log(2)-(2*nvar+m+1)*LogAbsDet(reshape(structpara(1:nvar*nvar),nvar,nvar));
                storevegfhZ(record,1) = LogVolumeElement(fs,structpara,r); 
                uw(record,1)          = exp(storevefh(record,1) - storevegfhZ(record,1));
                
            case 'irfs'
                
                irfpara                = fo_str2irfs(structpara);
                storevephi(record,1)   = LogVolumeElement(fo,structpara)   + LogVolumeElement(fo_str2irfs_inv,irfpara);%log(2)*nvar*(nvar+1)/2 - LogAbsDet(inv(reshape(structpara(1:nvar*nvar),nvar,nvar)*reshape(structpara(1:nvar*nvar),nvar,nvar)'))*(2*nvar*nlag-m-1)/2;
                storevegphiZ(record,1) = LogVolumeElement(fs,structpara,r) + LogVolumeElement(fo_str2irfs_inv,irfpara,r_irfs); 
                uw(record,1)           = exp(storevephi(record,1) - storevegphiZ(record,1));
                
            otherwise
                
                uw(record,1) = 1;
                
        end
        
    else
        
        uw(record,1) = 0;
        
    end
    
    if counter==iter_show
        
        display(['Number of draws = ',num2str(record)])
        display(['Remaining draws = ',num2str(nd-(record))])
        counter =0;
        
    end
    counter = counter + 1;
    
    record=record+1;
    
end


% compute the normalized weights and estimate the effective sample size of the importance sampler
imp_w  = uw/sum(uw);
ne     = floor(1/sum(imp_w.^2));


%% useful definitions to store relevant objects
A0tilde       = zeros(nvar,nvar,ne);               % define array to store A0
Aplustilde    = zeros(m,nvar,ne);                  % define array to store Aplus
Ltilde        = zeros(horizon+1,nvar,nvar,ne);     % define array to store IRF
Llongrun      = zeros(nvar,nvar,ne);                 % define array to store FEVD
cumLtilde     = zeros(horizon+1,nvar,nvar,ne);     % define array to store IRF
% initialize counter to track the state of the importance sampler
count_IRF     = 0;
for s=1:min(ne,maxdraws)
    
    %% draw: B,Sigma,Q
    is_draw     = randsample(1:size(imp_w,1),1,true,imp_w);
    Bdraw       = Bdraws{is_draw,1};
    Sigmadraw   = Sigmadraws{is_draw,1};
    Qdraw       = Qdraws{is_draw,1};
    
    x          = [reshape(Bdraw,m*nvar,1); reshape(Sigmadraw,nvar*nvar,1); Qdraw(:)];
    structpara = f_h_inv(x,info);
    

    LIRF = IRF_horizons(structpara, nvar, nlag, m, 0:horizon);
    Llongrun(:,:,s) = IRF_horizons(structpara, nvar, nlag, m, Inf);
   
    
    for h=0:horizon
        Ltilde(h+1,:,:,s) =  LIRF(1+h*nvar:(h+1)*nvar,:);
         for i=1:nvar
          
       

            
            cumLtilde(h+1,1:nvar,i,s)    = sum(Ltilde(1:h+1,1:nvar,i,s),1); % CHANGED HERE 
         end
    end
    
      
 
  
    % store weighted independent draws
    A0tilde(:,:,s)    = reshape(structpara(1:nvar*nvar),nvar,nvar);
    Aplustilde(:,:,s) = reshape(structpara(nvar*nvar+1:end),m,nvar);
    
end

A0tilde    = A0tilde(:,:,1:s);
Aplustilde = Aplustilde(:,:,1:s);
Ltilde     = cumLtilde(:,:,:,1:s);

message = 'Done.';
disp(message);