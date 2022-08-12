function [base_vals, dtK_vals, cdKreab_vals] = get_info(T, X, loadORdeplete)
    t1 = T{1};
    if strcmp(loadORdeplete, 'load')
        days = 14;
        ind_cdK = 4;
    elseif strcmp(loadORdeplete, 'deplete')
        days = 50;
        ind_cdK = 3;
    else
        fprintf('What is this? %s \n', loadORdeplete)
    end
    % total K in the body
    varMKgut = 1;
    varMKplasma = 2;
    varMKinter = 3;
    varMKmuscle = 4;
    vardtKsec   = 18;
    varcdKreab  = 26;
    varcdKsec   = 23;
    varuK = 28;
    
    baseMKgut = X{1}(:,varMKgut);
    baseMKplasma = X{1}(:,varMKplasma);
    baseMKinter = X{1}(:, varMKinter);
    baseMKmuscle = X{1}(:, varMKmuscle);
    basedtKsec = X{1}(:, vardtKsec);
    basecdKreab = X{1}(:, varcdKreab);
    basecdKsec = X{1}(:, varcdKsec);
    basecdKtrans = basecdKsec - basecdKreab;
    baseuK      = X{1}(:, varuK);
    
    vals = {};
    vals{1} = baseMKgut;
    vals{2} = baseMKplasma;
    vals{3} = baseMKinter;
    vals{4} = baseMKmuscle; 
    vals{5} = basedtKsec;
    vals{6} = basecdKtrans;
    vals{7} = baseuK;
    vals{8} = basecdKsec;
    vals{9} = basecdKreab;
    
    basemean_vals = zeros(days,9);
    basemax_vals = zeros(days,9);
    basemin_vals = zeros(days,9);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        for jj = 1:9
            [min_vals, mean_vals, max_vals] = get_day_vals(vals{jj}, start_id, end_id);
            basemin_vals(i, jj) = min_vals;
            basemean_vals(i, jj) = mean_vals;
            basemax_vals(i,jj) = max_vals;
        end
    end

    base_vals = {basemin_vals, basemean_vals, basemax_vals};
    
    %disp('**MKX dt K sec model results**')
    dtKMKgut = X{2}(:,varMKgut);
    dtKMKplasma = X{2}(:,varMKplasma);
    dtKMKinter = X{2}(:, varMKinter);
    dtKMKmuscle = X{2}(:, varMKmuscle);
    dtKdtKsec = X{2}(:, vardtKsec);
    dtKcdKtrans = X{2}(:, varcdKsec) - X{2}(:, varcdKreab);
    dtKuK      = X{2}(:, varuK);
    
    vals = {};
    vals{1} = dtKMKgut;
    vals{2} = dtKMKplasma;
    vals{3} = dtKMKinter;
    vals{4} = dtKMKmuscle;
    vals{5} = dtKdtKsec;
    vals{6} = dtKcdKtrans;
    vals{7} = dtKuK;
    
    dtKmean_vals = zeros(days,7);
    dtKmax_vals = zeros(days,7);
    dtKmin_vals = zeros(days,7);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        for jj = 1:7
            [min_vals, mean_vals, max_vals] = get_day_vals(vals{jj}, start_id, end_id);
            dtKmin_vals(i, jj) = min_vals;
            dtKmean_vals(i, jj) = mean_vals;
            dtKmax_vals(i,jj) = max_vals;
        end
    end
    

    dtK_vals = {dtKmin_vals, dtKmean_vals, dtKmax_vals};
    
    % CD reabsorption
    cdKreabMKgut = X{ind_cdK}(:,varMKgut);
    cdKreabMKplasma = X{ind_cdK}(:,varMKplasma);
    cdKreabMKinter = X{ind_cdK}(:, varMKinter);
    cdKreabMKmuscle = X{ind_cdK}(:, varMKmuscle);
    cdKreabdtKsec = X{ind_cdK}(:, vardtKsec);
    cdKreabcdKreab = X{ind_cdK}(:, varcdKreab);
    cdKreabcdKsec = X{ind_cdK}(:, varcdKsec);
    cdKreabcdKtrans = cdKreabcdKsec - cdKreabcdKreab;
    cdKreabuK      = X{ind_cdK}(:, varuK);

    vals = {};
    vals{1} = cdKreabMKgut;
    vals{2} = cdKreabMKplasma;
    vals{3} = cdKreabMKinter;
    vals{4} = cdKreabMKmuscle;
    vals{5} = cdKreabdtKsec;
    vals{6} = cdKreabcdKtrans;
    vals{7} = cdKreabuK;
    vals{8} = cdKreabcdKsec;
    vals{9} = cdKreabcdKreab;

    cdKreabmean_vals = zeros(days,9);
    cdKreabmax_vals = zeros(days,9);
    cdKreabmin_vals = zeros(days,9);
    for i = 1:days
        start_id = find(t1 == (i-1)*1440+1);
        end_id = find(t1 == i*1440);
        for jj = 1:9
            [min_vals, mean_vals, max_vals] = get_day_vals(vals{jj}, start_id, end_id);
            cdKreabmin_vals(i, jj) = min_vals;
            cdKreabmean_vals(i, jj) = mean_vals;
            cdKreabmax_vals(i,jj) = max_vals;
        end
    end

    cdKreab_vals = {cdKreabmin_vals, cdKreabmean_vals, cdKreabmax_vals};

end % function

function [min_vals, mean_vals, max_vals] = get_day_vals(vals, start_id, end_id)
    min_vals = min(vals(start_id:end_id));
    mean_vals = mean(vals(start_id:end_id));
    max_vals = max(vals(start_id:end_id));
end