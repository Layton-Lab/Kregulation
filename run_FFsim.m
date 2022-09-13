% run simulation experiements with and without FF effect
clear all;
close all;
% IDEA: run for 1 day of 3 meals....
%           or maybe a week of normal intake?

days = 50; % number of days to run the simulation for
%%%%%%%%%%%%%%%%%%
% simulation 1
% baseline model
%%%%%%%%%%%%%%%%%%
disp('**sim 1**')
pars1 = set_params();

Kin1.Kin_type = 'long_simulation'; % TO DO: CHECK WHAT THIS DOES!
Kin1.Meal = 1;
Kin1.KCL = 1;

MealInfo1.t_breakfast = 7;
MealInfo1.t_lunch = 13;
MealInfo1.t_dinner = 19;
MealInfo1.K_amount = 100/3; % how much K is ingested PER MEAL (3 times per day)
MealInfo1.meal_type = 'normal'; % TO DO: change to a "normal" meal type

do_FF1 = 1;
do_ins1 = 1;

% sim 1 SS condition
disp('get sim 1 SS')
IG_file1 = './IGdata/KregSS.mat';
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
                                           'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type}, ...
                                            'do_insulin', [do_ins1, pars1.insulin_A, pars1.insulin_B], ...
                                            'do_FF', [do_FF1, pars1.FF]);
if exitflag1 <=0
    disp('residuals')
    disp(residual1)
    error('******sim 1 SS did not converge*****')
end
disp('sim 1 SS finished')

%  run simulation 1
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = days*1440; 
tspan = t0:0.5:tf;

disp('start sim 1')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type}, ...
                                'do_insulin', [do_ins1, pars1.insulin_A, pars1.insulin_B], ...
                                'do_FF', [do_FF1, pars1.FF]), ...
                            tspan, x0, x_p0, opts);
disp('sim 1 finished')

%%%%%%%%%%%%%%%%%%
% simulation 2
% FF effect off
%%%%%%%%%%%%%%%%%%
disp('**sim 2**')
pars2 = set_params();

Kin2.Kin_type = 'long_simulation'; % TO DO: CHECK WHAT THIS DOES!
Kin2.Meal = 1;
Kin2.KCL = 1;

MealInfo2.t_breakfast = 7;
MealInfo2.t_lunch = 13;
MealInfo2.t_dinner = 19;
MealInfo2.K_amount = 100/3; % how much K is ingested PER MEAL (3 times per day)
MealInfo2.meal_type = 'normal'; % TO DO: change to a "normal" meal type

do_ins2 = 1;
do_FF2 = 0; % no FF effect

% sim 2 SS condition

disp('get sim 2 SS')
IG_file2 = './IGdata/KregSS.mat';
[SSdata2, exitflag2, residual2] = getSS(IG_file2, pars2, Kin2, ...
                                           'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type},...
                                            'do_insulin', [do_ins2, pars2.insulin_A, pars2.insulin_B], ...
                                            'do_FF', [do_FF2, pars2.FF]);
if exitflag2 <=0
    disp('residuals')
    disp(residual2)
    error('******sim 2 SS did not converge*******')
end
disp('sim 2 SS finished')

%  run simulation 2
opts = odeset('MaxStep', 20);
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));
t0 = 0;
tf = days*1440; 
tspan = t0:0.5:tf;

disp('start sim 2')
[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type}, ...
                                'do_insulin', [do_ins2, pars2.insulin_A, pars2.insulin_B], ...
                                'do_FF', [do_FF2, pars2.FF]), ...
                            tspan, x0, x_p0, opts);
disp('sim 2 finished')


% plot simulation
do_plt = 1;
if do_plt
    clear T X params Kin_opts MealInfo
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    MealInfo{1} = MealInfo1;
    MealInfo{2} = MealInfo2;
    params{1} = pars1;
    params{2} = pars2;
    T{1} = T1;
    T{2} = T2;
    X{1} = X1;
    X{2} = X2;
    labels{1} = 'baseline model';
    labels{2} = 'no GI feedforward effect';
    plot_FF_sim(T,X,params,Kin_opts,labels,tf,MealInfo,days)
end

