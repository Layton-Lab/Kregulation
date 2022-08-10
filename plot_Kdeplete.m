function plot_Kdeplete(T,X,params, Kin_opts, labels, tf, MealInfo, days)
close all

t1 = T{1}/1440; % mins to days
t2 = T{2}/1440;
t3 = T{3}/1440;

% color options
c1= [0.4940 0.1840 0.5560]; % purple [0.3010 0.7450 0.9330]; % blue 
c2 = [0.3010 0.7450 0.9330]; % blue 
c3 =  [0.4660 0.6740 0.1880]; %green
c4 = [0.6350 0.0780 0.1840]; % maroon
lightGrey2   = [0.7 0.7 0.7];

% fontsizes
f.title = 16;
f.xlabel = 12;
f.ylabel = 12;
f.legend = 14;
f.ticks = 16;
f.lab = 12;
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

labx = 0.25;
laby = 0.95;

% which plots?
plt_means = 0;
plt_all = 0;
plt_all2 = 0;
plt_all3 = 1;
get_info = 0;

if plt_means
  disp('TO DO')  
end %plt_means

if plt_all3
    xmin = 0;
    xmax = days;
    figure(47)
    
    % Phi_Kin
    s = subplot(3, 2, 1);
    Kinvals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [Kinvals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end %ii
    plot(s, t1, Kinvals1, 'linewidth', lw, 'color', 'k')
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    title('K^+ intake (\Phi_{Kin})', 'fontsize', f.title)
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(a)', 'fontsize', f.lab)
    hold off
    
    % K_plasma
    s = subplot(3,2,3);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(3.5, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/L', 'fontsize', f.ylabel)
    title('Plasma [K^+] (K_{plasma})', 'fontsize', f.title)
    xlim([xmin, xmax])
    ylim([2.4,4.7])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(c)', 'fontsize', f.lab)
    hold off
    
    % K_IC
    s = subplot(3,2,5);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(120, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(140, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/L', 'fontsize', f.ylabel)
    title('Intracellular [K^+] (K_{IC})', 'fontsize', f.title)
    ylim([85,140])
    xlim([xmin, xmax])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(e)', 'fontsize', f.lab)
    hold off
    
    % Phi_dtsec
    s = subplot(3,2,2);
    varnum = 18;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('DT K^+ secretion (\Phi_{dt-Ksec})', 'fontsize', f.title)
    xlim([xmin, xmax])
    ylim([-0.05, 0.325])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(b)', 'fontsize', f.lab)
    hold off
    
    % Phi_cd transport
    s = subplot(3,2,4);
    varnum1 = 23;
    varnum2 = 26;
    vals1 = X{1}(:,varnum1) - X{1}(:,varnum2);
    vals2 = X{2}(:,varnum1) - X{2}(:,varnum2);
    vals3 = X{3}(:,varnum1) - X{3}(:,varnum2);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('CD K^+ transport (\Phi_{cd-Ksec} - \Phi_{cd-Kreab})', 'fontsize', f.title)
    xlim([xmin, xmax])
    ylim([-0.27,0])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(d)', 'fontsize', f.lab)
    hold off
    
    % Phi_uK
    s = subplot(3,2,6);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('mEq/min', 'fontsize', f.ylabel)
    title('Urinary K^+ excretion (\Phi_{uK})', 'fontsize', f.title)
    xlim([xmin, xmax])
    ylim([0,0.18])
    text(xmin + labx,gca().YLim(1) + laby*(gca().YLim(2) - gca().YLim(1)), '(f)', 'fontsize', f.lab)
    hold off
    
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', f.legend)
end % plt_all3

if plt_all2
    xmin = 30;
    xmax = 70;
    figure(41)
    
    % Phi_Kin
    s = subplot(2, 3, 1);
    Kinvals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [Kinvals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
    end %ii
    plot(s, t1, Kinvals1, 'linewidth', lw, 'color', 'k')
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{Kin} (mEq/min)', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    hold off
    
    % K_plasma
    s = subplot(2,3,2);
    varnum = 5;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(3.5, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{plasma} (mEq/L)', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    hold off
    
    % K_IC
    s = subplot(2,3,3);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(120, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(140, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{IC} (mEq/L)', 'fontsize', f.ylabel)
    ylim([95,140])
    xlim([xmin, xmax])
    hold off
    
    % Phi_dtsec
    s = subplot(2,3,4);
    varnum = 18;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{dtKsec} (mEq/min)', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    hold off
    
    % Phi_cd transport
    s = subplot(2,3,5);
    varnum1 = 26;
    varnum2 = 23;
    vals1 = X{1}(:,varnum1) - X{1}(:,varnum2);
    vals2 = X{2}(:,varnum1) - X{2}(:,varnum2);
    vals3 = X{3}(:,varnum1) - X{3}(:,varnum2);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{cdKreab} - \Phi_{cdKsec} (mEq/min)', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    hold off
    
    % Phi_uK
    s = subplot(2,3,6);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{uK} (mEq/min)', 'fontsize', f.ylabel)
    xlim([xmin, xmax])
    hold off
    
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', f.legend)
end % plt_all2

if plt_all
    figure(40)
    
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
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(3.5, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{plasma} (mEq/L)', 'fontsize', f.ylabel)
    hold off
    
    % K_IC
    s = subplot(4,1,3);
    varnum = 8;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    yline(120, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(140, 'linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('K_{IC} (mEq/L)', 'fontsize', f.ylabel)
    ylim([95,140])
    hold off
    
    % Phi_uK
    s = subplot(4,1,4);
    varnum = 28;
    vals1 = X{1}(:,varnum);
    vals2 = X{2}(:,varnum);
    vals3 = X{3}(:,varnum);
    plot(s, t1, vals1, 'linewidth', lw, 'color', c1, 'linestyle', ls1)
    hold on
    plot(s, t2, vals2, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
    plot(s, t3, vals3, 'linewidth', lw, 'color', c3, 'linestyle', ls3)
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('\Phi_{uK} (mEq/min)', 'fontsize', f.ylabel)
    hold off
    
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', f.legend)
end % plt_all

if get_info
    T1 = T{1}; 
    T2 = T{2};
    T3 = T{3};
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
        start_id = find(T1 == (i-1)*1440+1);
        end_id = find(T1 == i*1440);
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
    Kplas = basemean_vals(:,2)/p.V_plasma;
    disp(Kplas)
    
    disp('K_intracellular')
    Kic = basemean_vals(:,4)/p.V_muscle;
    disp(Kic)
    
    disp('total')
    totalK = sum(basemean_vals,2);
    disp(totalK)
    
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
        start_id = find(T2 == (i-1)*1440+1);
        end_id = find(T2 == i*1440);
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
    Kplasdt = dtKmean_vals(:,2)/p.V_plasma;
    disp(Kplasdt)
    
    disp('K_intracellular')
    Kicdt = dtKmean_vals(:,4)/p.V_muscle;
    disp(Kicdt)
    
    disp('total')
    totalDT = sum(dtKmean_vals, 2);
    disp(totalDT)
    
    disp('**MKX cd K rean model results**')
    cdKMKgut = X{3}(:,varMKgut);
    cdKMKplasma = X{3}(:,varMKplasma);
    cdKMKinter = X{3}(:, varMKinter);
    cdKMKmuscle = X{3}(:, varMKmuscle);
    
    vals1 = cdKMKgut;
    vals2 = cdKMKplasma;
    vals3 = cdKMKinter;
    vals4 = cdKMKmuscle; 
    
    cdKmean_vals = zeros(days,4);
    cdKmax_vals = zeros(days,4);
    cdKmin_vals = zeros(days,4);
    for i = 1:days
        start_id = find(T3 == (i-1)*1440+1);
        end_id = find(T3 == i*1440);
        cdKmean_vals(i,1) = mean(vals1(start_id:end_id));
        cdKmax_vals(i,1) = max(vals1(start_id:end_id));
        cdKmin_vals(i,1) = min(vals1(start_id:end_id));
        cdKmean_vals(i,2) = mean(vals2(start_id:end_id));
        cdKmax_vals(i,2) = max(vals2(start_id:end_id));
        cdKmin_vals(i,2) = min(vals2(start_id:end_id));
        cdKmean_vals(i,3) = mean(vals3(start_id:end_id));
        cdKmax_vals(i,3) = max(vals3(start_id:end_id));
        cdKmin_vals(i,3) = min(vals3(start_id:end_id));
        cdKmean_vals(i,4) = mean(vals4(start_id:end_id));
        cdKmax_vals(i,4) = max(vals4(start_id:end_id));
        cdKmin_vals(i,4) = min(vals4(start_id:end_id));
    end
    

    disp('K_plasma')
    Kplascd = cdKmean_vals(:,2)/p.V_plasma;
    disp(Kplascd)
    
    disp('K_intracellular')
    Kiccd = cdKmean_vals(:,4)/p.V_muscle;
    disp(Kiccd)
    
    disp('total')
    totalCD = sum(cdKmean_vals, 2);
    disp(totalCD)
    
    
end % get_info


end %plot_Kdeplete