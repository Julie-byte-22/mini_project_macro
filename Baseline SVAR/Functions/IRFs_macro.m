saveDir = '/Users/juliaschmidt/Documents/studies/P_Dauphine_22/MQEA/Adv_macroecon_23/mini_project/report_replication/emp_variable_plots/';
figure;

for k=1:n % variable k
    
    for j=1:n % shock j
        
    subplot(n,n,j+n*k-n)
    fill([0:hor-1 fliplr(0:hor-1)]' ,[reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]); flipud(reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]))],...
        colorBNDS,'EdgeColor','None'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),50,4),[3 2 1]),hor,1,[]),'LineWidth',3.5,'Color','k'); hold on;
    plot(0:hor-1,reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4),[3 2 1]),hor,1,[]),'LineWidth',1.5,'Color','k'); hold on;
    line(get(gca,'Xlim'),[0 0],'Color',[0 0 0],'LineStyle','--','LineWidth',1.5); hold off;
    set(gca,'FontSize',16)
    
    if j ==1
        ylabel(strcat(VARnames{k}), 'FontSize', 10, 'interpreter', 'latex');
    end
    
    if k == 1
        title(strcat(irf.figtit.shock{j}), 'FontSize', 6, 'interpreter', 'latex');
    end
    
    xlim([0 hor-1]);
    xticks(0:10:hor-1)
    
    end
    
    % Save the figure with the variable name
    figName = strcat(saveDir, 'Figure_4_', currentVarName, '.png');
    saveas(gcf, figName);
end