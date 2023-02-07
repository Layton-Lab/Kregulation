function nrmse = fit_KCLandMeal_Preston2015(params)
    % computes the difference between the 
    % Preston et al. 2015 Meal and KCL experiment, KCL experiment and Meal
    % experiment for given parameters
    % This is used by the file fit_params.m

    %% line 139, 176, 177 replace temp_time with time_UK to bring back the removed datapoint
    %% parameters
    pars = set_params(); % fixed parameters are in set_params()
    
    FF = params(1)
    insulin_A = params(2)
    insulin_B = params(3)
    cdKreab_A = params(4)
    cdKreab_B = params(5)

    %% KCL and Meal
    %do_insulin = true;
    Kin.Kin_type = 'gut_Kin3';
    Kin.Meal = 1;
    Kin.KCL = 1;
    
    %% solve SS for initial condition 
    do_insulin = 1; % insulin on
    do_FF = 1; % FF on
    fit_cdKreab = true; % fit cdKreab parameters A and B
    do_MKX = 0;%0; % MK crosstalk off
    MKX_slope = 0.1;
    
    IG_file = './IGData/KregSS.mat';
    [SSdata_both, ~, ~] = getSS(IG_file, pars, Kin, ...
                'do_insulin', [do_insulin, insulin_A, insulin_B],...
                'do_FF', [do_FF, FF],...
                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B],...
                'do_M_K_crosstalk', [do_MKX, MKX_slope]);

    %% check if SS for [K] serum is within 4.0-4.3; could have as a warning or an error

    x0_both = SSdata_both;
    xp0_both = zeros(length(x0_both), 1);

    %% solve DAE
    tchange = 100;
    t0 = 0;
    tf = 0.75*1440+tchange;
    tspan = t0:0.5:tf; %time vector  
    
    opts = odeset('MaxStep', 20);
    %opts = optimoptions(@ode15i,'Display', 'iter-detailed');
    sol_both = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                'do_insulin', [do_insulin, insulin_A, insulin_B], ...
                                'do_FF', [do_FF, FF],...
                                'do_M_K_crosstalk', [do_MKX, MKX_slope], ...
                                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B]),...
                tspan, x0_both, xp0_both, opts);
    
    %% Meal only 
    %do_insulin = true;
    Kin.Kin_type = 'gut_Kin3';
    Kin.Meal = 1;
    Kin.KCL = 0;
    
    %% solve SS for initial condition 
    do_insulin = 1;
    do_FF = 0; % FF off
    do_MKX = 0; % MK crosstalk off
    MKX_slope = 0.1;
    
    [SSdata_Meal, ~, ~] = getSS(IG_file, pars, Kin, ...
                'do_insulin', [do_insulin, insulin_A, insulin_B],...
                'do_FF', [do_FF, pars.FF], ...
                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B],...
                'do_M_K_crosstalk', [do_MKX, MKX_slope]);

    x0_Meal = SSdata_Meal;
    xp0_Meal = zeros(length(x0_Meal), 1);

    %% solve DAE

    sol_Meal = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                'do_insulin', [do_insulin, insulin_A, insulin_B], ...
                                'do_FF', [do_FF, FF], ...
                                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B],...
                                'do_M_K_crosstalk', [do_MKX, MKX_slope]), ...
                tspan, x0_Meal, xp0_Meal, opts);

    
    %% KCL only
    Kin.Kin_type = 'gut_Kin3';%'gut_Kin3';
    Kin.Meal = 0;
    Kin.KCL = 1;
    
    %% solve SS for initial condition 
    do_insulin = 0; % insulin effect off
    do_FF = 1; 
    do_MKX = 0; % MK crosstalk off
    MKX_slope = 0.1;

    [SSdata_KCL, ~, ~] = getSS(IG_file, pars, Kin, ...
                'do_insulin', [do_insulin, insulin_A, insulin_B],...
                'do_FF', [do_FF, FF], ...
                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B],...
                'do_M_K_crosstalk', [do_MKX, MKX_slope]);
    
    x0_KCL = SSdata_KCL;
    xp0_KCL = zeros(length(x0_KCL), 1);
    
    %% solve DAE

    sol_KCL = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars, ...
                                'Kin_type', {Kin.Kin_type, Kin.Meal, Kin.KCL}, ...
                                'do_insulin', [do_insulin, pars.insulin_A, pars.insulin_B], ...
                                'do_FF', [do_FF, FF], ...
                                'fit_CDKreab', [fit_cdKreab, cdKreab_A, cdKreab_B],...
                                'do_M_K_crosstalk', [do_MKX, MKX_slope]), ...
                tspan, x0_KCL, xp0_KCL, opts);
