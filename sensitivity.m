% runs the getSS function using given input

%% Begin user input
pars = set_params();

%heat map preparation
xvalues = {'V_{max}','K_{m}','Phi_{dtKsec eq}','A_{dtKsec}','B_{dtKsec}','Phi_{cdKsec eq}','A_{cdKsec}','B_{cdKsec}','A_{cdKreab}','B_{cdKreab}'};
yvalues = {'K_{plasma}','K_{muscle}'};
cdata = zeros(length(yvalues),length(xvalues));

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

index = 1;
pars.Vmax=pars.Vmax*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.Km=pars.Km*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.Phi_dtKsec_eq=pars.Phi_dtKsec_eq*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.dtKsec_A=pars.dtKsec_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.dtKsec_B=pars.dtKsec_B*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.Phi_cdKsec_eq=pars.Phi_cdKsec_eq*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.cdKsec_A=pars.cdKsec_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.cdKsec_B=pars.cdKsec_B*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.cdKreab_A=pars.cdKreab_A*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();
index = index + 1;
pars.cdKreab_B=pars.cdKreab_B*(1.1); %add 10%
cdata=record_difference(index,cdata,SSdata,IG_file,pars,Kin,alt_sim,MKX,urine);
pars = set_params();



% disp_SSdata = 1; % set of 0 if don't want all variable output printed
% if disp_SSdata
%     for ii = 1:length(SSdata)
%         if ismember(pars.varnames{ii}, ['K_{plasma}','K_{muscle}'])
%             fprintf('%s %.5f \n', pars.varnames{ii}, SSdata(ii))
%         end
%     end %for
% end %if


% round cdata values
cdata_round =  round(cdata,3,"significant");
figure
h = heatmap(xvalues,yvalues,cdata);
figure
h_round = heatmap(xvalues,yvalues,cdata_round);

function p_diff = percent_difference(original_value,perturbed_value)
p_diff = (perturbed_value-original_value)/original_value;
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
