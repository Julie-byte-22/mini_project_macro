figure;

for k=[1;n*n-n+1]
    
    subplot(1,2,k(1))
    area(0:hor-1,vardec(:,k(2):k(2)+n-1),'LineWidth',1); hold on; 
    set(gca,'FontSize',16)
    title(strcat(VARnames{n}), 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])
    
end

    subplot(1,2,2)
    area(0:hor-1,vardec_noLS,'LineWidth',1); hold on; 
    legend({'WAGE MARKUP','AUTOMATION','PRICE MARKUP','INVESTMENT SPECIFIC TECHNOLOGY','SUPER STARS'}, 'FontSize', 24, 'interpreter', 'latex', 'box','off','Orientation','Horizontal');
    set(gca,'FontSize',16)
    title(strcat(VARnames{n+1}), 'FontSize', 18, 'interpreter', 'latex');
    xlim([0 hor-1]);
    ylim([0 1])