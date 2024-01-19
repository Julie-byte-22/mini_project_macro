figure;

for j=1:n % shock j
    subplot(2,2,j)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]); flipud(reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),50,4),[3 2 1]),hor,1,[]),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(2,j,:,:)+candidateirf(3,j,:,:)-candidateirf(1,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',12)
    title(irf.figtit.shock{j},'FontSize', 10, 'interpreter', 'latex')
   % legend({'68% confidence bands','IRF'},'FontSize',12)
    
    xlim([0 hor-1]);
end

% Save the figure with the variable name
figName = strcat(saveDir, 'Figure_5_', currentVarName, '.png');
saveas(gcf, figName);
