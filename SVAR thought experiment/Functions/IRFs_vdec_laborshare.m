vdec; % compute variance decompositions

figure;

for j=1:n % shock j
    subplot(3,2,j)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]); flipud(reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),50,4),[3 2 1]),hor,1,[]),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',24)
    title(irf.figtit.shock{j},'FontSize', 24, 'interpreter', 'latex')
   % legend({'68% confidence bands','IRF'},'FontSize',12)
    
    xlim([0 hor-1]);
end

    subplot(3,2,n+1)
    area(0:hor-1,vardec_noLS,'LineWidth',1); hold on; 
    legend({'WAGE MARKUP','AUTOMATION','PRICE MARKUP','INVESTMENT SPECIFIC TECHNOLOGY'}, 'FontSize', 24, 'interpreter', 'latex', 'box','off');
    set(gca,'FontSize',16)
    title(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])
    