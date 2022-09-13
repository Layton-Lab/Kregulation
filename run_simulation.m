% This file runs and then plots two simulations based on given input
% for each of the simulations
clear all; close all; 

% these two are just placeholders for the get_PhiKin function. They are not
% used if Kin_type is not 'long simulation'
MealInfo1 = 0;
MealInfo2 = 0;

%% simulation 1
pars1 = set_params();

Kin1.Kin_type = 'gut_Kin3'; 
Kin1.Meal = 0;
Kin1.KCL = 1;

alt_sim1 = false;
do_ins = 1;
do_FF = 1;

% get SS intial condition
disp('get sim 1 SS')
IG_file1 = './IGdata/KregSS.mat';
disp('1')
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
                                            'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                           'do_FF', [do_FF, pars1.FF],...
                                           'alt_sim',alt_sim1);
disp('2')
if exitflag1 <=0
    disp('residuals')
    disp(residual1)
end
disp('sim 1 SS finished')

% run simulation 1
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = 1*1440 + pars1.tchange;%1*1440 + pars1.tchange;
tspan = t0:0.5:tf;

disp('start simulation 1')
%[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
%                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
%                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
%                                'do_FF', [do_FF, pars1.FF]), ...
%                tspan, x0, [], x_p0, [], opts);
disp('decic done')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'alt_sim', alt_sim1, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                'do_FF', [do_FF, pars1.FF]), ...
                        tspan, x0, x_p0, opts);
disp('simulation 1 finished')

%% simulation 2
disp('get sim 2 SS')
pars2 = set_params();

Kin2.Kin_type = 'gut_Kin3';%'gut_Kin';%'Preston_SS';
Kin2.Meal = 0;
Kin2.KCL = 1;

alt_sim2 = false;
urine = true;

do_ins = 1;
do_FF = 0;

MKX_type = 0; %0 if not doing MK cross talk, 1:dtKsec, 2:cdKsec,  3:cdKreab
MKX_slope = 0.1; % should be -0.1 for cdKreab

if MKX_type
    IG_file2 = './IGdata/KregSS_MK.mat';
else
    IG_file2 = './IGdata/KregSS.mat';
end

% get SS intitial condition
[SSdata2, exitflag2, residual2] = getSS(IG_file2, pars2, Kin2,...
                                'alt_sim',alt_sim2, ...
                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
                                'do_FF', [do_FF, pars2.FF], ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine);  

if exitflag2 <= 0
    disp(residual2)
end

% run simulation 2
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));
%fprintf('length of x_p0 %d \n', length(x_p0))

disp('start simulation 2')
[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'alt_sim', alt_sim2, ...
                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
                                'do_FF', [do_FF, pars2.FF],...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine), ...
                tspan, x0, x_p0, opts);

disp('simulation 2 finished')

%% plot simulation
do_plt = 1;
if do_plt
    clear params T X
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    params{1} = pars1;
    params{2} = pars2;
    MealInfo{1} = MealInfo1;
    MealInfo{2} = MealInfo2;
    T{1} = T1;
    T{2} = T2;
    X{1} = X1;
    X{2} = X2;
    labels{1} = 'original simulation';
    labels{2} = 'simulation 2';
    plot_simulation(T,X, params, Kin_opts, labels, tf, MealInfo)
    %plot_dMKgut_dt(T,X,params,labels,tf,Kin_opts,MealInfo) %plots dMKgut, dMKmuscle, Phi_ECtoIC and PhiICtoEC
    % the following part calculates K and MKgut at the end of the simulation, as well as delta total body K

%     for ii = 1:length(T{1})
%         if T{1}(ii)==0
%             totK1=X{1}(ii,2) + X{1}(ii,3) + X{1}(ii,4) + X{1}(ii, 5) + X{1}(ii, 6);% + X{1}(ii,1);
%             gut= X{1}(ii,1);
%             fprintf('Sim 1: t=0, MKgut=%f \n',gut)
%             fprintf('Sim 1: t=0, total body K=%f \n',totK1)
%         end
%     end
%     for ii = 1:length(T{2})
%         if T{2}(ii)==0
%             totK1_2=X{2}(ii,2) + X{2}(ii,3) + X{2}(ii,4) + X{2}(ii, 5) + X{2}(ii, 6);
%             fprintf('Sim 2: t=0, total body K=%f \n',totK1_2)
%         end
%     end
%     len1 = length(T{1});
%     totK2=X{1}(len1,2) + X{1}(len1,3) + X{1}(len1,4) + X{1}(len1, 5) + X{1}(len1, 6);% + X{1}(len1,1);
%     gut2=X{1}(len1,1);
%     fprintf('Sim1: t=end, total body K=%f \n',totK2)
%     fprintf('Sim1: t=end, MKgut=%f \n',gut2)
% 
%     len = length(T{1});
%     totK2_2=X{2}(len,2) + X{2}(len,3) + X{2}(len,4) + X{2}(len, 5) + X{2}(len, 6);
%     fprintf('Sim2: t=end, total body K=%f \n',totK2_2)
%     
%     fprintf('Sim 1: delta total body K=%f \n',totK2-totK1)
%     fprintf('Sim 2: delta total body K=%f \n',totK2_2-totK1_2)
end
