function plot_Kload_sim(T,X,params, Kin_opts, labels, tf, MealInfo, days)
close all
t1 = T{1};
t2 = T{2};
t3 = T{3};
t4 = T{4};

disp('days')
disp(days)

% color options
c1= [0.6350 0.0780 0.1840]; % maroon
c2 = [0.4660 0.6740 0.1880]; %green
c3 = [0.3010 0.7450 0.9330]; % blue
c4 = [0.4940 0.1840 0.5560]; % purple

% fontsizes
f.title = 17;
f.xlabel = 17;
f.ylabel = 17;
f.legend = 17;
f.ticks = 16;
mark_size1 = 7;
mark_size2 = 20;
lw = 1.5; % linewidth
% markers
m1 = 'o';
m2 = '^';
m3 = 'd';
m4 = 's';

% which plots?
%plt_bar = 0;
plt_means = 1;


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
    s = subplot(3,1,1);
    sum_vals = zeros(days,4);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        sum_vals(i,1) = sum(PhiKin_vals1(start_id:end_id));
        start_id = find(t2 == (i-1)*1440+1);
        end_id = find(t2 == i*1440);
        sum_vals(i,2) = sum(PhiKin_vals2(start_id:end_id));
        start_id = find(t3 == (i-1)*1440+1);
        end_id = find(t3 == i*1440);
        sum_vals(i,3) = sum(PhiKin_vals3(start_id:end_id));
        start_id = find(t4 == (i-1)*1440+1);
        end_id = find(t4 == i*1440);
        sum_vals(i,4) = sum(PhiKin_vals4(start_id:end_id));
    end
    plot(s, sum_vals, 'linewidth', lw)
    hold on
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('Total \Phi_{Kin} (mEq/day)', 'fontsize', f.ylabel)
    xlim([1,14])
    hold off

    % plasma [K]
    s = subplot(3,1,2);
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
    plot(s, mean_vals(:,3), 'Linewidth', lw, 'color', c3, 'marker', m3);
    plot(s, max_vals(:,3), 'color', c3, 'marker', m3, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, mean_vals(:,4), 'Linewidth', lw, 'color', c4, 'marker', m4);
    plot(s, max_vals(:,4),  'color', c4, 'marker', m4, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    lightGrey2   = [0.7 0.7 0.7];
    yline(5.0, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    yline(3.5, 'Linewidth', 1.5, 'color', lightGrey2, 'linestyle', '-');
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('plasma [K^+] (mEq/L)', 'fontsize', f.ylabel)
    xlim([1,14])
    hold off


    % intracellular [K]
    s = subplot(3,1,3);
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
    plot(s, max_vals(:,1), 'color', c1, 'marker', m1, 'linewidth', lw, 'linestyle', ':', 'markersize', mark_size1);
    plot(s, mean_vals(:,2), 'Linewidth', lw, 'color', c2, 'marker', m2, 'markersize', mark_size1);
    plot(s, max_vals(:,2), 'color', c2, 'marker', m2, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, mean_vals(:,3), 'Linewidth', lw, 'color', c3, 'marker', m3);
    plot(s, max_vals(:,3), 'color', c3, 'marker', m3, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    plot(s, mean_vals(:,4), 'Linewidth', lw, 'color', c4, 'marker', m4);
    plot(s, max_vals(:,4),  'color', c4, 'marker', m4, 'linestyle', ':', 'linewidth', lw, 'markersize', mark_size1);
    xlabel('time (days)', 'fontsize', f.xlabel)
    ylabel('intracellular [K^+] (mEq/L)', 'fontsize', f.ylabel)
    xlim([1,14])
    legend(labels{1}, labels{2}, labels{3}, labels{4}, 'fontsize', f.legend)
    hold off
end % plt_means

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