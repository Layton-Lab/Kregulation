function f = k_reg_mod(t,x,x_p,pars,varargin)
% K regulation model equations


%% Retrieve variables by name
% amount K
M_Kgut                  = x(1);     M_Kgut_p        = x_p(1);
M_Kplasma               = x(2);     M_Kplasma_p     = x_p(2);
M_Kinterstial           = x(3);     M_KECF_other_p  = x_p(3);   %M_KECF_other_p is dM_Kinter/dt in the manuscript
M_Kmuscle               = x(4);     M_Kmuscle_p     = x_p(4);   %M_Kmuscle_p is dM_KIC/dt in the manuscript

% K concentration
K_plasma                = x(5);     
K_inter                 = x(6);     
K_ECFtotal              = x(7);
K_muscle                = x(8);

% K fluxes
Phi_ECF_diffusion       = x(9);   % Phi_ECF in the manuscript

eta_NKA                 = x(10);
rho_insulin             = x(11);
rho_al                  = x(12);

Phi_ECtoIC              = x(13);

Phi_ICtoEC              = x(14);

% kidney
Phi_filK                = x(15);
Phi_psKreab             = x(16);
Phi_mdK                 = x(17);

Phi_dtKsec              = x(18);
eta_dtKsec              = x(19);
gamma_al                = x(20);
gamma_Kin               = x(21);

Phi_dtK                 = x(22);

Phi_cdKsec              = x(23);
eta_cdKsec              = x(24);
lambda_al               = x(25);

Phi_cdKreab             = x(26);
eta_cdKreab             = x(27);

Phi_uK                  = x(28);

% aldosterone
C_al                    = x(29);
N_al                    = x(30);    N_al_p      = x_p(30);     
N_als                   = x(31);
xi_ksod                 = x(32);

omega_Kic               = x(33);

num_eq = pars.num_eq;
%% Get variable inputs
% default settings, varargin is used to change settings
SS = false; % compute SS solution
alt_sim = false; % use alternate equations
urine = true; %This is to turn on(true)/off(false) urinary excretion

% intake arguments 
Kin.Kin_type = 'gut_Kin3'; %'gut_Kin'; % 'step_Kin2';
Kin.Meal     = 0;
Kin.KCL      = 0;

do_insulin = true;
insulin_A = pars.insulin_A;
insulin_B = pars.insulin_B;
MK_crosstalk = false;
do_FF = true;
FF = pars.FF;
do_ALD_NKA = true;
do_ALD_sec = true;
fit_CDKreab = false; % if false will use pars cdKreab_A, cdKreab_B values
fit_P_ecf = false;
MealInfo.t_breakfast = 7; % default breakfast is at 7 am
MealInfo.t_lunch = 13; % default lunch is at 1 pm
MealInfo.t_dinner = 19; % default dinner is at 7 pm
MealInfo.K_amount = 35; % default K ingestions is 35mEq per meal
MealInfo.meal_type = 'normal';
for i = 1:2:length(varargin)
    if strcmp(varargin{i}, 'SS')
        SS = varargin{i+1};
    elseif strcmp(varargin{i}, 'urine')
        urine = varargin{i+1};
    elseif strcmp(varargin{i}, 'MealInfo')
        temp = varargin{i+1};
        MealInfo.t_breakfast = temp{1};
        MealInfo.t_lunch = temp{2};
        MealInfo.t_dinner = temp{3};
        MealInfo.K_amount = temp{4};
        MealInfo.meal_type = temp{5};
    elseif strcmp(varargin{i}, 'Kin_type')
        temp = varargin{i+1};
        Kin.Kin_type = temp{1};
        Kin.Meal     = temp{2};
        Kin.KCL      = temp{3};
    elseif strcmp(varargin{i}, 'alt_sim')
        alt_sim = varargin{i+1};
    elseif strcmp(varargin{i}, 'do_M_K_crosstalk')
        temp = varargin{i+1};
        MK_crosstalk = temp(1);
        M_K_crosstalk_slope = temp(2);
    elseif strcmp(varargin{i}, 'do_insulin')
        temp = varargin{i+1};
        do_insulin = temp(1);
        insulin_A = temp(2);
        insulin_B = temp(3);
    elseif strcmp(varargin{i}, 'fit_CDKreab')
        temp = varargin{i+1};
        fit_CDKreab = temp(1);
        cdKreab_A = temp(2);
    elseif strcmp(varargin{i}, 'fit_P_ecf')
        temp = varargin{i+1};
        fit_P_ecf = temp(1);
        P_ECF = temp(2);
    elseif strcmp(varargin{i}, 'do_FF')
        temp = varargin{i+1};
        do_FF = temp(1);
        FF = temp(2);
    elseif strcmp(varargin{i}, 'do_ALD_NKA')
        do_ALD_NKA = varargin{i+1};
    elseif strcmp(varargin{i}, 'do_ALD_sec')
        do_ALD_sec = varargin{i+1};
    else
        disp('WRONG VARARGIN INPUT')
        fprintf('What is this varargin input? %s \n', varargin{i})
        error('wrong varargin input')
    end % if
