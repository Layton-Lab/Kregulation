% run K+ depletion experiments
close all; clear all;

days = 50; 


% simulations 1 (baseline model -- no MKX)
pars1 = set_params();

Kin1.Kin_type = 'long_simulation'; % CHANGE THIS?
Kin1.Meal = 1;
Kin1.KCL = 1;

MealInfo1.t_breakfast = 7;
MealInfo1.t_lunch = 13;
MealInfo1.t_dinner = 19; 
MealInfo1.K_amount = 100/3; % how much K is ingested per meal
MealInfo1.meal_type = 'Kdeplete'; 

% get SS initial condition
disp('get sim 1 SS')
IG_file1 = './IGdata/KregSS.mat';
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1,...
                                            'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type});
if exitflag1 <= 0
    disp('residuals')
    disp(residual1)
end
disp('sim 1 SS finished')

% run simulation 1
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = days*1440;
tspan = t0:0.5:tf;

disp('start sim 1')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t, x, x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL},...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner, ...
                                                        MealInfo1.K_amount, MealInfo1.meal_type}), ...
                            tspan, x0, x_p0, opts);
disp('sim 1 finished')

% simulation 2 (dt K secretion MKX)
disp('get sim 2 SS')
pars2 = set_params();

Kin2.Kin_type = 'long_simulation';
Kin2.Meal = 1;
Kin2.KCL = 1;

MealInfo2.t_breakfast = 7;
MealInfo2.t_lunch = 13;
MealInfo2.t_dinner = 19;
MealInfo2.K_amount = 100/3;
MealInfo2.meal_type = 'Kdeplete';

MKX_type = 1;
MKX_slope = 0.1;

if MKX_type
    IG_file2 = './IGdata/KregSS_MK.mat';
else
    IG_file2 = './IGdata/KregSS.mat';
end

% get SS intitial condition
[SSdata2, exitflag2, residual2] = getSS(IG_file2, pars2, Kin2,...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type});  


if exitflag2 <= 0
    disp(residual2)
end

% run simulation 2
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));

disp('start simulation 2')
[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type}), ...
                            tspan, x0, x_p0, opts);

disp('simulation 2 finished')

% simulation 3 (cd K reabsorption MKX)
disp('get sim 3 SS')
pars3 = set_params();

Kin3.Kin_type = 'long_simulation';
Kin3.Meal = 1;
Kin3.KCL = 1;

MealInfo3.t_breakfast = 7;
MealInfo3.t_lunch = 13;
MealInfo3.t_dinner = 19;
MealInfo3.K_amount = 100/3;
MealInfo3.meal_type = 'Kdeplete';

MKX_type = 3;
MKX_slope = -0.1;

if MKX_type>0
    IG_file3 = './IGdata/KregSS_MK.mat';
else
    IG_file3 = './IGdata/KregSS.mat';
end

% get SS intitial condition
[SSdata3, exitflag3, residual3] = getSS(IG_file3, pars3, Kin3,...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'MealInfo', {MealInfo3.t_breakfast, MealInfo3.t_lunch, MealInfo3.t_dinner,...
                                                        MealInfo3.K_amount, MealInfo3.meal_type});  


if exitflag3 <= 0
    disp('residuals')
    disp(residual3)
end

% run simulation 3
x0 = SSdata3;
x_p0 = zeros(size(SSdata3));

disp('start simulation 3')
[T3,X3] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars3, ...
                                'Kin_type', {Kin3.Kin_type, Kin3.Meal, Kin3.KCL}, ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'MealInfo', {MealInfo3.t_breakfast, MealInfo3.t_lunch, MealInfo3.t_dinner,...
                                                        MealInfo3.K_amount, MealInfo3.meal_type}), ...
                            tspan, x0, x_p0, opts);

disp('simulation 3 finished')
                                                    
% plot simulation
do_plt = 1;
if do_plt
    clear T X params
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    Kin_opts{3} = Kin3;
    MealInfo{1} = MealInfo1;
    MealInfo{2} = MealInfo2;
    MealInfo{3} = MealInfo3;
    params{1} = pars1;
    params{2} = pars2;
    params{3} = pars3;
    T{1} = T1;
    T{2} = T2;
    T{3} = T3;
    X{1} = X1;
    X{2} = X2;
    X{3} = X3;
    labels{1} = 'baseline model';
    labels{2} = 'MKX-DT-sec';
    labels{3} = 'MKX-CD-reab';
    plot_Kdeplete(T,X,params,Kin_opts,labels,tf,MealInfo,days)
end % do_plt