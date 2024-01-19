%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Baseline SVAR - Figures 4,5,6

clear;
close all;
clc;

addpath('Data')
addpath('Functions')

%% Importing the data:

[data,header]=xlsread('BFM_data_adjusted.xlsx','EMP_MACRO','B145:AM288');

Output=data(:,1)./(data(:,5)./100); % Current dollar output deflated by IPDNBS
Wages=data(:,2)./(data(:,5)./100); % Hourly wage deflated by IPDNBS
Profits=data(:,4)./(data(:,5)./100); % Corporate profits after tax with IVA and CCAdj deflated by IPDNBS

%Variation of additional dependent variables (to be shocked)

EMP = data(:,18); % Employment share (all)
EMP_men = data(:, 19); % Employment share (men)
EMP_women = data(:, 20); % Employment share (women)
UNEMP = data(:, 21); % Unemployment rate (all)
UNEMP_men = data(:, 22); %Unemployment rate (men)
UNEMP_women = data(:,23); %Unemployment rate (female)
UNEMP_af_am = data(:, 24); %Unemployment rate (african american, all)
UNEMP_af_am_men = data(:, 25); %Unemployment rate (african american, male)
UNEMP_af_am_women = data(:, 26); %Unemployment rate (african american, female)
UNEMP_hisp_all = data(:, 27); %Unemployment rate (hispanic, all)
UNEMP_hisp_men = data(:, 28); %Unemployment rate (hispanic, male)
UNEMP_hisp_women = data(:, 29); %Unemployment rate (hispanic, female)
LFP = data(:, 30); %Labour force participation rate (all)
LFP_women = data(:, 31); %Labour force participation rate (female)
LFP_men = data(:, 32); %Labour force participation rate (men)
LFP_af_am = data(:, 33); % Labour force participation rate (african american)
LFP_af_am_men = data(:, 34); %Labour force participation rate (african american male)
LFP_af_am_women = data(:, 35); %Labour force participation rate (african american female)
LFP_hisp = data(:, 36); %Labour force participation rate (hispanic)
LFP_hisp_men = data(:, 37); %Labour force participation rate (hispanic, men)
LFP_hisp_women = data(:, 38); %Labour force participation rate (hispanic, women)


% Remaining variables
CNP16OV=data(:,6);
Hours=data(:,3);

% List of employment variables to iterate over
% variables = {EMP, EMP_men, EMP_women};

 variables = {EMP, EMP_men, EMP_women, UNEMP, UNEMP_men, UNEMP_women, UNEMP_af_am, ...
             UNEMP_af_am_men, UNEMP_af_am_women, UNEMP_hisp_all, UNEMP_hisp_men, UNEMP_hisp_women, ...
             LFP, LFP_men, LFP_women, LFP_af_am, LFP_af_am_men, LFP_af_am_women, LFP_hisp, LFP_hisp_men, ...
             LFP_hisp_women};


% variableNames = {'EMP RATE (all)', 'EMP RATE (men)', 'EMP RATE (women)'};

variableNames = {'EMP (all)', 'EMP (m)', 'EMP R (w)', 'UNEMP (all)', ...
                  'UNEMP (m)', 'UNEMP RATE (w)', 'UNEMP (af_am, all)', 'UNEMP (af_am, m)', ...
                  'UNEMP (af_am, w)', 'UNEMP (hisp, all)', 'UNEMP RATE (hisp, m)', 'UNEMP (hisp, w)', ...
                  'LFP (all)', 'LFP (m)', 'LFP (w)', 'LFP RATE (af_am)', 'LFP(af_am, m)', ...
                 'LFP (af_am, w)', 'LFP (hisp)', 'LFP (hisp, m)', 'LFP (hisp, w)'};


% Loop through each variable
for i = 1:length(variables)

    % Select the current variable from the list
    currentVariable = variables{i};
    currentVarName = variableNames{i};

    % Print the current variable name
    disp(['Current Variable: ', currentVarName]);

    %VAR data 
    % Adjusting ylevel with the current variable
    ylevel=[log(Output./CNP16OV)*100, log(Wages)*100, log(Hours./CNP16OV)*100, log(currentVariable)*100];
    y=diff(ylevel); % Take the differences


    [T,n] = size(y); 
    
    %% VAR estimation and sign restricted IRFs:

    p=4; % # of lags
    c=1; % constant term
    
    drawfin=10000; % number of stored draws 10000
    
    hor=41; % horizon of IRFs
    restr=17; % horizon at which the restrictions are imposed (1 = on impact)
    
    BaselineSVAR;
    
    %% IRFs - Figures 4 and 5:
    
    % Setup:
    
    conf=68; % confidence level
    colorBNDS=[0.7 0.7 0.7]; % color of the bands
    VARnames={'GDP'; 'WAGES'; 'HOURS'; currentVarName; 'LABOR SHARE'}; % variable names %replace labor share with other employment variables
    irf.figtit.shock = { ...
        'DECLINING WAGE MARKUP ($\mathcal{M}_w$ $\downarrow$)', ...
        'RISING AUTOMATION ($\alpha_k$ $\uparrow$)', ...
        'DECLINING PRICE MARKUP ($\mathcal{M}_p$ $\downarrow$)', ...
        'RISING IST ($\Upsilon$ $\uparrow$)', ...
         }; % shock names
    
    % Plots:
    IRFs_macro_adjusted; % Figure 4 looped over all variables

    %IRF for additional dependent variables
    % Figure 5

    %% Variance Decompositions - Figure 6:
    %vdec; % compute the variance decompositions
    %vdec_plot; % Figure 6

    
end




