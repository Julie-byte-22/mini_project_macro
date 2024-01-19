%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Baseline SVAR - Payroll Share

clear;
close all;
clc;

addpath('Data')
addpath('Functions')

%% Importing the data - Nonfarm Business Sector (except Profits and CNP16OV):

[data,header]=xlsread('BFM_data.xlsx','NONFARM BUSINESS + MACRO','B145:R288');

Output=data(:,1)./(data(:,5)./100); % Current dollar output deflated by IPDNBS
Wages=data(:,2)./(data(:,5)./100); % Hourly wage deflated by IPDNBS
Profits=data(:,4)./(data(:,5)./100); % Corporate profits after tax with IVA and CCAdj deflated by IPDNBS
CNP16OV=data(:,6);
Hours=data(:,8);

% VAR data:

ylevel=[log(Output./CNP16OV)*100, log(Wages)*100, log(Hours./CNP16OV)*100, log((Profits)./CNP16OV)*100];
y=diff(ylevel); % Take the differences

[T,n] = size(y); 

%% VAR estimation and sign restricted IRFs:

p=4; % # of lags
c=1; % constant term

drawfin=10000; % number of stored draws

hor=41; % horizon of IRFs
restr=17; % horizon at which the restrictions are imposed (1 = on impact)
candidateirf=zeros(n,n,hor,drawfin); % candidate impulse responses

BaselineSVAR;

%% IRFs and VD for the second row of Figure 11:

conf=68;
colorBNDS=[0.7 0.7 0.7]; % color of the bands
irf.figtit.shock = { ...
    'DECLINING WAGE MARKUP ($\mathcal{M}_w$ $\downarrow$)', ...
    'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
    'DECLINING PRICE MARKUP ($\mathcal{M}_p$ $\downarrow$)', ...
    'RISING IST ($\Upsilon$ $\uparrow$)', ...
     }; % shock names

vdec;

IRFs_vdec_payroll;