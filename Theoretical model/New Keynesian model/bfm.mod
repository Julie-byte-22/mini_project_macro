////////////////////////////////////////////////////
//                                                //
//         THE DECLINE OF THE LABOR SHARE:        //
//             NEW EMPIRICAL EVIDENCE             //
//                                                //
//              - THEORETICAL MODEL -             //
//                                                //
// D. BERGHOLT, F. FURLANETTO, N. MAFFEI-FACCIOLI //
//                 OCTOBER, 2020                  //
//                                                //
////////////////////////////////////////////////////

/*
This Dynare file contains the theoretical model used to establish
theory-robust sign restrictions in the SVAR model.
For questions and comments, please contact Drago Bergholt
(drago.bergholt@norges-bank.no).
*/
 
//------------------------------------------
//              Define setup
//------------------------------------------

/*
ONETIME = 1 for simple model simulation. Remember to also set
onetime = 1 in steady state file.

If ONETIME = 0 (and onetime = 0 in the steady state file),
then a full simulation of the impulse response distributions is requested.
This is needed in order to reproduce figures 2 and 3 in the main text.
*/
@#define ONETIME = 0

//------------------------------------------
//                Preamble
//------------------------------------------

var

GDP         // GDP deflated by the CPI
GDPr        // Constant price GDP
Y           // Gross output
C           // Consumption
I           // Final investment
X           // Raw investment
r           // Real interest rate
Pr          // Real profits
W           // Real wage
L           // Hours worked
rk          // Capital rental rate
K           // Capital
Lambda      // Marginal utility of consumption
Pi          // Relative price of investment
Q           // Tobin's Q (= Pi in the baseline)
U           // Capital utilization rate (= 1 in the baseline)
Kbar        // Effective capital (= K in the baseline)
epsilonp    // Elasticity of substitution, goods
epsilonw    // Elasticity of substitution, labor
MC          // Marginal costs
Mrk         // Goods markup
PIp         // Price inflation
PIw         // Wage inflation
PIi         // Investment price inflation
polr        // Nominal interest rate

s_lab       // Labor income share
s_cap       // Capital income share
s_pi        // Profit incom share
s_tot       // Sum of income shares (just included as a sanity check, s_tot = 1 always)
Pe          // Price of equity (not used)
Pe2         // Alternative price of equity (not used)
Pr2         // Alternative profit definition (not used)
NLI         // Non-labor income (see the appendix)

// Selected variables in logs
lgdp lgdpr ly lc li lx lpr
lw ll lk lq
lpi lmc lpip lpiw lpe lpe2 lpr2 lnli
ld lal lak lmup lmuw lups lalphak la

// Shocks
/*
For completeness, we include both temporary and permanent versions of all
supply shocks. This is done as follows: For the labor augmenting technology
shock Al, for example, we assume that log(Al) = log(Alc) + log(Alt), where
Alc is temporary and Alt is permanent. However, the temporary shocks are
shut down if a full IRF distribution is requested (ONETIME = 0).
*/
D Al Ak Mup Muw Upsilon alphal alphak A
@#if ONETIME == 1
Alc Akc Mupc Muwc Upsilonc alphakc
@#endif
Alt Akt Mupt Muwt Upsilont alphakt
zd zal zak zmup zmuw zups  zalphak

;

varexo
e_d
@#if ONETIME == 1
e_alc e_akc e_mupc e_muwc e_upsc e_alphakc
@#endif
e_alt e_akt e_mupt e_muwt e_upst e_alphakt
;

parameters
    betta sigma varphi Psi delta eta
    hab adc util util1
    xip gammap thetap
    xiw gammaw thetaw
    xii gammai thetai
    rhoi rhopi rhoy
    epsiloni

    @#if ONETIME == 1
    rhoalc rhoakc rhomupc rhomuwc rhoupsc rhoalphakc
    sigmaalc sigmaakc sigmamupc sigmamuwc sigmaupsc sigmaalphakc
    @#endif
    rhod rhoalt rhoakt rhomupt rhomuwt rhoupst rhoalphakt
    sigmad sigmaalt sigmaakt sigmamupt sigmamuwt sigmaupst sigmaalphakt

@#if ONETIME == 0
    s_labp s_capp s_pip
@#endif

;

// Calibration

@#if ONETIME == 1

@#else
set_param_value('s_labp',s_labp)
set_param_value('s_capp',s_capp)
set_param_value('s_pip',s_pip)
set_param_value('sigma',sigma)
set_param_value('varphi',varphi)
set_param_value('eta',eta)
set_param_value('hab',hab)
set_param_value('adc',adc)
set_param_value('util',util)
set_param_value('thetap',thetap)
set_param_value('thetaw',thetaw)
set_param_value('thetai',thetai)
set_param_value('gammap',gammap)
set_param_value('gammaw',gammaw)
set_param_value('gammai',gammai)
set_param_value('rhoi',rhoi)
set_param_value('rhopi',rhopi)
set_param_value('rhoy',rhoy)
set_param_value('rhod',rhod)
set_param_value('rhoalt',rhoalt)
set_param_value('rhoakt',rhoakt)
set_param_value('rhomupt',rhomupt)
set_param_value('rhomuwt',rhomuwt)
set_param_value('rhoupst',rhoupst)
set_param_value('rhoalphakt',rhoalphakt)
@#endif

