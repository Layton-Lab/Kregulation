close all
pars = set_params();

global ind
ind = 1;

%pars_est = [pars.FF; pars.insulin_A; pars.insulin_B; pars.cdKreab_A; pars.cdKreab_B]; %FF, insulin_A, insulin_B, A_cdKreab, B_cdKreab
pars_est = [0.2; 0.0804699; 0.729956; 0.1680; 0.5]; % diff initial guess % FF = 0.1 works
%pars_est = [0.3840; 0.749002; 0.792657; 0.2385; 0.3412]; % diff initial guess % FF = 0.1 works

%pars_est = [0.1553;0.9802;0.6823;0.5734;0.4533];
%pars_est = [0.2;0.999045;0.666411;0.544385;0.477418];  
%pars_est = [0.250274;1;0.6753;0.295650;0.472825];  
pars_est = [0.250274;1;0.6753;0.295650;0.472825];

lb = [0; 0; 0; 0; 0];
ub = [1; 1.5; 100; 1; 1];  % noticed that cdKreab parameters in setparam are VERY small; 
start_res = fit_KCLandMeal_Preston2015(pars_est);  %% could have another external script that will add all residuals together
fprintf('starting residual %f \n', start_res)

do_optimization = 1;
if do_optimization
    options = optimset('Display', 'iter-detailed','PlotFcn','optimplotFval', 'MaxFunEvals',20000,'OutputFcn',@myoutfunc);
    %options = optimset('Display', 'iter-detailed','PlotFcn','optimplotFval', 'MaxFunEvals',20000);
    Amat = []; bvec = []; Aeq = []; beq = []; nonlcon = [];

    [pars_min, fval, exitflag, output] =...
                     fmincon(@fit_KCLandMeal_Preston2015, pars_est,... 
                     Amat, bvec, Aeq, beq, ...
                     lb, ub,nonlcon, options);
%                 fmincon(@(p) fit_KCLandMeal_Preston2015(p), pars_est, ...  % p = intermediate parameters
%                     Amat, bvec, Aeq, beq, ...
%                     lb, ub,nonlcon, options);
end
     fprintf('exitflag = %f \n',exitflag)
     final_res = fit_KCLandMeal_Preston2015(pars_min);
     fprintf('starting residual %f \n', start_res)
     fprintf('final residual %f \n', final_res)
     fprintf('FF: %f \n', pars_min(1))
     fprintf('insulin_A: %f \n', pars_min(2))
     fprintf('insulin_B: %f \n', pars_min(3))
     fprintf('A_cd_Kreab: %f \n', pars_min(4))
     fprintf('B_cd_Kreab: %f \n', pars_min(5))

function stop = myoutfunc(p, OptimVal, state)
% this function creates a file for every set of parameters tried by fmincon
% and saves it in Intermediate folder
    stop = false;
    %fprintf('OptimVal = %f',OptimVal)
     if strcmp(state,'iter')

         global ind
         parameters = {1, p(1), p(2), p(3), p(4), p(5)};
         parameters = parameters';
         parNames = {'Iteration','FF','ins_A','ins_B','cdKreab_A','cdKreab_B'};
         pars_table = array2table(parameters,'RowNames',parNames);
         pars_filename_temp = sprintf('Params%d.mat',ind);
         pars_filename = fullfile('Intermediate',pars_filename_temp);%'Params.mat');  % NEEDS a folder named intermediate
         save(pars_filename, 'parameters','pars_table') % could try to change the name or output as a text file
         
         ind = ind+1;
    end 
end

