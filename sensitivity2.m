% runs the getSS function using given input

%% Begin user input
pars = set_params();

%heat map preparation
xlabels = {'V_{max}','K_{m}', 'P_{trans}', '\Phi_{filK}', '\Phi_{dtKsec}^{eq}', 'A_{dt-Ksec}','B_{dt-Ksec}','\Phi_{cd-Ksec}^{eq}','A_{cd-Ksec}','B_{cd-Ksec}','A_{cd-Kreab}'};
ylabels = {'K_{plasma}','K_{IC}'};
cdata = zeros(length(ylabels),length(xlabels));

Kin.Kin_type = 'gut_Kin3';
Kin.Meal = 1;
Kin.KCL  = 1;
MKX = 0; %MK crosstalk
urine = true;

alt_sim = false; %true; %false; % run an alternative simulation (if set up)
if alt_sim
    disp('******doing alt_sim**********')
end

IG_dir = './IGData/';
if MKX
    IG_fname = 'KregSS_MK.mat';
else
    IG_fname = 'KregSS.mat';
end

%% end user input

IG_file = append(IG_dir, IG_fname);
% the original steady state
[SSdata, exitflag, residual] = getSS(IG_file, pars, Kin,...
                                'alt_sim', alt_sim, ...
                                'do_M_K_crosstalk', [MKX, 0.1], ...
                                'urine',urine);
if exitflag <=0
    disp(residual)
end

pars = set_params();
index = 1;
disp(xlabels{index})
pars.Vmax=pars.Vmax*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.Km=pars.Km*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index+1;
disp(xlabels{index})
pars.P_muscle = pars.P_muscle*(1.1); % P_trans
cdata = record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index+1;
disp(xlabels{index})
pars.GFR = pars.GFR*(1.1); % Phi_filK
cdata = record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);


pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.Phi_dtKsec_eq=pars.Phi_dtKsec_eq*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);


pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.dtKsec_A=pars.dtKsec_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.dtKsec_B=pars.dtKsec_B*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.Phi_cdKsec_eq=pars.Phi_cdKsec_eq*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.cdKsec_A=pars.cdKsec_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.cdKsec_B=pars.cdKsec_B*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);

pars = set_params();
index = index + 1;
disp(xlabels{index})
pars.cdKreab_A=pars.cdKreab_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);


% pars = set_params();
% index = index + 1;
% disp(xlabels{index})
% pars.ALD_eq = pars.ALD_eq*(1.1);
% cdata = record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);





% disp_SSdata = 1; % set of 0 if don't want all variable output printed
% if disp_SSdata
%     for ii = 1:length(SSdata)
%         if ismember(pars.varnames{ii}, ['K_{plasma}','K_{muscle}'])
%             fprintf('%s %.5f \n', pars.varnames{ii}, SSdata(ii))
%         end
%     end %for
% end %if


% round cdata values
cdata_round =  round(cdata,2,"significant");
% set values less than 1% to NaN
cdata_h = cdata_round;
[r,c] = find(abs(cdata_h) <= 0.5);
for ii = 1:length(r)
   cdata_h(r(ii), c(ii)) = NaN;
end
%figure
%h = heatmap(xvalues,yvalues,cdata);

figure
h = heatmap(xlabels,ylabels,cdata_h, ...
        'colormap', parula, ...
        'MissingDataColor', 'w', 'MissingDataLabel', '<0.5%;');
h.FontSize = 14;

% figure
% h = heatmap(xlabels,ylabels,cdata_round, ...
%         'colormap', parula, ...
%         'MissingDataColor', 'w', 'MissingDataLabel', '<0.5%;');
% h.FontSize = 16;

function p_diff = percent_difference(original_value,perturbed_value)
p_diff = 100.0*(perturbed_value-original_value)/original_value;
end %function

function newdata_array=record_difference(ind,data_array,original_data,IG_file,pars,Kin,alt_sim,MKX,urine)
[SSdata_perturbed, exitflag, residual] = getSS(IG_file, pars, Kin,...
                                'alt_sim', alt_sim, ...
                                'do_M_K_crosstalk', [MKX, 0.1], ...
                                'urine',urine);
if exitflag <=0
    disp(residual)
end
disp_SSdata = 1; % set of 0 if don't want all variable output printed
if disp_SSdata
    for ii = 1:length(SSdata_perturbed)
        if strcmp(pars.varnames{ii},'K_{plasma}')
            data_array(1,ind)=percent_difference(original_data(ii),SSdata_perturbed(ii));
        elseif strcmp(pars.varnames{ii},'K_{muscle}')
            data_array(2,ind)=percent_difference(original_data(ii),SSdata_perturbed(ii));
        end
    end %for
end %if
newdata_array=data_array;
pars = set_params();
end%function