//------------------------------------------
//                 Model
//------------------------------------------

model;

// Intermediate firm
(Y/A)^((eta - 1)/eta) = alphal * (Al*L)^((eta - 1)/eta) + alphak * (Ak*Kbar)^((eta - 1)/eta);
W  = MC * alphal * (A*Al)^((eta - 1)/eta) * (Y / L)^(1/eta);
rk = MC * alphak * (A*Ak)^((eta - 1)/eta) * (Y/Kbar)^(1/eta);

// Investment firm
I = Upsilon*X;
Pi = 1/Upsilon;
PIi = PIp*Pi/Pi(-1);

// Household
Lambda = D * (1 - hab)^sigma * (C - hab*C(-1))^(-sigma) * exp(-Psi * (1 - sigma) * L^(1 + varphi)/(1 + varphi));
Lambda = betta * (1 + r) * Lambda(+1);
Q = betta * (Lambda(+1)/Lambda) * (rk(+1)*U(+1) - (util1*(U(+1) - 1) + (util*util1/2)*(U(+1) - 1)^2)/Upsilon(+1) + Q(+1) * (1 - delta));
Pi = D * Q * (1 - (adc/2)*(I/I(-1) - 1)^2 - adc*(I/I(-1) - 1)*(I/I(-1))) + betta*(Lambda(+1)/Lambda)*D(+1)*Q(+1)*adc*(I(+1)/I - 1)*(I(+1)/I)^2;

/*
For variable capital utilization, uncomment the line
"rk = (util1 + util*util1*(U - 1))/Upsilon;". For fixed capital utilization
(the baseline), uncomment "U = 1;". One of these two lines most be
commented out.
*/
rk = (util1 + util*util1*(U - 1))/Upsilon;
// U = 1;

// Accounting
K = (1 - delta) * K(-1) + (1 - (adc/2)*(I/I(-1) - 1)^2)*D*I;
Kbar = U*K(-1);
Y = C + Pi*I + ((util1*(U - 1) + (util*util1/2)*(U - 1)^2)/Upsilon)*K(-1) + (xip/2)*(PIp/(PIp(-1)^gammap * STEADY_STATE(PIp)^(1 - gammap)) - 1)^2 * Y + (xiw/2)*(PIw/(PIp(-1)^gammaw * STEADY_STATE(PIp)^(1 - gammaw)) - 1)^2 * L + (xii/2)*(PIi/(PIp(-1)^gammai * STEADY_STATE(PIp)^(1 - gammai)) - 1)^2 * I;
GDP = C + Pi*I;
GDPr = C + I;
Pr = (1 - 1/Mrk)* Y - (xip/2)*(PIp/(PIp(-1)^gammap * STEADY_STATE(PIp)^(1 - gammap)) - 1)^2 * Y; //(1 - MC)*(1 + s_o)*GDP;
NLI = Pr + (rk*U - (util1*(U - 1) + (util*util1/2)*(U - 1)^2)/Upsilon) * K(-1);
Mrk = 1/MC;

// Sticky price/wage stuff (inactive in the baseline, can be activated in the m-file bfm_pbounds.m)
epsilonp = Mup/(Mup - 1);
(epsilonp - 1) = epsilonp * MC - xip * (PIp/(PIp(-1)^gammap * STEADY_STATE(PIp)^(1 - gammap)) - 1) * PIp/(PIp(-1)^gammap * STEADY_STATE(PIp)^(1 - gammap)) + betta * (Lambda(+1)/Lambda) * xip * (PIp(+1)/(PIp^gammap * STEADY_STATE(PIp)^(1 - gammap)) - 1) * (PIp(+1)/(PIp^gammap * STEADY_STATE(PIp)^(1 - gammap))) * Y(+1)/Y;
epsilonw = Muw/(Muw - 1);
(epsilonw - 1) * W = epsilonw * Psi * L^varphi * (C - hab*C(-1)) - xiw * (PIw/(PIp(-1)^gammaw * STEADY_STATE(PIp)^(1 - gammaw)) - 1) * PIw/(PIp(-1)^gammaw * STEADY_STATE(PIp)^(1 - gammaw)) + betta * (Lambda(+1)/Lambda) * xiw * (PIw(+1)/(PIp^gammaw * STEADY_STATE(PIp)^(1 - gammaw)) - 1) * (PIw(+1)/(PIp^gammaw * STEADY_STATE(PIp)^(1 - gammaw))) * (L(+1) / L);
PIw = PIp*W/W(-1);
1 + r = (1 + polr)/PIp(+1);
(1 + polr)/(1 + STEADY_STATE(polr)) = ((1 + polr(-1))/(1 + STEADY_STATE(polr)))^rhoi * ((PIp/STEADY_STATE(PIp))^rhopi * (GDPr/GDPr(-1))^rhoy)^(1 - rhoi);

