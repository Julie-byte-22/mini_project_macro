figure;

for k=n % variable k
    
    for j=1:3 % shock j
        
    subplot(2,n+1,j)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{k}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
    end
    
end


for k=n % variable k
    
    for j=5 % shock j
        
    subplot(2,n+1,4)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{k}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
    end
    
end

for k=n % variable k
    
    for j=4 % shock j
        
    subplot(2,n+1,5)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,k,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{k}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
    end
    
end

% Back of the envelope labor share: IRF_w + IRF_h - IRF_y = IRF_LS

for j=1:3
    
    subplot(2,n+1,n+1+j)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
end

for j=5
    
    subplot(2,n+1,n+1+4)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
end

for j=4
    
    subplot(2,n+1,n+1+5)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])); (flipud(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100-conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),50,4),[3 2 1]),hor,1,[])),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),(100+conf)/2,4),[3 2 1]),hor,1,[])),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
end


% Variance Decomposition:

MiddleDsquare=(reshape(permute(prctile(candidateirf,50,4),[1 3 2]),hor,n*n,[])).^2;
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
    
vardecden_noLS(:,j)=(reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),50,4),[3 2 1]),hor,1,[])).^2;

end

vardecden_noLS=cumsum(sum(vardecden_noLS,2));

for j=1:n
   

vardec_noLS(:,j)=cumsum((reshape(permute(prctile(candidateirf(:,2,j,:)+candidateirf(:,3,j,:)-candidateirf(:,1,j,:),50,4),[3 2 1]),hor,1,[])).^2)./vardecden_noLS;


end



    
    subplot(2,n+1,n+1)
    area(0:hor-1,[vardec(:,n*n-n+1:n*n-2) vardec(:,n*n) vardec(:,n*n-1)] ,'LineWidth',1); hold on; 
    set(gca,'FontSize',16)
    title(strcat(VARnames{k(1)}), 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])
    

    subplot(2,n+1,2*n+2)
    area(0:hor-1,[vardec_noLS(:,1:3) vardec_noLS(:,5) vardec_noLS(:,4)],'LineWidth',1); hold on; 
    legend({'WAGE MARKUP','AUTOMATION','PRICE MARKUP','INVESTMENT SPECIFIC TECHNOLOGY','RISING TFP'}, 'FontSize', 24, 'interpreter', 'latex', 'box','off','Orientation','Horizontal');
    set(gca,'FontSize',16)
    title(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])