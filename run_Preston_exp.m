clear all; close all; 
% run Meal only simulation
pars = set_params();

Kin1.Kin_type = 'gut_Kin3';
Kin1.Meal = 1;
Kin1.KCL = 0;

do_ins1 = 1;
do_FF1 = 1; % set at 1 because the Phi_Kin will give the right FF but 
% I do want to have the effect

% get SS intial condition
disp('get Meal SS')
IG_file1 = './IGdata/KregSS.mat';
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars, Kin1, ...
                                            'do_insulin', [do_ins1, pars.insulin_A, pars.insulin_B],...
                                            'do_FF', [do_FF1, pars.FF]);
                                        
if exitflag1 <=0
    disp('Meal SS did not converge')
    disp('residuals')
    disp(residual1)
end

% run Meal experiment
disp('start Meal simulation')
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = 1440 + pars.tchange;
tspan = t0:0.5:tf;

MealInfo1.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo1.t_lunch = 13;
MealInfo1.t_dinner = 19;
MealInfo1.K_amount = 120/3;  % how much K is ingested PER MEAL 3 times a day
MealInfo1.meal_type = 'other';

[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'do_insulin', [do_ins1, pars.insulin_A, pars.insulin_B],...
                                'do_FF', [do_FF1, pars.FF],...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                             MealInfo1.K_amount,MealInfo1.meal_type }), ...
                        tspan, x0, x_p0, opts);

disp('Meal simulation finished')

% run KCL only simulation
Kin2.Kin_type = 'gut_Kin3'; %'step_Kin2';
Kin2.Meal = 0;
Kin2.KCL = 1;

do_ins2 = 0;
do_FF2 = 1;

% get SS intial condition
disp('get KCL SS')
IG_file2 = './IGdata/KregSS.mat';
[SSdata2, exitflag2, residual2] = getSS(IG_file2, pars, Kin2, ...
                                            'do_insulin', [do_ins2, pars.insulin_A, pars.insulin_B],...
                                            'do_FF', [do_FF2, pars.FF]);
                                        
if exitflag2 <=0
    disp('KCL SS did not converge')
    disp('residuals')
    disp(residual2)
end

% run KCL experiment
disp('start KCL simulation')
opts = odeset('MaxStep', 20);
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));
t0 = 0;
tf = 1440 + pars.tchange;
tspan = t0:0.5:tf;

MealInfo2.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo2.t_lunch = 13;
MealInfo2.t_dinner = 19;
MealInfo2.K_amount = 120/3;  % how much K is ingested PER MEAL 3 times a day
MealInfo2.meal_type = 'other';

[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'do_insulin', [do_ins2, pars.insulin_A, pars.insulin_B],...
                                'do_FF', [do_FF2, pars.FF],...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type}), ...
                        tspan, x0, x_p0, opts);

disp('KCL simulation finished')

% run Meal + KCL experiment
Kin3.Kin_type = 'gut_Kin3'; %'step_Kin2';
Kin3.Meal = 1;
Kin3.KCL = 1;

do_ins3 = 1;
do_FF3 = 1;

% get SS intial condition
disp('get Meal + KCL SS')
IG_file3 = './IGdata/KregSS.mat';
[SSdata3, exitflag3, residual3] = getSS(IG_file3, pars, Kin3, ...
                                            'do_insulin', [do_ins3, pars.insulin_A, pars.insulin_B],...
                                            'do_FF', [do_FF3, pars.FF]);
                                        
if exitflag2 <=0
    disp('Meal + KCL SS did not converge')
    disp('residuals')
    disp(residual3)
end

% run KCL experiment
disp('start Meal + KCL simulation')
opts = odeset('MaxStep', 20);
x0 = SSdata3;
x_p0 = zeros(size(SSdata3));
t0 = 0;
tf = 1440 + pars.tchange;
tspan = t0:0.5:tf;

MealInfo3.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo3.t_lunch = 13;
MealInfo3.t_dinner = 19;
MealInfo3.K_amount = 120/3;  % how much K is ingested PER MEAL 3 times a day
MealInfo3.meal_type = 'other';

[T3,X3] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin3.Kin_type, Kin3.Meal, Kin2.KCL}, ...
                                'do_insulin', [do_ins3, pars.insulin_A, pars.insulin_B],...
                                'do_FF', [do_FF3, pars.FF],...
                                'MealInfo', {MealInfo3.t_breakfast, MealInfo3.t_lunch, MealInfo3.t_dinner,...
                                                        MealInfo3.K_amount,MealInfo3.meal_type}), ...
                        tspan, x0, x_p0, opts);
disp('Meal + KCL simulation finished')

%% set up for plotting
T = {T1, T2, T3};
X = {X1, X2, X3};
params = {pars, pars, pars};
Kin_opts = {Kin1, Kin2, Kin3};
MealInfo = {MealInfo1, MealInfo2, MealInfo3};
disp('** plotting results **')
%plot_Preston_exp(T, X, params, Kin_opts, MealInfo)
plot_Preston_manu(T, X, params, Kin_opts, MealInfo)
%plot_nicePreston(T, X, params, Kin_opts, MealInfo)