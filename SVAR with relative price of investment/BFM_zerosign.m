%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Baseline SVAR - Third and fourth rows of Figure 12

clear;
close all;
clc;

addpath('Data')
addpath('Functions')
addpath('helpfunctions')

%% Importing the data:

[data,header]=xlsread('BFM_data.xlsx','NONFARM BUSINESS + MACRO','B145:R288');

Output=data(:,1)./(data(:,5)./100); % Current dollar output deflated by IPDNBS
Wages=data(:,2)./(data(:,5)./100); % Hourly wage deflated by IPDNBS
Profits=data(:,4)./(data(:,5)./100); % Corporate profits after tax with IVA and CCAdj deflated by IPDNBS
CNP16OV=data(:,6);
Hours=data(:,3);
Investment=data(:,10)./(data(:,5)./100);
RPI=data(:,11)./(data(:,5)./100);

ylevel=[log(Output./CNP16OV)*100, log(Wages)*100, log(Hours./CNP16OV)*100, log((Profits)./CNP16OV)*100, log(RPI)*100];
y=diff(ylevel); % Take the differences

SVARzerosign;

%% IRFs and variance decompositions - Third and fourth rows of Figure 12:

candidateirf=Ltilde;
hor=41;

conf=68;

% Plot:

colorBNDS=[0.7 0.7 0.7];
VARnames={'GDP'; 'WAGES'; 'HOURS';'PROFITS';'$P_i$';'LABOR SHARE'};
irf.figtit.shock = { ...
    'DECLINING WAGE MARKUP ($\mathcal{M}_{w}$ $\downarrow$)', ...
    'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
    'DECLINING PRICE MARKUP ($\mathcal{M}_{p}$ $\downarrow$)', ...
    'RISING TFP', ...
    'RISING IST ($\Upsilon$ $\uparrow$)', ...
     };

 IRFs_vdec_plot_zerosign;


