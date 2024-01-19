% historical LS = historical W + historical L - historical Y

err=errornorm; % reduced form residuals
xi=(candidateirf(:,:,1)\err')'; % structural residuals

% start at t=6 for the variable in levels, since there are p=4 lags for the 
% difference specification:

xi=xi(1:end,:); 
Y=ylevel(p+2:end,:); 
meanY=mean(Y);

HH=zeros(T-p,n,n); % store the impact IRFs ^t 

for t=1:T-p
        
        BigC=(BigA)^(t-1);
        BigH=BigC(1:n,1:n)*candidateirf(:,:,1); % C * S * H
        
        for k=1:n
            
        HH(t,:,k)=BigH(k,1:n);
        
        end
        
end

% Cumulate for the levels:

HH=cumsum(HH,1);

% Compute the historical decomposition:

histdec=zeros(T-p,n,n);

for t=1:T-p
   
    for k=1:n
        
        for j=1:n
        
          histdec(t,k,j)=HH(1:t,k,j)'*flipud(xi(1:t,k));
          
        end
        
    end
    
end


% Compute the initial conditions (deterministic components) such that
% these + different shocks contributions sum up to the data in deviation
% from the mean:

initialcond=zeros(T-p,n);

for t=1:T-p
    
    for k=1:n
        
        initialcond(t,k)=Y(t,k)-sum(histdec(t,:,k),2)-meanY(:,k);
        
    end
    
end

initialcond_LS=initialcond(:,2)+initialcond(:,3)-initialcond(:,1);
histdec_LS=histdec(:,:,2)+histdec(:,:,3)-histdec(:,:,1);

% Initial conditions + historical contributions of each shock:

totdec=[initialcond_LS histdec_LS];

% Plot:

positive=totdec>=0;
negative=totdec<0;
histdecpos=zeros(size(totdec,1),size(totdec,2));
histdecneg=zeros(size(totdec,1),size(totdec,2));

for t=1:T-p
    
    for k=1:size(totdec,2)
    
    if positive(t,k)==1
        
        histdecpos(t,k)=totdec(t,k); 
        
    else, histdecpos(t,k)=NaN;
        
    end
    
    end
    
end

for t=1:T-p
    
    for k=1:size(totdec,2)
    
    if positive(t,k)==0
        
        histdecneg(t,k)=totdec(t,k); 
        
    else, histdecneg(t,k)=NaN;
        
    end
    
    end
    
end


dates=1984.0:0.25:2018.5;

figure; clf
b1=bar(dates,histdecpos,'stack');
set(b1(1),'FaceColor',[0.4660, 0.6740, 0.1880],'EdgeColor','none')
set(b1(2),'FaceColor',[0, 0.4470, 0.7410],'EdgeColor','none')
set(b1(3),'FaceColor',[0.8500, 0.3250, 0.0980],'EdgeColor','none')
set(b1(4),'FaceColor',[0.9290, 0.6940, 0.1250],'EdgeColor','none')
set(b1(5),'FaceColor',[0.4940, 0.1840, 0.5560],'EdgeColor','none')
%b1.EdgeColor = 'none'
hold on;
h1=plot(dates,(Y(:,2)+Y(:,3)-Y(:,1))-(meanY(:,2)+meanY(:,3)-meanY(:,1)),'LineWidth',3.5,'Color','k');hold on;
h2=plot(dates,(Y(:,2)+Y(:,3)-Y(:,1))-(meanY(:,2)+meanY(:,3)-meanY(:,1)),'LineWidth',3.5,'Color','k');hold on;
b2=bar(dates,histdecneg,'stack');
set(b2(1),'FaceColor',[0.4660, 0.6740, 0.1880],'EdgeColor','none')
set(b2(2),'FaceColor',[0, 0.4470, 0.7410],'EdgeColor','none')
set(b2(3),'FaceColor',[0.8500, 0.3250, 0.0980],'EdgeColor','none')
set(b2(4),'FaceColor',[0.9290, 0.6940, 0.1250],'EdgeColor','none')
set(b2(5),'FaceColor',[0.4940, 0.1840, 0.5560],'EdgeColor','none')
hold on;
h3=plot(dates,(Y(:,2)+Y(:,3)-Y(:,1))-(meanY(:,2)+meanY(:,3)-meanY(:,1)),'-','LineWidth',3.5,'Color',[0.100 0.1 0.1]);hold on;
set(gca,'FontSize',24)
set(gca,'Xtick',1984:4:2019)
h3(1).MarkerSize = 8;

% set(gca,'Xtick',1:5:T-p,'XtickLabel',DATES(p+2:5:end)) % Changing what's on the x axis with the "dates" in form dd-mm-yy
% xtickangle(90)
hL=legend([b1,h3],{'INITIAL CONDITIONS','WAGE MARKUP','AUTOMATION','PRICE MARKUP','INVESTMENT SPECIFIC TECHNOLOGY'},'FontSize',18,'interpreter', 'latex','Orientation','Horizontal','box','off');
 newPosition = [0.485 0.015 0.07 0.03];
        newUnits = 'normalized';
        set(hL,'Position', newPosition,'Units', newUnits,'Box','off','Orientation','horizontal');
    