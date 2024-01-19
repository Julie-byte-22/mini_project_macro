%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Baseline SVAR with BEA annual data

clear;
close all;
clc;

addpath('Data')
addpath('Functions')

%% Importing the data:

[data,header]=xlsread('BFM_data.xlsx','YEARLY BEA - Koh et al (2020)','B3:K73');

Output=data(:,1)./(data(:,5)./100); % Current dollar output deflated by GDPDEF
Wages=(data(:,2)./data(:,3))./(data(:,5)./100); % Hourly wage deflated by GDPDEF
Profits=data(:,4)./(data(:,5)./100); % Corporate profits deflated by GDPDEF
CNP16OV=data(:,6);
Hours=data(:,3);

% VAR data:

ylevel=[log(Output./CNP16OV)*100, log(Wages)*100, log(Hours./CNP16OV)*100, log((Profits)./CNP16OV)*100];
y=diff(ylevel); % Take the differences

[T,n] = size(y); 

%% VAR estimation:

p=1; % # of lags
c=1; % constant term

drawfin=10000; % number of stored draws

%% Sign Restricted IRFs:

hor=21; % horizon of IRFs
restr=5; % horizon at which the restrictions are imposed (1 = on impact)
candidateirf=zeros(n,n,hor,drawfin); % candidate impulse responses

BaselineSVAR;

%% IRFs and VD of first row of Figure 10 (b):

conf=68; % confidence level
colorBNDS=[0.7 0.7 0.7]; % color of the bands
VARnames={'GDP'; 'WAGES'; 'HOURS';'PROFITS';'LABOR SHARE'}; % variable names
irf.figtit.shock = { ...
    'DECLINING WAGE MARKUP ($\mathcal{M}_w$ $\downarrow$)', ...
    'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
    'DECLINING PRICE MARKUP ($\mathcal{M}_p$ $\downarrow$)', ...
    'RISING IST ($\Upsilon$ $\uparrow$)', ...
     }; % shock names
 
vdec;

IRFs_vdec_BEA;