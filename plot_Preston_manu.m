function plot_Preston_manu(T, X, params, Kin_opts, MealInfo)
%% if want to remove the outlying datapoin in Meal UP experiment, use Meal_UK_scaled_nodatapoint data. Otherwise - use Meal_UK_scaled

close all
exp_start = params{1}.tchange + 60 + 6*60;
times1 = (T{1} - exp_start)/1;
times2 = (T{2} - exp_start)/1;
times3 = (T{3} - exp_start)/1;


varnames = set_params().varnames;

% color options
c1= [0.9290, 0.6940, 0.1250]; %yellow
c2 = [0.4940, 0.1840, 0.5560];%purple 
c3 = [0.3010, 0.7450, 0.9330]; %blue

% which plots?
plt_PhiKin = 0;
plt_M_con = 1;% amounts and concentrations
plt_effects = 1; % effects of ALD and insulin
plt_kidney = 1; % kidney K+ handling

% fontsizes
fonts.title = 14;
fonts.xlabel = 13;
fonts.ylabel = 13;
fonts.legend = 14;
fonts.ticks = 10;
fonts.lab = 12;
markersize = 15;

% linestyles
ls1 = '-';
ls2 = ':';
ls3 = '-.';
lw = 2; % linewidth

% x axis limits
xmin = -(exp_start - params{1}.tchange)/60;
xmax = 9; %600/60;

labx = 0.25;
laby = 0.95; % percentage of range

