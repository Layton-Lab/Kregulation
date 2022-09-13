function plot_simulation(T,X,params, Kin_opts, labels, tf, MealInfo)
close all
exp_start = params{1}.tchange + 60 + 6*60;
tf = tf - exp_start;
times1 = (T{1}-exp_start)/1;
times2 = (T{2}-exp_start)/1;

varnames = set_params().varnames;

% color options
c1= [0.9290, 0.6940, 0.1250];%yellow
c2 = [0.3010, 0.7450, 0.9330]; %blue
c3 = [0.4940, 0.1840, 0.5560];%purple

% which plots?
plt_PhiKin = 0;
plt_con = 1;
plt_amt = 1;
plt_Mgut = 1;
plt_flux = 0;
plt_effects = 0;
plt_kidney = 0;
plt_ALD = 0;
plt_MEAL_exp = 0;
plt_KCL_exp = 1;
plt_MealKCL_exp = 0;

% fontsizes
fonts.title = 15;
fonts.xlabel = 15;
fonts.ylabel = 15;
fonts.legend = 15;

marker_size = 15;

%% plot Phi_Kin
if plt_PhiKin
    PhiKin_vals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [PhiKin_vals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end % for ii
    PhiKin_vals2 = zeros(size(T{2}));
    for ii = 1:length(T{2})
        [PhiKin_vals2(ii), ~] = get_PhiKin(T{2}(ii), 0, params{2}, Kin_opts{2}, MealInfo{2});
    end %for ii
    figure(99)
    plot(times1, PhiKin_vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('$\Phi_{Kin}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
    xlim([-exp_start, tf])
    hold off
end

%% Mgut
if plt_Mgut
    figure(37)
    plot(times1, X{1}(:,1), 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, X{2}(:,1), 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('M_{Kgut}', 'fontsize', fonts.ylabel)
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
    hold off
end %if
    

%% amounts
if plt_amt
    figure(1)
    plot_these = {1,2,...
                    3, 4 ,...
                    'totalECF','totalbodyK'};
    for ii = 1:6
        s = subplot(3,2, ii);
        if strcmp(plot_these{ii}, 'totalECF')
            vals1 = X{1}(:, 2) + X{1}(:, 3);
            vals2 = X{2}(:, 2) + X{2}(:,3);
        elseif strcmp(plot_these{ii}, 'totalbodyK') % not including gut %Sophia: Gut is included if the 1st column of X is added
            vals1 = X{1}(:, 2) + X{1}(:,3) + X{1}(:,4) + X{1}(:, 5) + X{1}(:, 6);% + X{1}(:,1);
            vals2 =  X{2}(:,2) + X{2}(:,3) + X{2}(:,4) + X{2}(:, 5) + X{2}(:,6);
        else
            vals1 = X{1}(:, plot_these{ii});
            vals2 = X{2}(:, plot_these{ii});
        end
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        if ismember(ii, [1,2,3,4])
            ylabel('mEq', 'fontsize', fonts.ylabel)
        else
            ylabel('mEq', 'fontsize', fonts.ylabel)
            %ylabel('mEq/L', 'fontsize', fonts.ylabel)
        end
        if strcmp(plot_these{ii}, 'totalECF')
            title('Total ECF K', 'fontsize', fonts.title)
        elseif strcmp(plot_these{ii}, 'totalbodyK')
            title('Total body K', 'fontsize', fonts.title)
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        xlim([-exp_start, tf])
        hold off
    end
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
end

%% concentrations
if plt_con
    plot_these = {5,6,7,8};
    figure(10)
    for ii = 1:4
        s = subplot(2,2, ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        %ylabel('mEq/min', 'fontsize', fonts.ylabel)
        ylabel('mEq/L', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start,tf])
%         if plot_these{ii} == 10
%             ylim([145, 155])
%         if plot_these{ii} == 11
%             ylim([135, 145])
%         elseif plot_these{ii} == 12
%             ylim([115, 125])
%         elseif ismember(plot_these{ii}, [7,8, 9])
%             ylim([4, 5.0])
    end
    hold off
end
legend(labels{1}, labels{2}, 'fontsize', fonts.legend)

%% fluxes
if plt_flux
    figure(2)
    plot_these = {9, 13, 14, 15};
    for ii = 1:4
        s = subplot(2,2,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, tf])
        hold off
    end
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
end

%% effects
if plt_effects
    figure(3)
    plot_these = {10, 11, 12, 20, 21, 25, 33};
    for ii = 1:7
        s = subplot(3,3,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, tf])
        hold off
    end
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
end


%% kidney
if plt_kidney
    figure(4)
    plot_these = {16, 17, 18, 19, 23, 24, 28, 'CDKtrans', 29};
    for ii = 1:9
        s = subplot(3,3, ii);
        if strcmp(plot_these{ii}, 'CDKtrans')
            vals1 = X{1}(:, 27) - X{1}(:, 24); % reab - sec, positive means net reab
            vals2 = X{2}(:, 27) - X{2}(:, 24);
        else
            vals1 = X{1}(:,plot_these{ii});
            vals2 = X{2}(:,plot_these{ii});
        end
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'fontsize', fonts.ylabel)
        if strcmp(plot_these{ii}, 'CDKtrans')
            title('Net CD K transport', 'fontsize', fonts.title)
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        xlim([-exp_start, tf])
        hold off
    end
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
end

%% ALD
if plt_ALD
    figure(5)
    plot_these = {29, 32, 20, 12};
    for ii = 1:4
        s = subplot(2,2,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, tf])
        hold off
    end
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
end

