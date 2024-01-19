%%        The Decline of the Labor Share: New Empirical Evidence
%                           Replication code
%
%     by D. Bergholt, F. Furlanetto and N. Maffei Faccioli (2021)
%
% This script specifies the parameter bounds used for simulation of the
% model.
%
% Please cite the published paper for use of the code. Comments and
% questions can be sent to D. Bergholt (drago.bergholt@norges-bank.no).

%% Parameter bounds

% Initial income shares
s_lab_lb = 0.50; s_lab_ub = 0.70;
s_lab_m = (s_lab_lb + s_lab_ub) / 2;
s_pi_m = 0.1;
s_cap_m = 1 - s_lab_m - s_pi_m;

% "Deep" parameters
sigma_lb = 1;    sigma_ub = 4;
varphi_lb = 0;   varphi_ub = 5;
eta_lb = 0.5;   eta_ub = 1.5;

% Shocks' persistence
rhod_lb    = 0; rhod_ub    = 0.5;
rhoalt_lb  = 0; rhoalt_ub = 0.5;
rhoakt_lb  = 0; rhoakt_ub = 0.5;
rhomupt_lb = 0; rhomupt_ub = 0.5;
rhomuwt_lb = 0; rhomuwt_ub = 0.5;
rhoupst_lb = 0; rhoupst_ub = 0.5;
rhoalphakt_lb = 0; rhoalphakt_ub = 0.5;

% Additional parameters governing the "bells and whistles"
% These are shut down in the baseline model. To turn them on, simply change
% the upper bound. For example, change hab_ub from 0 to 0.9. There is one
% exeption: to turn on variable capital utilization, you have to comment
% out one line of code in the dynare file, and uncomment another one (so
% util_ub = 3 below does not mean that variable capital utilization is
% activated). See the dynare file for details.
hab_lb = 0; hab_ub = 0.9;
adc_lb = 0; adc_ub = 10;
util_lb = 0.05; util_ub = 3;
thetap_lb = 0; thetap_ub = 0.8;
thetaw_lb = 0; thetaw_ub = 0.8;
thetai_lb = 0; thetai_ub = 0*0.8;
gammap_lb = 0; gammap_ub = 0.75;
gammaw_lb = 0; gammaw_ub = 0.75;
gammai_lb = 0; gammai_ub = 0*0.75;
rhoi_lb = 0;   rhoi_ub = 0.9;
rhopi_lb = 1;   rhopi_ub = 3;
rhoy_lb = 0;   rhoy_ub = 1;