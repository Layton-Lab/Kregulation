function rmse = fit_Meal_Preston2015(insulin_params)
    % computes the difference between the 
    % Preston et al. 2015 Meal only experiment
    % for given insulin parameters
    % This is used by the file fit_insulin.m
    
    insulin_A = insulin_params(1)
    insulin_B = insulin_params(2)
    
    do_insulin = true;
    Kin.Kin_type = 'gut_Kin3';
    Kin.Meal = 1;
    Kin.KCL = 0;
    
    % parameters
    pars = set_params(); % fixed parameters are in set_params()
    
    %% solve SS for initial condition 
    do_insulin = 1;
    do_FF = 0; % FF off
    do_MKX = 0; % MK crosstalk off
    MKX_slope = 0.1;
    
    IG_file = './IGData/KregSS.mat';
    [SSdata, exitflag, residual] = getSS(IG_file, pars, Kin, ...
                'do_insulin', [do_insulin, insulin_A, insulin_B],...
                'do_FF', [do_FF, pars.FF],...
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
                                'do_insulin', [do_insulin, insulin_A, insulin_B], ...
                                'do_FF', [do_FF, pars.FF],...
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
            plot(time_serum, data.Meal_serum_scaled, '^', 'markersize', 15, 'color', 'blue')
            plot(time_serum, serum_vals, '*', 'markersize', 15, 'color', 'red')
            title('ECK values')
            hold off

            figure(17)
            plot(sol.x, sol.y(28, :), 'color', 'red')
            hold on
            plot(time_UK, data.Meal_UK_scaled, '^', 'markersize', 15, 'color', 'blue')
            plot(time_UK, UK_vals, '*', 'markersize', 15, 'color', 'red')
            title('UK values')
            hold off
        end % if show_plot

        %% residuals
        serum_res = serum_vals - data.Meal_serum_scaled';
        UK_res = UK_vals - data.Meal_UK_scaled';

        % scale by average data value 
        serum_res_scaled = serum_res./(mean(data.Meal_serum_scaled));
        UK_res_scaled = UK_res./(mean(data.Meal_UK_scaled));

        err = [UK_res_scaled, serum_res_scaled];
        rmse = rms(err);
        %fprintf('rmse: %f\n', rmse)
    catch
        fprintf('WARNING!!: parameter space breaks ODE solver...Setting RMSE to 1 \n')
        rmse = 1;
    end
end