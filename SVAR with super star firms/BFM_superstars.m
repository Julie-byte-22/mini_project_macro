%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei Faccioli
%%% SVAR with super star firms shock - Figure 9

clear;
close all;
clc;

addpath('Data')
addpath('Functions')

%% Importing the data:

[data,header]=xlsread('BFM_data.xlsx','NONFARM BUSINESS + MACRO','B145:R288');

Output=data(:,1)./(data(:,5)./100); % Current dollar output deflated by IPDNBS
Wages=data(:,2)./(data(:,5)./100); % Hourly wage deflated by IPDNBS
Profits=data(:,4)./(data(:,5)./100); % Corporate profits after tax with IVA and CCAdj deflated by IPDNBS
CNP16OV=data(:,6);
Hours=data(:,3);
dtfp_util=data(2:end,17);

% VAR data:

ylevel=[log(Output./CNP16OV)*100, log(Wages)*100, log(Hours./CNP16OV)*100, log((Profits)./CNP16OV)*100];
y=[diff(ylevel) dtfp_util./4]; % Take the differences

[T,n] = size(y); 

%% VAR estimation and sign restricted IRFs:

p=4; % # of lags
c=1; % constant term

drawfin=1000; % number of stored draws

hor=41; % horizon of IRFs
restr=17; % horizon at which the restrictions are imposed (1 = on impact)

SVAR_superstars;

%% Variance Decompositions - Figure 9:

VARnames={'GDP'; 'WAGES'; 'HOURS';'PROFITS';'TFP';'LABOR SHARE'}; % variable names
irf.figtit.shock = { ...
    'DECLINING WAGE MARKUP ($\mathcal{M}_w$ $\downarrow$)', ...
    'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
    'DECLINING PRICE MARKUP ($\mathcal{M}_p$ $\downarrow$)', ...
    'RISING IST ($\Upsilon$ $\uparrow$)', ...
     }; % shock names

vdec; % compute the variance decompositions

vdec_plot_superstars; % Figure 9

