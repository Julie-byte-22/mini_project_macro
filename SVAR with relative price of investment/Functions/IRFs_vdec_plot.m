figure;


for k=n % variable k
    
    for j=1:n-1 % shock j
        
    subplot(1,n,j)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]); flipud(reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),50,4),[3 2 1]),hor,1,[]),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{k}), 'FontSize', 18, 'interpreter', 'latex');
    end
    
    
    title(strcat(irf.figtit.shock{j}), 'FontSize', 16, 'interpreter', 'latex');
    
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
    end
    
end

vdec; % compute variance decompositions


    subplot(1,n,n)
    area(0:hor-1,vardec(:,n*n-n+1:n*n),'LineWidth',1); hold on; 
    legend({'WAGE MARKUP','AUTOMATION','PRICE MARKUP','INVESTMENT SPECIFIC TECHNOLOGY'}, 'FontSize', 24, 'interpreter', 'latex', 'box','off','Orientation','Horizontal');
    set(gca,'FontSize',16)
    title('VARIANCE DECOMPOSITION', 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])