%     rho_ = SSdata_KCL(12);
%     gamma_ = SSdata_KCL(20);
%     lambda_ = SSdata_KCL(25);
%     if (rho_>0.95 || rho_<1.05) && (gamma_>0.95 || gamma_<1.05) && (lambda_>0.95 || lambda_<1.05)
        
        %% get data
        data = load('./Data/PrestonData.mat');
    
        % adjust for where experiment starts
        exp_start = pars.tchange + 60 + 6*60;
        time_serum = data.time_serum + exp_start;
        time_UK = data.time_UK + exp_start;

        %% error from data points
        try

            temp = deval(sol_both, time_serum);
            serum_vals_both = temp(5, :);
            temp = deval(sol_both, time_UK);
            UK_vals_both = temp(28, :);

            temp = deval(sol_Meal, time_serum);
            serum_vals_Meal = temp(5, :);
            %% temp_time =  [time_UK(1),time_UK(3:6)];   % -- without the
%             temp_time =  [time_UK(1:3),time_UK(5:8)];   % -- without the point and weighted
            % 1st datapoint
            temp = deval(sol_Meal, data.time_UK_nodatapoint); % -- without the 1st datapt
            %% temp = deval(sol_Meal, time_UK); % -- with the datapoint
            UK_vals_Meal = temp(28, :);

            temp = deval(sol_KCL, time_serum);
            serum_vals_KCL = temp(5, :);
            temp = deval(sol_KCL, time_UK);
            UK_vals_KCL = temp(28, :);

            show_plot = 1;
            if show_plot
                figure(201)
                plot(sol_both.x, sol_both.y(5,:), 'color', 'red')
                hold on
                plot(time_serum, data.MealKCL_serum_scaled, '^', 'markersize', 15, 'color', 'blue')
                plot(time_serum, serum_vals_both, '*', 'markersize', 15, 'color', 'red')
                title('ECK values: KCL + Meal')
                hold off
disp('1')
                figure(202)
                plot(sol_both.x, sol_both.y(28, :), 'color', 'red')
                hold on
                plot(time_UK, data.MealKCL_UK_scaled, '^', 'markersize', 15, 'color', 'blue')
                plot(time_UK, UK_vals_both, '*', 'markersize', 15, 'color', 'red')
                title('UK values: KCL + Meal')
                hold off
disp('2')
                figure(203)
                plot(sol_Meal.x, sol_Meal.y(5,:), 'color', 'red')
                hold on
                plot(time_serum, data.Meal_serum_scaled, '^', 'markersize', 15, 'color', 'blue')
                plot(time_serum, serum_vals_Meal, '*', 'markersize', 15, 'color', 'red')
                title('ECK values: Meal')
                hold off

                figure(204)
                plot(sol_Meal.x, sol_Meal.y(28, :), 'color', 'red')
                hold on
                plot(data.time_UK_nodatapoint, data.Meal_UK_scaled_nodatapoint, '^', 'markersize', 15, 'color', 'blue') %- without the 1st datapt
                plot(data.time_UK_nodatapoint, UK_vals_Meal, '*', 'markersize', 15, 'color', 'red')
%%                 plot(time_UK, data.Meal_UK_scaled, '^', 'markersize', 15, 'color', 'blue') % - with the datapoint
%                 plot(time_UK, UK_vals_Meal, '*', 'markersize', 15, 'color', 'red')
                title('UK values: Meal')
                hold off