end %for

% Get Phi_Kin and t_insulin
[Phi_Kin, t_insulin] = get_PhiKin(t, SS, pars, Kin, MealInfo);

% set insulin level
C_insulin = get_Cinsulin(t_insulin, MealInfo, Kin);

%% Differential algebraic equation system f(t,x,xp) = 0

f = zeros(length(x),1);

% K amount
% ECF

f(1) = M_Kgut_p - ((1-pars.fecal_excretion)*Phi_Kin - pars.kgut*M_Kgut);
if urine
    f(2) = M_Kplasma_p - (pars.kgut*M_Kgut - Phi_ECF_diffusion - Phi_uK);
else
    f(2) = M_Kplasma_p - (pars.kgut*M_Kgut - Phi_ECF_diffusion); %turn off urinary
end
f(3) = M_KECF_other_p - (Phi_ECF_diffusion - Phi_ECtoIC + Phi_ICtoEC);
% ICF
f(4) = M_Kmuscle_p - (Phi_ECtoIC - Phi_ICtoEC);

% K concentration
f(5) = K_plasma - (M_Kplasma/pars.V_plasma);
f(6) = K_inter - (M_Kinterstial/pars.V_interstitial);
f(7) = K_ECFtotal - ((M_Kplasma + M_Kinterstial)/(pars.V_plasma + pars.V_interstitial)); % use this for ALD
f(8) = K_muscle - (M_Kmuscle/pars.V_muscle);

% ECF diffusion
if fit_P_ecf
    f(9) = Phi_ECF_diffusion - P_ECF*(K_plasma - K_inter);
else
    f(9) = Phi_ECF_diffusion - pars.P_ECF*(K_plasma - K_inter);
end

% flow ECtoIC
f(10) = Phi_ECtoIC - eta_NKA*(pars.Vmax * K_inter/(pars.Km + K_inter));

% flow ICtoEC
f(11) = Phi_ICtoEC - (pars.P_muscle*(K_muscle - K_inter));

% effects on NKA
f(12) = eta_NKA - (rho_insulin*rho_al);
if do_insulin
    f(13) = rho_insulin - get_rhoins(C_insulin, insulin_A, insulin_B);
else
    f(13) = rho_insulin - 1; %get_rhoins(C_insulin, insulin_A, insulin_B); 
end

if do_ALD_NKA
    f(14) = rho_al - (66.4 + 0.273*C_al)/89.6050;
else
    f(14) = rho_al - 1; 
end

% kidney
if urine
    f(15) = Phi_filK - (pars.GFR*K_plasma);
else
    f(15) = Phi_filK;
end
% proximal segments
f(16) = Phi_psKreab - (pars.etapsKreab * Phi_filK);
f(17) = Phi_mdK - (Phi_filK - Phi_psKreab);

% distal tubule
if urine
    f(18) = Phi_dtKsec - (pars.Phi_dtKsec_eq * eta_dtKsec);
else
    f(18) = Phi_dtKsec;
