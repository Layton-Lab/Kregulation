% Calls fit_Meal_Preston2015 to fit
% the insulin_A and insulin_B parameters to the
% Meal (no KCL) data from Preston et al. 2015

pars = set_params();

pars_est = [pars.insulin_A; pars.insulin_B];

lb = [0; 0];
ub = [10; 100];

start_res = fit_Meal_Preston2015(pars_est);
fprintf('starting residual %f \n', start_res)

do_optimization = 1;
if do_optimization
    options = optimset('Display', 'iter-detailed');
    Amat = []; bvec = []; Aeq = []; beq = []; nonlcon = [];

    [pars_min, fval, exitflag, output] =...
         fmincon(@fit_Meal_Preston2015, pars_est,...
                 Amat, bvec, Aeq, beq, ...
                 lb, ub,nonlcon, options);
     final_res = fit_Meal_Preston2015(pars_min);
     fprintf('final residual %f \n', final_res)
     fprintf('insulin_A: %f \n', pars_min(1))
     fprintf('insulin_B: %f \n', pars_min(2))
end
 
 
 % some results
%  insulin_A: 0.601825 
% insulin_B: 77.778048 

%insulin_A: 0.576538 
%insulin_B: 79.435217 

% it seems that this fit is okay... I think the main thing is the ALD, etc
% this doesn't seem like as is can be optimized much more?

% newest results (February 10 2022): 
% xi = 1.1
% insulin_A = 0.804705 
% insulin_B = 0.729958 

% xi = 2
% insulin_A = 2.282925   
% insulin_B = 0.721553  

% new Vmax, Km and P_ECF:
% insulin_A = 0.804699
% insulin_B = 0.729956