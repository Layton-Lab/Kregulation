function pars = set_params()
% this file sets the current parameter values 
pars.num_eq           =  33;

%% K intake at SS
pars.Phi_Kin_ss        = 70/1440; %100/1440; %mEq/min, steady state for Phi_Kin (Preston 2015)
pars.t_insulin_ss      = 270; % ss t_insulin value
pars.tchange           = 100; % time to change toward fasting

%% gut parameters
pars.fecal_excretion = 0.1;
pars.kgut = 0.01;
pars.MKgutSS = (0.9*pars.Phi_Kin_ss)/pars.kgut;
%% volumes
pars.V_plasma          = 4.5;%2.0;%5.0; %plasma fluid volume (L)
pars.V_interstitial    = 10; % interstitial ECF volume (L)
%pars.V_ecf_total       =  pars.V_plasma + pars.V_interstitial;%15.0; %15; %extracellular fluid volume L
pars.V_muscle          = 24; %19.0; % intracellular fluid volume (L)

%% baseline concentrations
pars.Kec_baseline      = 4.3;%4.5; % baseline ECF K concentration (total) mEq/L
pars.Kec_total    = 4.2;%4.3;%4.5;
pars.P_ECF             = 0.3;%0.5;%0.8;%0.1; % this parameter will have to be fit I think

pars.Kmuscle_baseline       = 130; %145.0; % baseline muscle concentration mEq/L
%% NKA activity values
pars.Vmax              = 130;%134; % mmol/min Cheng 2013
pars.Km                = 1.4;%1.0;%1.3; % mmol/L (Cheng 2013 gives between 0.8 and 1.5)

%% compute permeability values
NKA_baseline = pars.Vmax*pars.Kec_baseline/(pars.Km + pars.Kec_baseline);
pars.P_muscle = (NKA_baseline)/(pars.Kmuscle_baseline - pars.Kec_baseline);


%% Kidney
pars.GFR   = 0.125; %GFR L/min
pars.etapsKreab = 0.92; % fractional ps K reabsorption, fixed constant

pars.Phi_dtKsec_eq = 0.041;%0.025; %0.03; %0.05375; % 10% of PhifilK %0.075; %0.07655; %0.084;% (from Layton & Layton epithelial trasport),
pars.dtKsec_A = 0.3475;
pars.dtKsec_B = 0.23792;

pars.Phi_cdKsec_eq = 0.0022;%0.01; %0.026875; %0.0075;% % (from Layton & Layton epithelial
%transport), works for Phi_Kin = 100 mEq/day
%pars.Phi_cdKsec_eq = 0.0075*0.8; % for Phi_Kin = 60;
pars.cdKsec_A = 0.161275;
pars.cdKsec_B = 0.410711;


%% parameters A and B are divided by 1000 and 100 respectively in k_reg_mod
% because otherwise, when fitting the parameters, the steps would be too small. 
pars.cdKreab_A = 0.294864;%0.000294864*1000; 0.00075*1000; %0.0057; 
pars.cdKreab_B = 0.473015;%0.473015*100; 0.0054*100; %0.0068508; 

%% ALD
pars.ALD_eq = 85; % ng/L
pars.T_al = 60; % ALD half life (min)
pars.Csod = 144; % sodium concentration mEq/L
pars.xi_par = 2;%1.1;%3.0; %lower xi_pars makes C_al less sensitive

%% effects
pars.FF = 0.250274; %0.1;

pars.insulin_A = 0.999789;%0.804705; %0.378648; %0.174167; 
pars.insulin_B =  0.6645;% 0.676097;%0.729958; %0.872936; %0.945720; 
%% variable names
pars.varnames = {'M_{Kgut}','M_{Kplasma}', 'M_{Kinterstial}', 'M_{Kmuscle}', ...
                    'K_{plasma}', 'K_{inter}', 'K_{ECF-total}', 'K_{muscle}', ...
                    'Phi_{ECF-diffusion}', 'eta_{NKA}', 'rho_{insulin}', 'rho_{al}', ...
                    'Phi_{ECtoIC-muscle}', 'Phi_{ICtoEC-muscle}', ...
                    'Phi_{filK}', 'Phi_{psKreab}', 'Phi_{mdK}', ...
                    'Phi_{dtKsec}', 'eta_{dtKsec}', 'gamma_{al}', 'gamma_{Kin}', ...
                    'Phi_{dtK}', 'Phi_{cdKsec}', 'eta_{cdKsec}', 'lambda_{al}', ...
                    'Phi_{cdKreab}', 'eta_{cdKreab}', 'Phi_{uK}', ...
                    'C_{al}', 'N_{al}', 'N_{als}', 'xi_{ksod}', ...
                    'omega_{Kic}'}; % omega Kic is just 1 when not using MK crosstalk
end %set_params