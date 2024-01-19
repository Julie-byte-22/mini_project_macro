%% Recursive steady state solution

% Set onetime = 0 for a full simulation of the IRF distributions.
onetime = 0;

betta = 0.99;
delta = 0.025;

if onetime == 1
sigma = 3;
varphi = 3;
eta = 0.99;

hab = 0*0.75;
adc = 0*5;
util = 0.5;
thetap = 0*0.75;
thetaw = 0*0.75;
thetai = 0*0.75;
gammap = 0*0.5;
gammaw = 0*0.5;
gammai = 0*0.5;
rhoi = 0.45;
rhopi = 2;
rhoy = 0*0.125;

rhod    = 0.25;
rhoalt = 0.25;
rhoakt = 0.25;
rhomupt = 0.25;
rhomuwt = 0.25;
rhoupst = 0.25;
rhoalphakt = 0.25;

s_pi = 0.1;
s_lab = (1 - s_pi)*2/3;
s_cap = 1 - s_pi - s_lab;

else
    s_lab = s_labp;
    s_cap = s_capp;
    s_pi = s_pip;
end

s_tot = 1;
Mup = 1 / (1 - s_pi);

L = 1;
U = 1;
PIp = 1;
PIw = PIp;
PIi = PIp;
Al = 1;
D = 1;
A = 1;

epsilonp = Mup/(Mup - 1);
Muw = Mup;
epsilonw = Muw/(Muw - 1);
epsiloni = epsilonp;

Upsilon = 1;

r = (1/betta) - 1;
Pi = 1/Upsilon;
Q = Pi;
rk = Q*((1/betta) - (1 - delta));

alphak = s_cap/(1 - s_pi);
alphal = 1 - alphak; %s_lab/(1 - s_pi);
Ak = rk / s_cap; % * (Mup/alphak)^(eta/(eta - 1)) * s_cap^(1/(eta - 1));
Y = Al * L; % (alphal / (Mup * s_lab))^(eta/(eta - 1)) * Al * L;
W = s_lab * Y / L;
K = s_cap * Y / rk;
I = delta*K;
X = I/Upsilon;
C = Y - Pi*I;
GDP = Y;
GDPr = C + I;
Pr = (1 - 1/Mup)*GDP;

Psi = W / (Muw * L^varphi * (1 - hab) * C);
Lambda = C^(-sigma) * exp(-Psi * (1 - sigma) * L^(1 + varphi)/(1 + varphi));

Kbar = U*K;
util1 = rk*Upsilon;

xip = (epsilonp - 1) * thetap / ((1 - thetap) * (1 - betta * thetap));
xiw = (epsilonw - 1) * W * (1 + epsilonw*varphi) * thetaw / ((1 - thetaw) * (1 - betta * thetaw));
xii = (epsiloni - 1) * thetai / ((1 - thetai) * (1 - betta * thetai));
polr = (PIp/betta) - 1;
MC = 1/Mup;
Mrk = 1/MC;
Pr2 = Y - W*L - Pi*I;
Pe = Pr/r;
Pe2 = Pi*K;
NLI = Pr + rk*U*K;

lgdp = log(GDP);
lgdpr = log(GDPr);
ly = log(Y);
lpr = log(Pr);
lc = log(C);
li = log(I);
lx = log(X);
lw = log(W);
ll = log(L);
lk = log(K);
lq = log(Q);
lpi = log(Pi);
lpip = log(PIp);
lpiw = log(PIw);
lmc = log(MC);
lpe = log(Pe);
lpe2 = log(Pe2);
lpr2 = log(Pr2);
lnli = log(NLI);

ld   = log(D);
lal = log(Al);
lak = log(Ak);
lmup = log(Mup);
lmuw = log(Muw);
lups = log(Upsilon);
lalphak   = log(alphak);
la = log(A);

zd = 0;
zal = 0;
zak = 0;
zmup = 0;
zmuw = 0;
zups = 0;
zalphak = 0;

if onetime == 1
Alc = 1;
Akc = 1;
Mupc = 1;
Muwc = 1;
Upsilonc = 1;
alphakc = 1;
end
Alt = Al;
Akt = Ak;
Mupt = Mup;
Muwt = Muw;
Upsilont = Upsilon;
alphakt = alphak;

sigmad    = (1 - rhod)*1;
sigmaalt = (1 - rhoalt)*1;
sigmaakt = (1 - rhoakt)*1;
sigmamupt = (1 - rhomupt)*1;
sigmamuwt = (1 - rhomuwt)*1;
sigmaupst = (1 - rhoupst)*1;
sigmaalphakt = (1 - rhoalphakt)*1;
if onetime == 1
rhoalc = 0.75;
rhoakc = 0.75;
rhomupc = 0.75;
rhomuwc = 0.75;
rhoupsc = 0.75;
rhoalphakc = 0.75;
sigmaalc = 1;
sigmaakc = 1;
sigmamupc = 1;
sigmamuwc = 1;
sigmaupsc = 1;
sigmaalphakc = 1;
end
