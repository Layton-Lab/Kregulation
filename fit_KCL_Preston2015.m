function rmse = fit_KCL_Preston2015(FF_param)
    % computes the difference between the 
    % Preston et al. 2015 KCL only experiment
    % for a given FF parameter
    % This is called by the file fit_FF.m
    
    FF = FF_param;
    
    Kin.Kin_type = 'gut_Kin3';%'gut_Kin3';
    Kin.Meal = 0;
    Kin.KCL = 1;
    
    % parameters
    pars = set_params(); % fixed parameters are in set_params()
    
    %% solve SS for initial condition 
    do_insulin = 0; % insulin effect off
    do_FF = 1; 
    do_MKX = 0; % MK crosstalk off
    MKX_slope = 0.1;
    
    IG_file = './IGData/KregSS.mat';
    [SSdata, exitflag, residual] = getSS(IG_file, pars, Kin, ...
                'do_insulin', [do_insulin, pars.insulin_A, pars.insulin_B],...
                'do_FF', [do_FF, FF],...
                'do_M_K_crosstalk', [do_MKX, MKX_slope]);
    
    x0 = SSdata;
    xp0 = zeros(length(x0), 1);
    
    %% solve DAE
    tchange = 100;
    t0 = 0;
    tf = 0.75*1440+tchange;
    tspan = t0:0.5:tf; %time vector
    
    opts = odeset('MaxStep', 20);
    
    sol = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                'do_insulin', [do_insulin, pars.insulin_A, pars.insulin_B], ...
                                'do_FF', [do_FF, FF],...
                                'do_M_K_crosstalk', [do_MKX, MKX_slope]), ...
                tspan, x0, xp0, opts);
    
    %% get data
    data = load('./Data/PrestonData.mat');
    
    % adjust for where experiment starts
    exp_start = pars.tchange + 60 + 6*60; 
    time_serum = data.time_serum + exp_start;
    time_UK = data.time_UK + exp_start;
    
    %% error from data points
    try
        temp = deval(sol, time_serum);
        serum_vals = temp(5, :);
        temp = deval(sol, time_UK);
        UK_vals = temp(28, :);
    
        show_plot = 1;
        if show_plot
            figure(16)
            plot(sol.x, sol.y(5,:), 'color', 'red')
            hold on
            plot(time_serum, data.KCL_serum_scaled, '^', 'markersize', 15, 'color', 'blue')
            plot(time_serum, serum_vals, '*', 'markersize', 15, 'color', 'red')
            title('Serum K concentration')
            hold off
        
            figure(17)
            plot(sol.x, sol.y(28, :), 'color', 'red')
            hold on
            plot(time_UK, data.KCL_UK_scaled, '^', 'markersize', 15, 'color', 'blue')
            plot(time_UK, UK_vals, '*', 'markersize', 15, 'color', 'red')
            title('UK values')
            hold off
        end % if show_plot
    
        %% residuals
        serum_res = serum_vals - data.KCL_serum_scaled';
        UK_res = UK_vals - data.KCL_UK_scaled';
    
        % scale by average data value 
        serum_res_scaled = serum_res./(mean(data.KCL_serum_scaled));
        UK_res_scaled = UK_res./(mean(data.KCL_UK_scaled));
    
        err = [UK_res_scaled, serum_res_scaled];
        %err = [UK_res]; % ECK fit is quite good, UK seems off, checking
        rmse = rms(err);
    catch
        fprintf('WARNING!!: parameter space breaks ODE solver...Setting RMSE to 1 \n')
        rmse = 1;
    end
end