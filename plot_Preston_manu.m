function plot_Preston_exp(T, X, params, Kin_opts, MealInfo)
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
plt_PhiKin = 1;

% fontsizes
fonts.title = 20;
fonts.xlabel = 18;
fonts.ylabel = 18;
fonts.legend = 14;
fonts.ticks = 12;

markersize = 15;

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
    plot(times1/60, PhiKin_vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2/60, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    plot(times3/60, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', ':')
    ax = gca;
    ax.FontSize = fonts.ticks;
    xlabel('time (hours)', 'fontsize', fonts.xlabel)
    ylabel('\Phi_{Kin} (mEq/min)', 'fontsize', fonts.ylabel)
    title('K^+ intake (\Phi_{Kin})', 'fontsize', fonts.title)
    legend(labels, 'fontsize', fonts.legend, 'Location', 'northeast')
    xlim([-exp_start/60, 900/60])
    a = get(gca, 'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',fonts.ticks)
    hold off
end

end