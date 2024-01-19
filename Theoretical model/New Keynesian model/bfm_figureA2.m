%%        The Decline of the Labor Share: New Empirical Evidence
%                           Replication code
%
%     by D. Bergholt, F. Furlanetto and N. Maffei Faccioli (2021)
%
% Code used to plot IRF distributions used to derive robust sign
% restrictions.
%
% This code replicates Figure A.2 in the paper.
%
% Please cite the published paper for use of the code. Comments and
% questions can be sent to D. Bergholt (drago.bergholt@norges-bank.no).

%% Setup

% Housekeeping
close all
clear all
clc

% Number of periods to plot
t = 40;

% "Confidence" bands
cred_set = [5; 16; 84; 95];

% Shocks and variables to include in plot
irf.shock = {'e_muwt','e_alphakt','e_mupt','e_upst'};
irf.figtit.shock = { ...
    'DECLINING WAGE MARKUP ($\mu_w$ $\downarrow$)', ...
    'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
    'DECLINING PRICE MARKUP ($\mu_p$ $\downarrow$)', ...
    'RISING IST ($\upsilon$ $\uparrow$)', ...
     };
irf.var = {'lgdpr'; 'lw'; 'll'; 'lpr'; 's_lab'};
irf.vartit = {'gdp'; 'w'; 'l'; 'd'; 's_l'};

%% PREPARE IRF PERCENTILES

load('irfdata_nk.mat')
for jj = 1:length(irf.var)
    for kk = 1:length(irf.shock)
        irfs.prct50.(irf.var{jj}).(irf.shock{kk}) = prctile(irfs.(irf.var{jj}).(irf.shock{kk}),50);
        irfs.prct05.(irf.var{jj}).(irf.shock{kk}) = prctile(irfs.(irf.var{jj}).(irf.shock{kk}),cred_set(1));
        irfs.prct16.(irf.var{jj}).(irf.shock{kk}) = prctile(irfs.(irf.var{jj}).(irf.shock{kk}),cred_set(2));
        irfs.prct84.(irf.var{jj}).(irf.shock{kk}) = prctile(irfs.(irf.var{jj}).(irf.shock{kk}),cred_set(3));
        irfs.prct95.(irf.var{jj}).(irf.shock{kk}) = prctile(irfs.(irf.var{jj}).(irf.shock{kk}),cred_set(4));
        if kk == 1 || kk == 3 % Normalize irfs so that GDP increases for all shocks
            irfs.prct50.(irf.var{jj}).(irf.shock{kk}) = -irfs.prct50.(irf.var{jj}).(irf.shock{kk});
            irfs.prct05.(irf.var{jj}).(irf.shock{kk}) = -irfs.prct05.(irf.var{jj}).(irf.shock{kk});
            irfs.prct16.(irf.var{jj}).(irf.shock{kk}) = -irfs.prct16.(irf.var{jj}).(irf.shock{kk});
            irfs.prct84.(irf.var{jj}).(irf.shock{kk}) = -irfs.prct84.(irf.var{jj}).(irf.shock{kk});
            irfs.prct95.(irf.var{jj}).(irf.shock{kk}) = -irfs.prct95.(irf.var{jj}).(irf.shock{kk});
        end
        if max(abs(irfs.prct50.(irf.var{jj}).(irf.shock{kk}))) < 0.00001
            irfs.prct50.(irf.var{jj}).(irf.shock{kk}) = zeros(1,length(irfs.(irf.var{1}).(irf.shock{1})(1,:)));
            irfs.prct05.(irf.var{jj}).(irf.shock{kk}) = zeros(1,length(irfs.(irf.var{1}).(irf.shock{1})(1,:)));
            irfs.prct16.(irf.var{jj}).(irf.shock{kk}) = zeros(1,length(irfs.(irf.var{1}).(irf.shock{1})(1,:)));
            irfs.prct84.(irf.var{jj}).(irf.shock{kk}) = zeros(1,length(irfs.(irf.var{1}).(irf.shock{1})(1,:)));
            irfs.prct95.(irf.var{jj}).(irf.shock{kk}) = zeros(1,length(irfs.(irf.var{1}).(irf.shock{1})(1,:)));
        end
    end
end

%% CREATE FIGURE

irf.figsize = [5, 4]; % Choose matrix dimension of subplots
qq=0;
fig.h(1) = figure(1); clf;
    set(fig.h(1), 'Name', 'IMPULSE RESPONSE DISTRIBUTIONS IN THE NEW KEYNESIAN MODEL');
    for kk = 1:numel(irf.var)
        for ii = 1:numel(irf.shock)
            qq=qq+1;
        if cellfun('isempty',irf.var(kk)) == 0
        fig.sub.h(qq) = subplot(irf.figsize(1),irf.figsize(2),qq);
        hold on;
            line90 = fill([1:t fliplr(1:t)], [irfs.prct05.(irf.var{kk}).(irf.shock{ii})(:,1:t) fliplr(irfs.prct95.(irf.var{kk}).(irf.shock{ii})(:,1:t))], [0.85 0.85 1], 'EdgeColor', 'none');
            line68 = fill([1:t fliplr(1:t)], [irfs.prct16.(irf.var{kk}).(irf.shock{ii})(:,1:t) fliplr(irfs.prct84.(irf.var{kk}).(irf.shock{ii})(:,1:t))], [0.65 0.70 1], 'EdgeColor', 'none');
            line50 = plot(irfs.prct50.(irf.var{kk}).(irf.shock{ii})(:,1:t), '-','LineWidth',3,'Color',[0.000 0.447 0.741]);
            line([1,t],[0,0],'linestyle','--')
        set(fig.sub.h(qq),'fontsize',16)
        if ii == 1
        ylabel(strcat('$',irf.vartit{kk},'$'), 'FontSize', 24, 'interpreter', 'latex');
        end
        if kk == 1
        title(strcat(irf.figtit.shock{ii}), 'FontSize', 16, 'interpreter', 'latex');
        end
        axis tight
        end
        end
    end