end
if MK_crosstalk == 1
    f(19) = eta_dtKsec - (gamma_al * gamma_Kin * omega_Kic);
else
    f(19) = eta_dtKsec - (gamma_al * gamma_Kin);
end

if do_ALD_sec
    %disp('****still need to fit dtsec params*****')
    f(20) = gamma_al - (pars.dtKsec_A * C_al ^ pars.dtKsec_B);
else
    f(20) = gamma_al - 1;
end

if do_FF 
% don't need do_FF because the Phi_Kin should do it for me?
% I guess could be used if separating the signals
    f(21) = gamma_Kin - max(1, getFF(M_Kgut, FF, pars));%max(1, (Kin.KCL*Feedforward*(Phi_Kin-pars.Phi_Kin_ss) + 1));
else
%     % don't want to set to 1 because being lower is important for getting
%     % the urinary K excretion low enougth to fit the data
    f(21) = gamma_Kin - 1;
end

if urine 
    f(22) = Phi_dtK - (Phi_mdK + Phi_dtKsec);
else 
    f(22) = Phi_dtK;
end

% collecting duct
if urine
    f(23) = Phi_cdKsec - (pars.Phi_cdKsec_eq * eta_cdKsec);
else 
    f(23) = Phi_cdKsec;
end
if MK_crosstalk == 2
    f(24) = eta_cdKsec - (lambda_al*omega_Kic);
else
    f(24) = eta_cdKsec - lambda_al;
end

if do_ALD_sec
    %disp('CD K secretion to be done!')
    f(25) = lambda_al - (pars.cdKsec_A * C_al ^ pars.cdKsec_B);
else
    f(25) = lambda_al - 1;
end


if fit_CDKreab   % parameters A and B are divided by 1000 and 100 respectively 
                 % because otherwise, when fitting the parameters, the
                 % steps would be too small. 
    %f(26) = Phi_cdKreab - ((cdKreab_A*Phi_dtK)/(cdKreab_B + Phi_dtK));
    %temp = (1/(1+exp((Phi_dtK-cdKreab_B/100)*cdKreab_A/1000)));
    temp = cdKreab_A;
    f(26) = Phi_cdKreab - Phi_dtK*temp*eta_cdKreab;
else
    %f(26) = Phi_cdKreab - ((pars.cdKreab_A*Phi_dtK)/(pars.cdKreab_B + Phi_dtK));
    %temp = (1/(1+exp((Phi_dtK-pars.cdKreab_B/100)*pars.cdKreab_A/1000)));
    temp = pars.cdKreab_A;
    f(26) = Phi_cdKreab - (Phi_dtK*temp*eta_cdKreab);
end

if MK_crosstalk == 3
    f(27) = eta_cdKreab - (1*omega_Kic);
else
    f(27) = eta_cdKreab - 1;
end

% urine   
%f(28) = Phi_uK - (Phi_dtK + Phi_cdKsec - Phi_cdKreab);
if urine
    f(28) = Phi_uK - (Phi_dtK + Phi_cdKsec - Phi_cdKreab);
else
    f(28)=Phi_uK;   % turn off urinary excretion
end
% Aldosteron
f(29) = C_al - (N_al * pars.ALD_eq);
f(30) = N_al_p - (1/pars.T_al*(N_als - N_al));
f(31) = N_als - (xi_ksod);
%f(32) = xi_ksod - max(0,((K_ECFtotal/pars.Csod)/(pars.Kec_baseline/144/(pars.xi_par+1))-pars.xi_par));
f(32) = xi_ksod - max(0,((K_ECFtotal/pars.Csod)/(pars.Kec_total/144/(pars.xi_par+1))-pars.xi_par));

if MK_crosstalk>0
    f(33) = omega_Kic - max(0,(M_K_crosstalk_slope*(K_muscle-pars.Kmuscle_baseline)+1));
else
    f(33) = omega_Kic - 1;
end

num_eq_done = 33;

if num_eq_done ~= num_eq
    disp("ERROR IN NUMBER OF EQ")
    disp([num_eq_done,num_eq])
end % if num_eq_done
end %k_reg_mod