1 + r = (Pe(+1) + Pr(+1))/Pe;
Pr2 = Y - W*L - Pi*I;
Pe2 = Pi*K;
lpe = log(Pe);
lpe2 = log(Pe2);
lpr2 = log(Pr2);

// Income shares
s_pi = Pr/GDP;
s_lab = (W * L - (xiw/2)*(PIw/(PIp(-1)^gammaw * STEADY_STATE(PIp)^(1 - gammaw)) - 1)^2 * L)/ GDP;
s_cap = (rk*U - (util1*(U - 1) + (util*util1/2)*(U - 1)^2)/Upsilon) * K(-1) / GDP;
s_tot = s_pi + s_lab + s_cap;

// Log variables
lgdp = log(GDP);
lgdpr = log(GDPr);
ly = log(Y);
lpr = log(Pr);
lc = log(C);
li = log(I);
lx = log(X);
lw = log(W);
ll = log(L);
lk = log(K(-1));
lq = log(Q);
lpi = log(Pi);
lpip = log(PIp);
lpiw = log(PIw);
lmc = log(MC);
lnli = log(NLI);

ld   = log(D);
lal = log(Al);
lak = log(Ak);
lmup = log(Mup);
lmuw = log(Muw);
lups = log(Upsilon);
lalphak   = log(alphak);
la = log(A);

// Shock processes
@#if ONETIME == 1
Al       = Alt*Alc;
Ak       = Akt*Akc;
Mup      = Mupt*Mupc;
Muw      = Muwt*Muwc;
Upsilon  = Upsilont*Upsilonc;
alphak = alphakt*alphakc;
@#else
Al       = Alt;
Ak       = Akt;
Mup      = Mupt;
Muw      = Muwt;
Upsilon  = Upsilont;
alphak = alphakt;
@#endif

alphal = STEADY_STATE(alphal) + STEADY_STATE(alphak) - alphak; //alphalt*alphalc;
A = 1 + 0*(alphak - STEADY_STATE(alphak));

@#if ONETIME == 1
Alc      = Alc(-1)^rhoalc * exp(sigmaalc*e_alc);
Akc      = Akc(-1)^rhoakc * exp(sigmaakc*e_akc);
Mupc     = Mupc(-1)^rhomupc * exp(sigmamupc*e_mupc);
Muwc     = Muwc(-1)^rhomuwc * exp(sigmamuwc*e_muwc);
Upsilonc = Upsilonc(-1)^rhoupsc * exp(sigmaupsc*e_upsc);
alphakc  = alphakc(-1)^rhoalphakc * exp(sigmaalphakc*e_alphakc);
@#endif

D        = D(-1)^rhod   * exp(zd);
Alt      = Alt(-1)      * exp(zal);
Akt      = Akt(-1)      * exp(zak);
Mupt     = Mupt(-1)     * exp(zmup);
Muwt     = Muwt(-1)     * exp(zmuw);
Upsilont = Upsilont(-1) * exp(zups);
alphakt  = alphakt(-1)  * exp(zalphak);
zd       = rhod   *zd(-1)   + sigmad   *e_d;
zal      = rhoalt*zal(-1)   + sigmaalt*e_alt;
zak      = rhoakt*zak(-1)   + sigmaakt*e_akt;
zmup     = rhomupt*zmup(-1) + sigmamupt*e_mupt;
zmuw     = rhomuwt*zmuw(-1) + sigmamuwt*e_muwt;
zups     = rhoupst*zups(-1) + sigmaupst*e_upst;
zalphak  = rhoalphakt*zalphak(-1) + sigmaalphakt*e_alphakt;
end;


//------------------------------------------
//               Steady State
//------------------------------------------

steady;
check;

//------------------------------------------
//                 Shocks
//------------------------------------------

    shocks;
        @#if ONETIME == 1
        var e_alc; stderr 1;
        var e_akc; stderr 1;
        var e_mupc; stderr 1;
        var e_muwc; stderr 1;
        var e_upsc; stderr 1;
        var e_alphakc; stderr 1;
        @#endif
        var e_d; stderr 1;
        var e_alt; stderr 1;
        var e_akt; stderr 1;
        var e_mupt; stderr 1;
        var e_muwt; stderr 1;
        var e_upst; stderr 1;
        var e_alphakt; stderr 1;
    end;

//------------------------------------------
//               Computation
//------------------------------------------
    
@#if ONETIME == 1
    stoch_simul(order=1,irf=1000,periods=0,nograph)
@#else
    stoch_simul(order=1,irf=200,periods=0,nograph,nocorr,nodecomposition,nofunctions,nomoments,noprint)
    ly lgdp lgdpr lc li r polr lpip
    lw ll rk lk U lq
    s_lab s_cap s_pi lpi lpr
	lmc lpe lpe2 lpr2 lnli
    ld lal lak lmup lmuw lups lalphak
@#endif
;
