
saveDir = '/Users/juliaschmidt/Documents/studies/P_Dauphine_22/MQEA/Adv_macroecon_23/mini_project/report_replication/emp_variable_plots/';

% Convert the dimensions from mm to pixels
dpi = 96; % Standard screen resolution
width_mm = 160; % Width in mm (A4 width - margins)
height_mm = width_mm / 8; % Height is quarter the width
width_pixels = width_mm / 25.4 * dpi; % Convert mm to pixels
height_pixels = height_mm / 25.4 * dpi; % Convert mm to pixels

figure('Position', [100, 100, width_pixels, height_pixels]);


currentVarIndex = find(strcmp(VARnames, currentVarName)); % Find the index of currentVarName in VARnames

for j=1:n % shock j

    subplot(1, n, j) % Change to 1 row, n columns layout
    fill([0:hor-1 fliplr(0:hor-1)]', [reshape(permute(prctile(candidateirf(currentVarIndex,j,:,:), (100+conf)/2,4), [3 2 1]), hor, 1, []); flipud(reshape(permute(prctile(candidateirf(currentVarIndex,j,:,:), (100-conf)/2,4), [3 2 1]), hor, 1, []))], colorBNDS, 'EdgeColor', 'None'); hold on;
    plot(0:hor-1, reshape(permute(prctile(candidateirf(currentVarIndex,j,:,:), (100-conf)/2,4), [3 2 1]), hor, 1, []), 'LineWidth', 1.5, 'Color', 'k'); hold on;
    plot(0:hor-1, reshape(permute(prctile(candidateirf(currentVarIndex,j,:,:), 50, 4), [3 2 1]), hor, 1, []), 'LineWidth', 3.5, 'Color', 'k'); hold on;
    plot(0:hor-1, reshape(permute(prctile(candidateirf(currentVarIndex,j,:,:), (100+conf)/2,4), [3 2 1]), hor, 1, []), 'LineWidth', 1.5, 'Color', 'k'); hold on;
    line(get(gca, 'Xlim'), [0 0], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1.5); hold off;
    set(gca, 'FontSize', 8)

    if j == 1
        ylabel(strcat(VARnames{currentVarIndex}), 'FontSize', 8, 'interpreter', 'latex');
    end

    title(strcat(irf.figtit.shock{j}), 'FontSize', 6, 'interpreter', 'latex');

    xlim([0 hor-1]);
    xticks(0:10:hor-1)

end

% Save the figure with the variable name
figName = strcat(saveDir, 'Figure_4_', currentVarName, '.png');
saveas(gcf, figName);

