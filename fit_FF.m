% This can be used to fit the FF parameter with the KCL only
% experiment from Preston et al 2015
% uses fit_KCL_Preston2015

pars = set_params();

FF_est = [0.2];%[0.689352 ];%[0.1];  
%results after fixing February 10 2022 bug:
% FF = 0.099991 at xi=1.1 
% FF = 0.099999 at xi = 2

lb = [0];
ub = [10];

start_res = fit_KCL_Preston2015(FF_est);
fprintf('starting residual %f \n', start_res)

do_optimization = 1;
if do_optimization
    options = optimset('Display', 'iter-detailed');
    Amat = []; bvec = []; Aeq = []; beq = []; nonlcon = [];

    [pars_min, fval, exitflag, output] =...
         fmincon(@fit_KCL_Preston2015, FF_est,...
                 Amat, bvec, Aeq, beq, ...
                 lb, ub,nonlcon, options);
    final_res = fit_KCL_Preston2015(pars_min(1));
    fprintf('Final Residual: %f \n', final_res)
    fprintf('FF: %f \n', pars_min(1))
end