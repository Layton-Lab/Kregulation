function plot_Kload_sim(T,X,params, Kin_opts, labels, tf, MealInfo, days)
close all
t1 = T{1};
t2 = T{2};
t3 = T{3};
t4 = T{4};

%disp('days')
%disp(days)

% color options
c1= [0.4940 0.1840 0.5560]; % purple [0.3010 0.7450 0.9330]; % blue 
c2 = [0.3010 0.7450 0.9330]; % blue [0.4940 0.1840 0.5560]; % purple [0.4660 0.6740 0.1880]; %green
c3 = [0.6350 0.0780 0.1840]; % maroon
c4 = [0.4660 0.6740 0.1880]; %green %[0.4940 0.1840 0.5560]; % purple
lightGrey2   = [0.7 0.7 0.7];

% fontsizes
f.title = 16;
f.xlabel = 12;
f.ylabel = 12;
f.legend = 14;
f.ticks = 16;
mark_size1 = 7;
mark_size2 = 20;
lw = 1.5; % linewidth
% markers
m1 = 'o';
m2 = '^';
m3 = 'd';
m4 = 's';
% linestyles
ls1 = '-';
ls2 = ':';
ls3 = '--';
ls4 = '--';

% which plots?
%plt_bar = 0;
plt_means = 0;
get_info = 0;
plt_all = 0;
plt_all3 = 1;

if plt_all3
    xmin = 0;
    xmax = 14;
    figure(47)
    
    % Phi_Kin
    s = subplot(3, 2, 1);
    Kinvals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [Kinvals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end %ii
    plot(s, t1/1440, Kinvals1, 'linewidth', lw, 'color', 'k')
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('K^+ intake (\Phi_{Kin})', 'fontsize', f.title)
    xlim([xmin, xmax])
    hold off
    
    % K_plasma
    s = subplot(3,2,3);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals4 = X{4}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t4/1440, vals4, 'linewidth', lw, 'color', c4, 'linestyle', ls4)
    yline(3.5, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(5.0, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/L', 'fontsize', f.ylabel)
    title('Plasma [K^+] (K_{plasma})', 'fontsize', f.title)
    xlim([xmin, xmax])
    hold off
    
    % K_IC
    s = subplot(3,2,5);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals4 = X{4}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t4/1440, vals4, 'linewidth', lw, 'color', c4, 'linestyle', ls4)
    yline(120, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(140, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/L', 'fontsize', f.ylabel)
    title('Intracellular [K^+] (K_{IC})', 'fontsize', f.title)
    xlim([xmin, xmax])
    ylim([120, 155])
    hold off
    
    % Phi_dtsec
    s = subplot(3,2,2);
    varnum = 18;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals4 = X{4}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t4/1440, vals4, 'linewidth', lw, 'color', c4, 'linestyle', ls4)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('DT K^+ secretion (\Phi_{dt-Ksec})', 'fontsize', f.title)
    xlim([xmin, xmax])
    hold off
    
    % Phi_cd transport
    s = subplot(3,2,4);
    varnum1 = 23;
    varnum2 = 26;
    vals1 = X{1}(:,varnum1) - X{1}(:,varnum2);
    vals2 = X{2}(:,varnum1) - X{2}(:,varnum2);
    vals4 = X{4}(:,varnum1) - X{4}(:,varnum2);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t4/1440, vals4, 'linewidth', lw, 'color', c4, 'linestyle', ls4)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('CD K^+ transport (\Phi_{cd-Ksec} - \Phi_{cd-Kreab})', 'fontsize', f.title)
    xlim([xmin, xmax])
    hold off
    
    % Phi_uK
    s = subplot(3,2,6);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals4 = X{4}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t4/1440, vals4, 'linewidth', lw, 'color', c4, 'linestyle', ls4)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('Urinary K^+ excretion (\Phi_{uK})', 'fontsize', f.title)
    xlim([xmin, xmax])
    hold off
    
    legend(labels{1}, labels{2}, labels{4}, 'fontsize', f.legend)
end % plt_all3