%% compare to data from the MEAL experiment
if plt_MEAL_exp
    data = load('./Data/PrestonData.mat');
    % plot serum [K+]
    figure(20)
    vals1 = X{1}(:,5);
    vals2 = X{2}(:,5);
    data_times = data.time_serum;
    data_vals = data.Meal_serum_scaled;
    plot(times1,vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/L')
    title('Plasma concentration for Meal experiment')
    legend(labels{1}, labels{2}, 'Preston data (Meal only)')
    hold off
    
    % plot uK
    figure(21)
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    data_times = data.time_UK;
    data_vals = data.Meal_UK_scaled;
    plot(times1, vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/min')
    title('Urine K excretion for Meal experiment')
    legend(labels{1}, labels{2}, 'Preston data (Meal only)')
    hold off
end

%% compare simulation to the KCL only experiment
if plt_KCL_exp
    data = load('./Data/PrestonData.mat');
    % plot serum K
    figure(20)
    vals1 = X{1}(:,5);
    vals2 = X{2}(:,5);
    data_times = data.time_serum;
    data_vals = data.KCL_serum_scaled;
    plot(times1,vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/L')
    %xlim([-10, 400])
    title('Plasma concentration for KCL experiment')
    legend(labels{1}, labels{2}, 'Preston data (KCL only)')
    hold off
    
    % plot uK
    figure(21)
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    data_times = data.time_UK;
    data_vals = data.KCL_UK_scaled;
    plot(times1, vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/min')
    %xlim([-10, 400])
    title('Urine K excretion for KCL experiment')
    legend(labels{1}, labels{2}, 'Preston data (KCL only)')
    hold off  
end

%% Plot Meal + KCL experiment
if plt_MealKCL_exp
    data = load('./Data/PrestonData.mat');
    % plot serum K
    figure(20)
    vals1 = X{1}(:,5);
    vals2 = X{2}(:,5);
    data_times = data.time_serum;
    data_vals = data.MealKCL_serum_scaled;
    plot(times1,vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/L')
    title('Plasma concentration for Meal+ KCL experiment')
    legend(labels{1}, labels{2}, 'Preston data (Meal + KCL)')
    hold off
    
    % plot uK
    figure(21)
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    data_times = data.time_UK;
    data_vals = data.MealKCL_UK_scaled;
    plot(times1, vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(data_times, data_vals, '.', 'markersize', marker_size, 'color', 'k')
    xlabel('time (mins)')
    ylabel('mEq/min')
    title('Urine K excretion for Meal + KCL experiment')
    legend(labels{1}, labels{2}, 'Preston data (Meal + KCL)')
    hold off
end
end %plot_simulation