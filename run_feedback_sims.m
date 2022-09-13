% run simulation experiements with and without FF effect
clear all;
%close all;
% IDEA: run for 1 day of 3 meals....
%           or maybe a week of normal intake?
%%%%    Begin User Input %%%%%%%
days = 10; % number of days to run the simulation for
% sim 1 options
label1 = 'baseline model';
do_FF1 = 1;
do_ins1 = 1;
do_ALD_NKA1 = 1;
do_ALD_sec1 = 1;
sim1 = [do_FF1, do_ins1, do_ALD_NKA1, do_ALD_sec1];
% sim 2 options
label2 = 'only GI FF off';
do_ins2 = 1;
do_FF2 = 0; % 
do_ALD_NKA2 = 1; % ALD effect on NKATPase
do_ALD_sec2 = 1; % ALD effect on DT K sec
sim2 = [do_FF2, do_ins2, do_ALD_NKA2, do_ALD_sec2];
% sim 3 options
label3 = 'only ALD NKA off';
do_ins3 = 1; % no insulin effect
do_FF3 = 1; % no FF effect
do_ALD_NKA3 = 0; % ALD effect on NKATPase
do_ALD_sec3 = 1; % ALD effect on DT K sec
sim3 = [do_FF3, do_ins3, do_ALD_NKA3, do_ALD_sec3];
% sim 4 options
label4 = 'only insulin off';
do_ins4 = 0; % no insulin effect
do_FF4 = 1; %  FF effect
do_ALD_NKA4 = 1; % ALD effect on NKATPase
do_ALD_sec4 = 1; % ALD effect on DT K sec
sim4 = [do_FF4, do_ins4, do_ALD_NKA4, do_ALD_sec4];
% sim 5 options
label5 = 'all feedbacks off';
do_ins5 = 0; 
do_FF5 = 0;
do_ALD_NKA5 = 0;
do_ALD_sec5 = 0;
sim5 = [do_FF5, do_ins5, do_ALD_NKA5, do_ALD_sec5];
%%%% end user input %%%%%%%%

sims = [sim1;
        sim2;
        sim3;
        sim4;
        sim5];

X = {};
T = {};
days = 10;

for ii = 1:size(sims,1)
    fprintf('simulation %i \n', ii)
    [T{ii}, X{ii}] = feedback_sim(sims(ii,:), days);
end

labels = {label1, label2,label3, label4,label5};
MealInfo.t_breakfast = 7;
MealInfo.t_lunch = 13;
MealInfo.t_dinner = 19;
MealInfo.K_amount = 100/3;
MealInfo.meal_type = 'normal';
Kin.Kin_type = 'long_simulation';
Kin.Meal = 1;
Kin.KCL = 1;
pars = set_params();

plot_5_sims(T,X,pars,Kin,labels,MealInfo,days)


function [T, X] = feedback_sim(sim, days)
    doFF     = sim(1);
    doINS    = sim(2);
    doALDNKA = sim(3);
    doALDsec = sim(4);


    pars = set_params();
    Kin.Kin_type = 'long_simulation';
    Kin.Meal = 1;
    Kin.KCL = 1;

    MealInfo.t_breakfast = 7;
    MealInfo.t_lunch = 13;
    MealInfo.t_dinner = 19;
    MealInfo.K_amount = 100/3;
    MealInfo.meal_type = 'normal';
    disp('get SS')
    IG_file = './IGdata/KregSS.mat';
    [SSdata, exitflag, residual] = getSS(IG_file, pars, Kin, ...
                                            'MealInfo', {MealInfo.t_breakfast, MealInfo.t_lunch, MealInfo.t_dinner, ...
                                                            MealInfo.K_amount, MealInfo.meal_type}, ...
                                            'do_insulin', [doINS, pars.insulin_A, pars.insulin_B], ...
                                            'do_FF', [doFF, pars.FF], ...
                                            'do_ALD_NKA', doALDNKA, ...
                                            'do_ALD_sec', doALDsec);
    if exitflag <= 0
        disp('residuals')
        disp(residual)
        error('sim SS did not converge')
    end
    disp('SS solved')

    % run simulation
    opts = odeset('MaxStep', 20);
    x0 = SSdata;
    x_p0 = zeros(size(SSdata));
    t0 = 0;
    tf = days*1440;
    tspan = t0:0.5:tf;
    disp('run sim')
    [T, X] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p,pars,...
                                            'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                            'MealInfo', {MealInfo.t_breakfast, MealInfo.t_lunch, MealInfo.t_dinner, ...
                                                                MealInfo.K_amount, MealInfo.meal_type}, ...
                                            'do_insulin', [doINS, pars.insulin_A, pars.insulin_B], ...
                                            'do_FF', [doFF, pars.FF], ...
                                            'do_ALD_NKA', doALDNKA, ...
                                            'do_ALD_sec', doALDsec), ...
                                        tspan, x0, x_p0, opts);
    disp('simulation finished')
end % feedback sim