if plt_all
    figure(50)
    % Phi_Kin
    s = subplot(4, 1, 1);
    Kinvals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [Kinvals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end %ii
    plot(s, t1, Kinvals1, 'linewidth', lw, 'color', 'k')
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{Kin} (mEq/min)', 'fontsize', f.ylabel)
    hold off
    
    % K_plasma
    s = subplot(4,1,2);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3/1440, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(3.5, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(5.0, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{plasma} (mEq/L)', 'fontsize', f.ylabel)
    hold off
    
    % K_IC
    s = subplot(4,1,3);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3/1440, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(140, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{IC} (mEq/L)', 'fontsize', f.ylabel)
    hold off
    
    % Phi_uK
    s = subplot(4,1,4);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1/1440, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2/1440, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3/1440, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{uK} (mEq/min)', 'fontsize', f.ylabel)
    hold off
    
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', f.legend)
end % plt_all


if plt_means

    figure(11)
    % Phi_Kin
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
    PhiKin_vals4 = zeros(size(T{4}));
    for ii = 1:length(T{4})
        [PhiKin_vals4(ii), ~] = get_PhiKin(T{4}(ii), 0, params{4}, Kin_opts{4}, MealInfo{4});
    end %for ii
    s = subplot(4,1,1);
%     sum_vals = zeros(days,4);
%     for i = 1:days
%         start_id = find(t1 == (i-1)*1440+1);
%         end_id = find(t1 == i*1440);
%         sum_vals(i,1) = sum(PhiKin_vals1(start_id:end_id));
%         start_id = find(t2 == (i-1)*1440+1);
%         end_id = find(t2 == i*1440);
%         sum_vals(i,2) = sum(PhiKin_vals2(start_id:end_id));
%         start_id = find(t3 == (i-1)*1440+1);
%         end_id = find(t3 == i*1440);
%         sum_vals(i,3) = sum(PhiKin_vals3(start_id:end_id));
%         start_id = find(t4 == (i-1)*1440+1);
%         end_id = find(t4 == i*1440);
%         sum_vals(i,4) = sum(PhiKin_vals4(start_id:end_id));
%     end
    %plot(s, sum_vals, 'linewidth', lw)
    %plot(s, t1/(60*24), PhiKin_vals1, 'linewidth', lw, 'color', 'k')
    totalPhiKin = MealInfo{1}.K_amount*3*ones(14,1);
    totalPhiKin(3:6) = 400;
    %disp(totalPhiKin)
    plot(s, totalPhiKin, 'linewidth', lw, 'color', 'k', 'marker', '.', 'markersize', 15)
    %bar(s, totalPhiKin, 'FaceColor', 'k')
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('total \Phi_{Kin} (mEq/day)', 'fontsize', f.ylabel)
    ylim([0,450])
    xlim([1,14])
    hold off
    
    
    % plasma [K]
    s = subplot(4,1,2);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    vals4 = X{4}(:,varnum);
    mean_vals = zeros(days,4);
    max_vals = zeros(days,4);
    min_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        mean_vals(i,1) = mean(vals1(start_id:end_id));
        max_vals(i,1) = max(vals1(start_id:end_id));
        min_vals(i,1) = min(vals1(start_id:end_id));
        start_id = find(t2 == (i-1)*1440+1);
        end_id = find(t2 == i*1440);
        mean_vals(i,2) = mean(vals2(start_id:end_id));
        max_vals(i,2) = max(vals2(start_id:end_id));
        min_vals(i,2) = min(vals2(start_id:end_id));
        start_id = find(t3 == (i-1)*1440+1);
        end_id = find(t3 == i*1440);
        mean_vals(i,3) = mean(vals3(start_id:end_id));
        max_vals(i,3) = max(vals3(start_id:end_id));
        min_vals(i,3) = min(vals3(start_id:end_id));
        start_id = find(t4 == (i-1)*1440+1);
        end_id = find(t4 == i*1440);
        mean_vals(i,4) = mean(vals4(start_id:end_id));
        max_vals(i,4) = max(vals4(start_id:end_id));
        min_vals(i,4) = min(vals4(start_id:end_id));
    end
    plot(s, mean_vals(:,1), 'Linewidth', lw, 'color', c1, 'marker', m1);
    hold on
    plot(s, max_vals(:,1), 'color', c1, 'marker', m1, 'linewidth', lw, 'linestyle', ':', 'markersize', mark_size1);
    %plot(s, min_vals(:,1), 'color', c1, 'marker', m1, 'linestyle', 'none');
    plot(s, mean_vals(:,2), 'Linewidth', lw, 'color', c2, 'marker', m2, 'markersize', mark_size1);
    plot(s, max_vals(:,2), 'color', c2, 'marker', m2, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    %plot(s, mean_vals(:,3), 'Linewidth', lw, 'color', c3, 'marker', m3);
    %plot(s, max_vals(:,3), 'color', c3, 'marker', m3, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, mean_vals(:,4), 'Linewidth', lw, 'color', c4, 'marker', m4);
    plot(s, max_vals(:,4),  'color', c4, 'marker', m4, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    lightGrey2   = [0.7 0.7 0.7];
    yline(5.0, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(3.5, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{plasma} (mEq/L)', 'fontsize', f.ylabel)
    xlim([1,14])
    hold off
    

    % intracellular [K]
    s = subplot(4,1,3);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    vals4 = X{4}(:,varnum);
    mean_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        mean_vals(i,1) = mean(vals1(start_id:end_id));
        max_vals(i,1) = max(vals1(start_id:end_id));
        min_vals(i,1) = min(vals1(start_id:end_id));
        start_id = find(t2 == (i-1)*1440+1);
        end_id = find(t2 == i*1440);
        mean_vals(i,2) = mean(vals2(start_id:end_id));
        max_vals(i,2) = max(vals2(start_id:end_id));
        min_vals(i,2) = min(vals2(start_id:end_id));
        start_id = find(t3 == (i-1)*1440+1);
        end_id = find(t3 == i*1440);
        mean_vals(i,3) = mean(vals3(start_id:end_id));
        max_vals(i,3) = max(vals3(start_id:end_id));
        min_vals(i,3) = min(vals3(start_id:end_id));
        start_id = find(t4 == (i-1)*1440+1);
        end_id = find(t4 == i*1440);
        mean_vals(i,4) = mean(vals4(start_id:end_id));
        max_vals(i,4) = max(vals4(start_id:end_id));
        min_vals(i,4) = min(vals4(start_id:end_id));
    end
    plot(s, mean_vals(:,1), 'Linewidth', lw, 'color', c1, 'marker', m1);
    hold on
    plot(s, mean_vals(:,2), 'Linewidth', lw, 'color', c2, 'marker', m2, 'markersize', mark_size1);
    %plot(s, mean_vals(:,3), 'Linewidth', lw, 'color', c3, 'marker', m3);
    plot(s, mean_vals(:,4), 'Linewidth', lw, 'color', c4, 'marker', m4);
    plot(s, max_vals(:,1), 'color', c1, 'marker', m1, 'linewidth', lw, 'linestyle', ':', 'markersize', mark_size1);
    plot(s, max_vals(:,2), 'color', c2, 'marker', m2, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    %plot(s, max_vals(:,3), 'color', c3, 'marker', m3, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, max_vals(:,4),  'color', c4, 'marker', m4, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    %yline(120, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(140, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{IC}(mEq/L)', 'fontsize', f.ylabel)
    xlim([1,14])
    ylim([125, 155])
    
    hold off
    
    % urinary K
    s = subplot(4,1,4);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    vals4 = X{4}(:,varnum);
    mean_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        mean_vals(i,1) = mean(vals1(start_id:end_id));
        max_vals(i,1) = max(vals1(start_id:end_id));
        min_vals(i,1) = min(vals1(start_id:end_id));
        start_id = find(t2 == (i-1)*1440+1);
        end_id = find(t2 == i*1440);
        mean_vals(i,2) = mean(vals2(start_id:end_id));
        max_vals(i,2) = max(vals2(start_id:end_id));
        min_vals(i,2) = min(vals2(start_id:end_id));
        start_id = find(t3 == (i-1)*1440+1);
        end_id = find(t3 == i*1440);
        mean_vals(i,3) = mean(vals3(start_id:end_id));
        max_vals(i,3) = max(vals3(start_id:end_id));
        min_vals(i,3) = min(vals3(start_id:end_id));
        start_id = find(t4 == (i-1)*1440+1);
        end_id = find(t4 == i*1440);
        mean_vals(i,4) = mean(vals4(start_id:end_id));
        max_vals(i,4) = max(vals4(start_id:end_id));
        min_vals(i,4) = min(vals4(start_id:end_id));
    end
    plot(s, mean_vals(:,1), 'Linewidth', lw, 'color', c1, 'marker', m1);
    hold on
    plot(s, mean_vals(:,2), 'Linewidth', lw, 'color', c2, 'marker', m2, 'markersize', mark_size1);
    %plot(s, mean_vals(:,3), 'Linewidth', lw, 'color', c3, 'marker', m3);
    plot(s, mean_vals(:,4), 'Linewidth', lw, 'color', c4, 'marker', m4);
    plot(s, max_vals(:,1), 'color', c1, 'marker', m1, 'linewidth', lw, 'linestyle', ':', 'markersize', mark_size1);
    plot(s, max_vals(:,2), 'color', c2, 'marker', m2, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    %plot(s, max_vals(:,3), 'color', c3, 'marker', m3, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, max_vals(:,4),  'color', c4, 'marker', m4, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{uK} (mEq/min)', 'fontsize', f.ylabel)
    xlim([1,14])
    ylim([0,1.05])
    hold off
   %legend(labels{1}, labels{2}, labels{3}, labels{4}, 'fontsize', f.legend)
   legend(labels{1}, labels{2}, labels{4}, 'fontsize', f.legend)
    
    
end % plt_means

if get_info
    % total K in the body
    varMKgut = 1;
    varMKplasma = 2;
    varMKinter = 3;
    varMKmuscle = 4;
    
    baseMKgut = X{1}(:,varMKgut);
    baseMKplasma = X{1}(:,varMKplasma);
    baseMKinter = X{1}(:, varMKinter);
    baseMKmuscle = X{1}(:, varMKmuscle);
    
    vals1 = baseMKgut;
    vals2 = baseMKplasma;
    vals3 = baseMKinter;
    vals4 = baseMKmuscle; 
    
    basemean_vals = zeros(days,4);
    basemax_vals = zeros(days,4);
    basemin_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        basemean_vals(i,1) = mean(vals1(start_id:end_id));
        basemax_vals(i,1) = max(vals1(start_id:end_id));
        basemin_vals(i,1) = min(vals1(start_id:end_id));
        basemean_vals(i,2) = mean(vals2(start_id:end_id));
        basemax_vals(i,2) = max(vals2(start_id:end_id));
        basemin_vals(i,2) = min(vals2(start_id:end_id));
        basemean_vals(i,3) = mean(vals3(start_id:end_id));
        basemax_vals(i,3) = max(vals3(start_id:end_id));
        basemin_vals(i,3) = min(vals3(start_id:end_id));
        basemean_vals(i,4) = mean(vals4(start_id:end_id));
        basemax_vals(i,4) = max(vals4(start_id:end_id));
        basemin_vals(i,4) = min(vals4(start_id:end_id));
    end
    
    p = set_params();
    disp('**baseline model results**')
    disp('K_plasma')
    disp(basemean_vals(:,2)/p.V_plasma)
    
    disp('K_intracellular')
    disp(basemean_vals(:,4)/p.V_muscle)
    
    disp('total')
    disp(sum(basemean_vals, 2))
    
    disp('**MKX dt K sec model results**')
    dtKMKgut = X{2}(:,varMKgut);
    dtKMKplasma = X{2}(:,varMKplasma);
    dtKMKinter = X{2}(:, varMKinter);
    dtKMKmuscle = X{2}(:, varMKmuscle);
    
    vals1 = dtKMKgut;
    vals2 = dtKMKplasma;
    vals3 = dtKMKinter;
    vals4 = dtKMKmuscle; 
    
    dtKmean_vals = zeros(days,4);
    dtKmax_vals = zeros(days,4);
    dtKmin_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        dtKmean_vals(i,1) = mean(vals1(start_id:end_id));
        dtKmax_vals(i,1) = max(vals1(start_id:end_id));
        dtKmin_vals(i,1) = min(vals1(start_id:end_id));
        dtKmean_vals(i,2) = mean(vals2(start_id:end_id));
        dtKmax_vals(i,2) = max(vals2(start_id:end_id));
        dtKmin_vals(i,2) = min(vals2(start_id:end_id));
        dtKmean_vals(i,3) = mean(vals3(start_id:end_id));
        dtKmax_vals(i,3) = max(vals3(start_id:end_id));
        dtKmin_vals(i,3) = min(vals3(start_id:end_id));
        dtKmean_vals(i,4) = mean(vals4(start_id:end_id));
        dtKmax_vals(i,4) = max(vals4(start_id:end_id));
        dtKmin_vals(i,4) = min(vals4(start_id:end_id));
    end
    

    disp('K_plasma')
    disp(dtKmean_vals(:,2)/p.V_plasma)
    
    disp('K_intracellular')
    disp(dtKmean_vals(:,4)/p.V_muscle)
    
    disp('total')
    disp(sum(dtKmean_vals, 2))
    
    
end % get_info

% if plt_bar
%     figure(10)
%     % Phi_Kin
%     PhiKin_vals1 = zeros(size(T{1}));
%     for ii = 1:length(T{1})
%         [PhiKin_vals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
%     end % for ii
%     PhiKin_vals2 = zeros(size(T{2}));
%     for ii = 1:length(T{2})
%         [PhiKin_vals2(ii), ~] = get_PhiKin(T{2}(ii), 0, params{2}, Kin_opts{2}, MealInfo{2});
%     end %for ii
%     PhiKin_vals3 = zeros(size(T{3}));
%     for ii = 1:length(T{3})
%         [PhiKin_vals3(ii), ~] = get_PhiKin(T{3}(ii), 0, params{3}, Kin_opts{3}, MealInfo{3});
%     end %for ii
%     PhiKin_vals4 = zeros(size(T{4}));
%     for ii = 1:length(T{4})
%         [PhiKin_vals4(ii), ~] = get_PhiKin(T{4}(ii), 0, params{4}, Kin_opts{4}, MealInfo{4});
%     end %for ii
%     s = subplot(3,1,1);
%     bar_vals = zeros(days,4);
%     for i = 1:days
%         start_id = find(t1 == (i-1)*1440+1);
%         end_id = find(t1 == i*1440);
%         bar_vals(i,1) = sum(PhiKin_vals1(start_id:end_id));
%         start_id = find(t2 == (i-1)*1440+1);
%         end_id = find(t2 == i*1440);
%         bar_vals(i,2) = sum(PhiKin_vals2(start_id:end_id));
%         start_id = find(t3 == (i-1)*1440+1);
%         end_id = find(t3 == i*1440);
%         bar_vals(i,3) = sum(PhiKin_vals3(start_id:end_id));
%         start_id = find(t4 == (i-1)*1440+1);
%         end_id = find(t4 == i*1440);
%         bar_vals(i,4) = sum(PhiKin_vals4(start_id:end_id));
%     end
%     bar(s, bar_vals)
%     hold on
%     xlabel('time (days)', 'fontsize', f.xlabel)
%     ylabel('Total \Phi_{Kin} (mEq/day)', 'fontsize', f.ylabel)
%     hold off
% 
%     % plasma [K]
%     s = subplot(3,1,2);
%     varnum = 5;
%     vals1 = X{1}(:,varnum);
%     vals2 = X{2}(:,varnum);
%     vals3 = X{3}(:,varnum);
%     vals4 = X{4}(:,varnum);
%     bar_vals = zeros(days,4);
%     for i = 1:days
%         start_id = find(t1 == (i-1)*1440+1);
%         end_id = find(t1 == i*1440);
%         bar_vals(i,1) = mean(vals1(start_id:end_id));
%         start_id = find(t2 == (i-1)*1440+1);
%         end_id = find(t2 == i*1440);
%         bar_vals(i,2) = mean(vals2(start_id:end_id));
%         start_id = find(t3 == (i-1)*1440+1);
%         end_id = find(t3 == i*1440);
%         bar_vals(i,3) = mean(vals3(start_id:end_id));
%         start_id = find(t4 == (i-1)*1440+1);
%         end_id = find(t4 == i*1440);
%         bar_vals(i,4) = mean(vals4(start_id:end_id));
%     end
%     bar(bar_vals);
%     hold on
%     xlabel('time (days)', 'fontsize', f.xlabel)
%     ylabel('plasma [K^+] (mEq/L)', 'fontsize', f.ylabel)
%     ylim([3.0, 5.0])
%     hold off
% 
% 
%     % intracellular [K]
%     s = subplot(3,1,3);
%     varnum = 8;
%     vals1 = X{1}(:,varnum);
%     vals2 = X{2}(:,varnum);
%     vals3 = X{3}(:,varnum);
%     vals4 = X{4}(:,varnum);
%     bar_vals = zeros(days,4);
%     for i = 1:days
%         start_id = find(t1 == (i-1)*1440+1);
%         end_id = find(t1 == i*1440);
%         bar_vals(i,1) = mean(vals1(start_id:end_id));
%         start_id = find(t2 == (i-1)*1440+1);
%         end_id = find(t2 == i*1440);
%         bar_vals(i,2) = mean(vals2(start_id:end_id));
%         start_id = find(t3 == (i-1)*1440+1);
%         end_id = find(t3 == i*1440);
%         bar_vals(i,3) = mean(vals3(start_id:end_id));
%         start_id = find(t4 == (i-1)*1440+1);
%         end_id = find(t4 == i*1440);
%         bar_vals(i,4) = mean(vals4(start_id:end_id));
%     end
%     bar(bar_vals);
%     hold on
%     xlabel('time (days)', 'fontsize', f.xlabel)
%     ylabel('intracellular [K^+] (mEq/L)', 'fontsize', f.ylabel)
%     legend(labels{1}, labels{2}, labels{3}, labels{4}, 'fontsize', f.legend)
%     hold off
% end % plt_bar

end %function