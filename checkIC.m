% this can be used to check the consistency
% of the initial condition for the ODE solver

pars = set_params();


Kin.Kin_type = 'gut_Kin';
Kin.Meal = 1;
Kin.KCL  = 1;
MKX = 0; %MK crosstalk
MKX_slope = 0.1;


alt_sim = false; % run an alternative simulation (if set up)
if alt_sim
    disp('******doing alt_sim**********')
end

IG_dir = './IGData/';
if MKX
    IG_fname = 'KregSS_MK.mat';
else
    IG_fname = 'KregSS.mat';
end
IG_file = append(IG_dir, IG_fname);
[SSdata, exitflag, residual] = getSS(IG_file, pars, Kin,...
                                'alt_sim', alt_sim, ...
                                'do_M_K_crosstalk', [MKX, MKX_slope]);
                            
IC = SSdata;
t0 = 0;
yp0 = zeros(size(IC));
yp0_fixed = yp0;

[y0_new, yp0_new, resnrm] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'do_FF', [1, pars.FF],...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}), ...
                                t0, IC, [], yp0, yp0_fixed);