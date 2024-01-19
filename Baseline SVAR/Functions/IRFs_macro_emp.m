saveDir = '/Users/juliaschmidt/Documents/studies/P_Dauphine_22/MQEA/Adv_macroecon_23/mini_project/report_replication/emp_variable_plots/';

figure;

% Initialize subplot counter
subplotCounter = 1;

% Indices for Employment variables
empVarIndices = 4:6; % Adjust this to the indices of your employment variables

for k = empVarIndices % variable k
    
    for j = 1:n % shock j
        
        % Use the subplot counter for indexing
        subplot(length(empVarIndices), n, subplotCounter);
        fill([0:hor-1 fliplr(0:hor-1)]', [reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4),[3 2 1]), hor, 1, []); flipud(reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]), hor, 1, []))], colorBNDS, 'EdgeColor', 'None'); hold on;
        plot(0:hor-1, reshape(permute(prctile(candidateirf(k,j,:,:),(100-conf)/2,4),[3 2 1]), hor, 1, []), 'LineWidth', 1.5, 'Color', 'k'); hold on;
        plot(0:hor-1, reshape(permute(prctile(candidateirf(k,j,:,:), 50, 4), [3 2 1]), hor, 1, []), 'LineWidth', 3.5, 'Color', 'k'); hold on;
        plot(0:hor-1, reshape(permute(prctile(candidateirf(k,j,:,:),(100+conf)/2,4), [3 2 1]), hor, 1, []), 'LineWidth', 1.5, 'Color', 'k'); hold off;
        line(get(gca,'Xlim'), [0 0], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1.5); 
        
        % Set axes properties
        set(gca, 'FontSize', 10);
        if j == 1
            ylabel(strcat(VARnames{k}), 'FontSize', 10, 'interpreter', 'latex');
        end
        if k == empVarIndices(1)
            title(strcat(irf.figtit.shock{j}), 'FontSize', 6, 'interpreter', 'latex');
        end
        xlim([0 hor-1]);
        xticks(0:10:hor-1);

        % Increment subplot counter
        subplotCounter = subplotCounter + 1;
    end
end

% Save the figure with the variable name
figName = strcat(saveDir, 'Figure_4_EMP.png');
saveas(gcf, figName);