%labels = {'K^+ deficient Meal only', '35 mmol K^+ ingested orally only', 'K^+ deficient Meal + 35 mmol K^+'};
labels = {'Meal only', 'KCl only', 'Meal + KCl'};

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
    PhiKin_vals3 = zeros(size(T{3}));
    for ii = 1:length(T{3})
        [PhiKin_vals3(ii), ~] = get_PhiKin(T{3}(ii), 0, params{3}, Kin_opts{3}, MealInfo{3});
    end %for ii
    figure(99)
    plot(times1/60, PhiKin_vals1, 'linewidth', 2, 'color', c1, 'linestyle', ls1)
    hold on
    plot(times2/60, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', ls2)
    plot(times3/60, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hours)', 'fontsize', fonts.xlabel)
    ylabel('\Phi_{Kin} (mEq/min)', 'fontsize', fonts.ylabel)
    title('K^+ intake (\Phi_{Kin})', 'fontsize', fonts.title)
    legend(labels, 'fontsize', fonts.legend, 'Location', 'northeast')
    xlim([xmin, xmax])
    a = get(gca, 'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',fonts.ticks)
    hold off
end

data = load('./Data/PrestonData.mat');

if plt_M_con
    figure(100)
    % Phi Kin
    s = subplot(3,3,1);
    PhiKin_vals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [PhiKin_vals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end % for ii
    PhiKin_vals2 = zeros(size(T{2}));
    for ii = 1:length(T{2})
        [PhiKin_vals2(ii), ~] = get_PhiKin(T{2}(ii), 0, params{2}, Kin_opts{2}, MealInfo{2});
    end %for ii
    PhiKin_vals3 = zeros(size(T{3}));
    for ii = 1:length(T{3})
        [PhiKin_vals3(ii), ~] = get_PhiKin(T{3}(ii), 0, params{3}, Kin_opts{3}, MealInfo{3});
    end %for ii
    plot(s, times1/60, PhiKin_vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, PhiKin_vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, PhiKin_vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlim([xmin, xmax])
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('K^+ intake (\Phi_{Kin})', 'fontsize', fonts.title)
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(a)', 'fontsize', fonts.lab)
    hold off
    
    % MKgut
    s = subplot(3,3,2);
    varnum = 1;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Gut K^+ Amount (M_{Kgut})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([-1,30])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(b)', 'fontsize', fonts.lab)
    hold off
    
    % MKplasma
    s = subplot(3,3,4);
    varnum = 2;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Plasma K^+ Amount (M_{Kplasma})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([10, 25])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(c)', 'fontsize', fonts.lab)
    hold off
    
    % MKinter
    s = subplot(3,3,5);
    varnum = 3;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Interstitial K^+ Amount (M_{Kinter})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([30,50])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(d)', 'fontsize', fonts.lab)
    hold off
    
    % MKIC
    s = subplot(3,3,6);
    varnum = 4;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Intracellular K^+ Amount (M_{KIC})', 'fontsize', fonts.title)
    ylim([3000, 3150])
    xlim([xmin, xmax])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(e)', 'fontsize', fonts.lab)
    hold off
    
    % Kplasma
    s = subplot(3,3,7);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    errorbar(data.time_serum/60, data.Meal_serum_scaled, data.Meal_serum_err,'.', 'markersize', markersize,'color',c1)
    plot(data.time_serum/60, data.Meal_serum_scaled, '.', 'markersize', markersize, 'color', c1)
    errorbar(data.time_serum/60, data.KCL_serum_scaled, data.KCL_serum_err,'.', 'markersize', markersize,'color',c2)
    plot(data.time_serum/60, data.KCL_serum_scaled, '.', 'markersize', markersize, 'color', c2)
    errorbar(data.time_serum/60, data.MealKCL_serum_scaled, data.MealKCL_serum_err,'.', 'markersize', markersize,'color',c3)
    plot(data.time_serum/60, data.MealKCL_serum_scaled, '.', 'markersize', markersize, 'color', c3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Plasma [K^+] (K_{plasma})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([3.0,5.0])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(f)', 'fontsize', fonts.lab)
    hold off
    
    % Kinterstitial
    s = subplot(3,3,8);
    varnum = 6;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Interstitial [K^+] (K_{inter})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([3.0,5.0])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(g)', 'fontsize', fonts.lab)
    hold off
    
    % KIC
    s = subplot(3,3,9);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq', 'fontsize', fonts.ylabel)
    title('Intracellular [K^+] (K_{IC})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([120,140])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(h)', 'fontsize', fonts.lab)
    hold off
    
    legend(labels, 'fontsize', fonts.legend, 'Location', 'northeast')
end

if plt_effects
    figure(101)
    % rho_insullin
    s = subplot(2,2,1);
    varnum = 11;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('\rho_{insulin}', 'fontsize', fonts.ylabel)
    title('[insulin] effect on \Phi_{ECtoIC} (\rho_{insulin})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0.92, 1.15])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(a)', 'fontsize', fonts.lab)
    hold off
    
    % rho_al
    s = subplot(2,2,2);
    varnum = 12;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('\rho_{al}', 'fontsize', fonts.ylabel)
    title('[ALD] effect on \Phi_{ECtoIC} (\rho_{al})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0.92, 1.15])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(b)', 'fontsize', fonts.lab)
    hold off
    
    % gamma_Kin
    s = subplot(2,2,3);
    varnum = 21;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('\gamma_{Kin}', 'fontsize', fonts.ylabel)
    title('GI Feedforward Effect (\gamma_{Kin})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0.92, 7])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(c)', 'fontsize', fonts.lab)
    hold off
    
    % gamma_al
    s = subplot(2,2,4);
    varnum = 20;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('\gamma_{al}', 'fontsize', fonts.ylabel)
    title('[ALD] effect on \Phi_{dt-Ksec} (\gamma_{al})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0.92, 1.15])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(d)', 'fontsize', fonts.lab)
    hold off
    
    legend(labels, 'fontsize', 12, 'Location', 'best')
end

if plt_kidney
    figure(102)
    % phi_filK
    s = subplot(2,2,1);
    varnum = 15;
    vals1 = X{1}(:, varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq/min', 'fontsize', fonts.ylabel)
    title('Filtered K^+ load (\Phi_{filK})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0.4, 0.6])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(a)', 'fontsize', fonts.lab)
    hold off

    % phi_dtKsec
    s = subplot(2,2,2);
    varnum = 18;
    vals1 = X{1}(:, varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq/min', 'fontsize', fonts.ylabel)
    title('DT K^+ secretion (\Phi_{dt-Ksec})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(b)', 'fontsize', fonts.lab)
    hold off
    
    % CD K transport
    s = subplot(2,2,3);
    vals1 = X{1}(:, 23) - X{1}(:, 26);
    vals2 = X{2}(:, 23) - X{2}(:, 26);
    vals3 = X{3}(:, 23) - X{3}(:, 26);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq/min', 'fontsize', fonts.ylabel)
    title('CD K^+ transport (\Phi_{cd-Ksec} - \Phi_{cd-Kreab})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([-0.19, -0.02])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(c)', 'fontsize', fonts.lab)
    hold off
    
    % phi_uK
    s = subplot(2,2,4);
    varnum = 28;
    vals1 = X{1}(:, varnum);
    vals2 = X{2}(:, varnum);
    vals3 = X{3}(:, varnum);
    plot(s, times1/60, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, times2/60, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, times3/60, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    errorbar(data.time_UK/60, data.Meal_UK_scaled, data.Meal_UK_err,'.', 'markersize', markersize,'color',c1)
    plot(data.time_UK/60, data.Meal_UK_scaled, '.', 'markersize', markersize, 'color', c1)  % - with the datapoint
    errorbar(data.time_UK/60, data.KCL_UK_scaled, data.KCL_UK_err,'.', 'markersize', markersize,'color',c2)
    plot(data.time_UK/60, data.KCL_UK_scaled, '.', 'markersize', markersize, 'color', c2)
    errorbar(data.time_UK/60, data.MealKCL_UK_scaled, data.MealKCL_UK_err,'.', 'markersize', markersize,'color',c3)
    plot(data.time_UK/60, data.MealKCL_UK_scaled, '.', 'markersize', markersize, 'color', c3)
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hrs)', 'fontsize', fonts.xlabel)
    ylabel('mEq/min', 'fontsize', fonts.ylabel)
    title('Urinary K^+ excretion (\Phi_{uK})', 'fontsize', fonts.title)
    xlim([xmin, xmax])
    ylim([0,0.2])
    text(xmin + labx, gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(d)', 'fontsize', fonts.lab)
    hold off
    
    legend(labels, 'fontsize', 12, 'Location', 'best')
end










end