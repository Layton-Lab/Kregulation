function [SSdata, exitflag, residual] = getSS(IG_file, pars, Kin, varargin)
% Computes the SS solution of k_reg_mod based on given inputs
%disp('getSS.m')
num_eq = pars.num_eq;

% default options
do_insulin = true;
do_FF = true;
fit_CDKreab = false; % if false will use pars cdKreab_A, cdKreab_B values
fit_P_ecf = false;
alt_sim = false;
urine = true; %This is to turn on(true)/off(false) urinary excretion

do_ALD_NKA = true;
do_ALD_sec = true;
do_MKX = 0;



cdKreab_A = pars.cdKreab_A;
cdKreab_B = pars.cdKreab_B;
insulin_A = pars.insulin_A;
insulin_B = pars.insulin_B;
FF_A = pars.FF;
P_ECF = pars.P_ECF;
M_K_crosstalk = 0;
MK_slope = 0.1;
MealInfo.t_breakfast = 7; % default breakfast is at 7 am
MealInfo.t_lunch = 13; % default lunch is at 1 pm
MealInfo.t_dinner = 19; % default dinner is at 7 pm
MealInfo.K_amount = 35; % default K ingested per meal
MealInfo.meal_type = 'other';

for i = 1:2:length(varargin)
    if strcmp(varargin{i}, 'SS')
        SS = varargin{i+1};
    elseif strcmp(varargin{i}, 'urine')
        urine = varargin{i+1};
    elseif strcmp(varargin{i}, 'Kin_type')
        temp = varargin{i+1};
        Kin.Kin_type = temp{1};
        Kin.Meal     = temp{2};
        Kin.KCL      = temp{3};
    elseif strcmp(varargin{i}, 'MealInfo')
        temp = varargin{i+1};
        MealInfo.t_breakfast = temp{1};
        MealInfo.t_lunch = temp{2};
        MealInfo.t_dinner = temp{3};
        MealInfo.K_amount = temp{4};
        MealInfo.meal_type = temp{5};
    elseif strcmp(varargin{i}, 'alt_sim')
        alt_sim = varargin{i+1};
    elseif strcmp(varargin{i}, 'do_insulin')
        temp = varargin{i+1};
        do_insulin = temp(1);
        insulin_A = temp(2);
        insulin_B = temp(3);
    elseif strcmp(varargin{i}, 'fit_CDKreab')
        temp = varargin{i+1};
        fit_CDKreab = temp(1);
        cdKreab_A = temp(2);
        cdKreab_B = temp(3);
    elseif strcmp(varargin{i}, 'fit_P_ecf')
        temp = varargin{i+1};
        fit_P_ecf = temp(1);
        P_ECF = temp(2);
    elseif strcmp(varargin{i}, 'do_FF')
        temp = varargin{i+1};
        do_FF = temp(1);
        FF_A = temp(2);
    elseif strcmp(varargin{i}, 'do_ALD_NKA')
        do_ALD_NKA = varargin{i+1};
    elseif strcmp(varargin{i}, 'do_ALD_sec')
        do_ALD_sec = varargin{i+1};
    elseif strcmp(varargin{i}, 'do_M_K_crosstalk')
        temp = varargin{i+1};
        M_K_crosstalk = temp(1);
        MK_slope = temp(2);
%         if M_K_crosstalk
%             num_eq = num_eq + 1;
%         end
    else
        disp('WRONG VARARGIN INPUT')
        fprintf('What is this varargin input? %s \n', varargin{i})
    end % if
end %for

x_p0 = zeros(num_eq, 1); % SS derivatives are 0

% load data for initial guess
load(sprintf(IG_file, 'IG'));
if length(IG) < num_eq
    temp = zeros(num_eq - length(IG), 1);
    x0 = [IG; temp];
else
    x0 = IG(1:num_eq);
end %if
%x0 = [1; IG];


if alt_sim
    disp('**doing alt_sim***')
end
   
%% solve steady state
%options = optimset('Display', 'off', 'MaxFunEvals', 1e8, ...
%    'MaxIter', 4e5);
%options = optimset('Display', 'iter-detailed', 'MaxFunEvals', 1e8, ...
%    'MaxIter', 4e5);
%disp('getSS.m 2')  
options = optimoptions('fsolve','Display', 'iter-detailed');
[SSdata, residual,...
    exitflag, output] = fsolve(@(x) k_reg_mod(0, x, x_p0, pars, ...
                                'SS', true, ...
                                'do_insulin', [do_insulin, insulin_A, insulin_B],...
                                'do_FF', [do_FF, FF_A],...
                                'fit_CDKreab', [fit_CDKreab, cdKreab_A, cdKreab_B],...
                                'fit_P_ecf', [fit_P_ecf, P_ECF],...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                'do_ALD_NKA', do_ALD_NKA,...
                                'do_ALD_sec', do_ALD_sec,...
                                'do_M_K_crosstalk', [M_K_crosstalk, MK_slope], ...
                                'alt_sim', alt_sim,...
                                'MealInfo', {MealInfo.t_breakfast, MealInfo.t_lunch, MealInfo.t_dinner, ...
                                             MealInfo.K_amount, MealInfo.meal_type}), ...
                        x0, options);
%disp('getSS.m 3')                 
%% check for solver convergence
if exitflag <= 0
    disp('************steady state solver did NOT converge.**********')
%else
    %disp('steady state solver did converge.')
    %size(SSdata)
    %size(x0)
end % convergence

% check for imaginary solution
if not(isreal(SSdata))
    disp('Imaginary number returned.')
    imag_num = 1;
else
    imag_num = 0;
end

% which values are imaginary
if imag_num
    for jj = 1:length(SSdata)
        if ~isreal(SSdata(jj))
            temp = SSdata(jj);
            if (abs(imag(temp)) < eps)
                SSdata(jj) = real(temp);
            else
                disp('imaginary number')
                disp(jj)
            end %if abs(SSdata)
        end %if ~isreal
    end %for
end %if imag_num

% check for imaginary solution
if not(isreal(SSdata))
    disp('Imaginary number larger than eps returned.')
elseif (imag_num == 1)
    disp('Imaginary numbers all less than machine precision.')
end

% set any values within machine precision of 0 to 0
for ii = 1:length(SSdata)
    if abs(SSdata(ii)) < eps
        SSdata(ii) = 0;
    end
end %for


end %getSS