disp('3')
                figure(205)
                plot(sol_KCL.x, sol_KCL.y(5,:), 'color', 'red')
                hold on
                plot(time_serum, data.KCL_serum_scaled, '^', 'markersize', 15, 'color', 'blue')
                plot(time_serum, serum_vals_KCL, '*', 'markersize', 15, 'color', 'red')
                title('Serum K concentration: KCL')
                hold off
disp('4')
                figure(206)
                plot(sol_KCL.x, sol_KCL.y(28, :), 'color', 'red')
                hold on
                plot(time_UK, data.KCL_UK_scaled, '^', 'markersize', 15, 'color', 'blue')
                plot(time_UK, UK_vals_KCL, '*', 'markersize', 15, 'color', 'red')
                title('UK values: KCL')
                hold off
            end % if show_plot
disp('5')
            %% residuals
            serum_res_both = serum_vals_both - data.MealKCL_serum_scaled';
            UK_res_both = UK_vals_both - data.MealKCL_UK_scaled';

            serum_res_Meal = serum_vals_Meal - data.Meal_serum_scaled';
            UK_res_Meal = UK_vals_Meal - data.Meal_UK_scaled_nodatapoint';
disp('6')
            serum_res_KCL = serum_vals_KCL - data.KCL_serum_scaled';
            UK_res_KCL = UK_vals_KCL - data.KCL_UK_scaled';

            % calculate the rmse and scale by average data value
            rmse_both_serum = (sum(serum_res_both.^2)/length(serum_res_both)).^(1/2);
            nrmse_both_serum = rmse_both_serum/mean(data.MealKCL_serum_scaled); %normalized rmse
            rmse_both_UK = (sum(UK_res_both.^2)/length(UK_res_both)).^(1/2);
            nrmse_both_UK = rmse_both_UK/mean(data.MealKCL_UK_scaled); %normalized rmse
            nrmse_both = nrmse_both_serum + nrmse_both_UK;
 disp('Normalized residuals of Meal + KCL')
 disp(nrmse_both_serum)
 disp(nrmse_both_UK)
            rmse_Meal_serum = (sum(serum_res_Meal.^2)/length(serum_res_Meal)).^(1/2);
            nrmse_Meal_serum = rmse_Meal_serum/mean(data.Meal_serum_scaled); %normalized rmse

            rmse_Meal_UK = (sum(UK_res_Meal.^2)/length(UK_res_Meal)).^(1/2);
            nrmse_Meal_UK = rmse_Meal_UK/mean(data.Meal_UK_scaled); %normalized rmse
            nrmse_Meal = nrmse_Meal_serum + nrmse_Meal_UK;
disp('Normalized residuals of Meal')
disp(nrmse_Meal_serum)
disp(nrmse_Meal_UK)
            rmse_KCL_serum = (sum(serum_res_KCL.^2)/length(serum_res_KCL)).^(1/2);
            nrmse_KCL_serum = rmse_KCL_serum/mean(data.KCL_serum_scaled); %normalized rmse
            rmse_KCL_UK = (sum(UK_res_KCL.^2)/length(UK_res_KCL)).^(1/2);
            nrmse_KCL_UK = rmse_KCL_UK/mean(data.KCL_UK_scaled); %normalized rmse
            nrmse_KCL = nrmse_KCL_serum + nrmse_KCL_UK;
 disp('Normalized residuals of KCL')
 disp(nrmse_KCL_serum)
 disp(nrmse_KCL_UK)
            nrmse = nrmse_both + nrmse_KCL + nrmse_Meal;
            fprintf('Residual in this step = %f \n',nrmse)

        
        catch
            fprintf('WARNING!!: parameter space breaks ODE solver...Setting RMSE to 1 \n')
            nrmse = 4;
        end

%    else
%         fprintf('WARNING!!: Steady state too far off...Setting RMSE to 1 \n')
%         nrmse = 4;
%     end %if



end