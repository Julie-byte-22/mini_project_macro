%%        The Decline of the Labor Share: New Empirical Evidence
%                           Replication code
%
%     by D. Bergholt, F. Furlanetto and N. Maffei Faccioli (2021)
%
% Code for creation of simulated IRF bands to be used for identification of
% robust sign restrictions.
%
% Please cite the published paper for use of the code. Comments and
% questions can be sent to D. Bergholt (drago.bergholt@norges-bank.no).

%% Choose number of MC simulations

% # simulations
ndraws = 10000;

%% Parameter draws

h = waitbar(0,'Performing Monte Carlo simulations...','Name','Please wait...');
counter = 0;

% Load the parameter bounds
bfm_pbounds;

% Initial income shares
s_labj = s_lab_lb + (s_lab_ub-s_lab_lb).*rand(ndraws,1);
s_pij = s_pi_m - (s_pi_m/(s_pi_m+s_cap_m))*(s_labj - s_lab_m);
s_capj = s_cap_m - (s_cap_m/(s_pi_m+s_cap_m))*(s_labj - s_lab_m);

% "Deep" parameters
sigmaj  = sigma_lb    + (sigma_ub  - sigma_lb) *rand(ndraws,1);
varphij = varphi_lb   + (varphi_ub - varphi_lb)*rand(ndraws,1);
etaj    = eta_lb      + (eta_ub    - eta_lb)   *rand(ndraws,1);

% Shocks' persistence
rhodj    = rhod_lb    + (rhod_ub    - rhod_lb)    *rand(ndraws,1);
rhoaltj  = rhoalt_lb  + (rhoalt_ub  - rhoalt_lb)  *rand(ndraws,1);
rhoaktj  = rhoakt_lb  + (rhoakt_ub  - rhoakt_lb)  *rand(ndraws,1);
rhomuptj = rhomupt_lb + (rhomupt_ub - rhomupt_lb) *rand(ndraws,1);
rhomuwtj = rhomuwt_lb + (rhomuwt_ub - rhomuwt_lb) *rand(ndraws,1);
rhoupstj = rhoupst_lb + (rhoupst_ub - rhoupst_lb) *rand(ndraws,1);
rhoalphaktj = rhoalphakt_lb + (rhoalphakt_ub - rhoalphakt_lb) *rand(ndraws,1);

% Additional parameters governing the "bells and whistles"
habj    =  hab_lb     + (hab_ub  - hab_lb) *rand(ndraws,1);
adcj    =  adc_lb     + (adc_ub  - adc_lb) *rand(ndraws,1);
utilj   =  util_lb    + (util_ub  - util_lb) *rand(ndraws,1);
thetapj =  thetap_lb  + (thetap_ub  - thetap_lb) *rand(ndraws,1);
thetawj =  thetaw_lb  + (thetaw_ub  - thetaw_lb) *rand(ndraws,1);
thetaij =  thetai_lb  + (thetai_ub  - thetai_lb) *rand(ndraws,1);
gammapj =  gammap_lb  + (gammap_ub  - gammap_lb) *rand(ndraws,1);
gammawj =  gammaw_lb  + (gammaw_ub  - gammaw_lb) *rand(ndraws,1);
gammaij =  gammai_lb  + (gammai_ub  - gammai_lb) *rand(ndraws,1);
rhoij   =  rhoi_lb    + (rhoi_ub  - rhoi_lb) *rand(ndraws,1);
rhopij  =  rhopi_lb   + (rhopi_ub  - rhopi_lb) *rand(ndraws,1);
rhoyj   =  rhoy_lb    + (rhoy_ub  - rhoy_lb) *rand(ndraws,1);

%% Shocks and variables to simulate
irf.shock = { ... % Choose shocks
    'e_d','e_alt','e_akt','e_mupt','e_muwt','e_upst','e_alphakt' ...
    };
irf.variable = { ... % Choose variables
   'ly' 'lgdp' 'lgdpr' 'lc' 'li' 'r' 'polr' 'lpip' ...
   'lw' 'll' 'rk' 'lk' 'U' 'lq' ...
   's_lab' 's_cap' 's_pi' 'lpi' 'lpr' ...
   'lmc' 'lpe' 'lpe2' 'lpr2' 'lnli' ...
   'ld' 'lal' 'lak' 'lmup' 'lmuw' 'lups' 'lalphak' ...
    };
for jj = 1:length(irf.variable)
    for kk = 1:length(irf.shock)
        irfs.(irf.variable{jj}).(irf.shock{kk}) = nan(ndraws,200);
    end
end

%% Monte Carlo simulations
for ii = 1:ndraws
    counter = counter + 1;
    waitbar(counter/ndraws,h,sprintf('%s %2.1f%s', 'Performing Monte Carlo simulations:', 100*ii/ndraws, '%'))
    
    s_labp = s_labj(ii);
    s_capp = s_capj(ii);
    s_pip = s_pij(ii);
    sigma = sigmaj(ii);
    varphi = varphij(ii);
    eta = etaj(ii);
    hab = habj(ii);
    adc = adcj(ii);
    util = utilj(ii);
    thetap = thetapj(ii);
    thetaw = thetawj(ii);
    thetai = thetaij(ii);
    gammap = gammapj(ii);
    gammaw = gammawj(ii);
    gammai = gammaij(ii);
    rhoi = rhoij(ii);
    rhopi = rhopij(ii);
    rhoy = rhoyj(ii);
    rhod    = rhodj(ii);
    rhoalt  = rhoaltj(ii);
    rhoakt  = rhoaktj(ii);
    rhomupt = rhomuptj(ii);
    rhomuwt = rhomuwtj(ii);
    rhoupst = rhoupstj(ii);
    rhoalphakt = rhoalphaktj(ii);
    try
        dynare bfm noclearall
        % The code below is only used for sanity checks
        [a,b]=lastwarn;
        if strcmp(b,'MATLAB:nearlySingularMatrix') == 1 || strcmp(b,'MATLAB:singularMatrix') == 1
            if exist('err_iter2', 'var') == 1
                err_iter2 = [err_iter2; ii];
            else
                err_iter2 = ii;
            end
            error('Singular matrix')
        end
        for jj = 1:length(irf.variable)
            for kk = 1:length(irf.shock)
                irfs.(irf.variable{jj}).(irf.shock{kk})(ii,:) = oo_.irfs.(strcat(irf.variable{jj},'_',irf.shock{kk}));
            end
        end
    catch
        if exist('err_iter', 'var') == 1
            err_iter = [err_iter; ii];
        else
            err_iter = ii;
        end
    end
    clearvars -except irf irfs err_iter err_iter2 counter ndraws h ...
        s_labj s_capj s_pij ...
        sigmaj varphij etaj ...
        habj adcj utilj thetapj thetawj thetaij gammapj gammawj gammaij rhoij rhopij rhoyj ...
        rhodj rhoaltj rhoaktj rhomuptj rhomuwtj rhoupstj rhoalphaktj
end

close(h)

save('irfdata_nk_test.mat','irfs','-v7.3')
clear irfs
save('irfinfo_nk_test.mat','-v7.3')
