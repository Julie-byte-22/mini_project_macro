%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Figures 1 and 10.(a)

clear; clc;

cd("/Users/juliaschmidt/Documents/studies/Paris Dauphine 2022/Master Quantitative Economics/Adv_macroecon_23/mini_project/Bergolt_replication_package/BFM_Data_Codes/BFM Codes/Labor Share Plots")

addpath('Data')

load 'LSmeasures.mat'

%% Figure 1:

dates=1947:0.25:2018.75;

figure;

plot(dates,[EconomywideLaborShare LABORSHARE LABORSHARENFB LABORSHARENFC PAYROLLSHARE],'LineWidth',2), axis tight, grid on;
ylabel('US LABOR INCOME SHARE','interpreter', 'latex')
legend({'ECONOMY-WIDE','BUSINESS','NONFARM BUSINESS','NONFINANCIAL CORPORATE','PAYROLL'},'FontSize', 28, 'interpreter', 'latex','box','off','Orientation','Horizontal')
set(gca,'FontSize',28)

%% Figure 10.(a):

s_ipp = PRE1999LS;
s_bea = BEALS;
year = 1947:1:2018;

B = [ones(size(year(:))),year(:)]\s_bea(:);
hats_bea = [ones(size(year(:))),year(:)]*B;
B = [ones(size(year(:))),year(:)]\s_ipp(:);
hats_ipp = [ones(size(year(:))),year(:)]*B;

irf.linetype = {'-';'-.'};
irf.linewidth = [5];
irf.color = [ ...
    0.3 0.3 0.3; ...
    0.000 0.447 0.741; ...
    0.850 0.325 0.098 ...
    ];

figure; clf
fig.h = subplot(1,1,1);
hold on
line.A = plot(year,[s_bea], irf.linetype{1},'LineWidth',irf.linewidth(1),'Color',irf.color(2,:));
line.B = plot(year,[hats_bea], irf.linetype{2},'LineWidth',irf.linewidth(1),'Color',irf.color(2,:));
line.C = plot(year,[s_ipp], irf.linetype{1},'LineWidth',irf.linewidth(1),'Color',irf.color(3,:));
line.D = plot(year,[hats_ipp], irf.linetype{2},'LineWidth',irf.linewidth(1),'Color',irf.color(3,:));
    hL = legend([line.A,line.C], ...
            {'BEA LABOR SHARE', 'LABOR SHARE WITH DE-CAPITALIZED IPP (PRE 1999 REV.)'}, ...
            'FontSize', 20);
        newPosition = [0.485 0.015 0.07 0.03];
        newUnits = 'normalized';
        set(hL,'Position', newPosition,'Units', newUnits,'Box','off','Orientation','horizontal');
        set(fig.h,'fontsize',18)
