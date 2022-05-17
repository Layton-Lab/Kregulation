% This script is for making the dataframe PrestonData

%% serum data
time_serum = [0,15,30,45,60,90,150,210,270];
Meal_serum = [4.50408;4.3551;4.08571;4.01633;3.88776;3.86327;3.95306;3.99592;4.11837];%4.50408;
Meal_serum_err = [0.0618;0.0765;0.0573;0.0724;0.0452;0.0748;0.0767;0.0452;0.0899];
KCL_serum = [4.52857;4.75714;5.01429;4.96939;4.99592;4.98571;4.89592;4.76327;4.66735];
KCL_serum_err = [0.10834;0.1130;0.1128;0.0968;0.1108;0.0737;0.0790;0.1035;0.1217];
MealKCL_serum = [4.47551;4.49592;4.44898;4.39184;4.28367;4.36122;4.51837;4.42857;4.53061];
MealKCL_serum_err = [0.0752;0.0835;0.1000;0.0997;0.0896;0.1067;0.0780;0.1238;0.1266];

%scale to baseline
baseline = (Meal_serum(1) + KCL_serum(1) + MealKCL_serum(1))/3;
Meal_serum_scaled = Meal_serum/baseline*4.1;
KCL_serum_scaled = KCL_serum/baseline*4.1;
MealKCL_serum_scaled = MealKCL_serum/baseline*4.1;

%% UK data
time_UK = [0,60,120,180,240,300]; 
time_UK_weighted = [0,0,0,60,120,180,240,300]; 
time_UK_nodatapoint = [0,0,0,120,180,240,300]; % no outlying datapoint and weighted
Meal_UK = [2.7774;3.2438;1.788;1.5901;1.9293;2.0565]/60; % make data in minutes
Meal_UK_weighted = [2.7774;2.7774;2.7774;3.2438;1.788;1.5901;1.9293;2.0565]/60; % weighted
Meal_UK_nodatapoint= [2.7774;2.7774;2.7774;1.788;1.5901;1.9293;2.0565]/60; % no outlying datapoint and weighted
Meal_UK_err = [0.3279;0.2175;0.0775;0.0901;0.1398;0.1618]/60;
Meal_UK_err_weighted = [0.3279;0.3279;0.3279;0.2175;0.0775;0.0901;0.1398;0.1618]/60;
Meal_UK_err_nodatapoint = [0.3279;0.3279;0.3279;0.0775;0.0901;0.1398;0.1618]/60;
KCL_UK = [2.6502;9.9576;9.4205;6.3675;4.9965;3.8516]/60;
KCL_UK_err = [0.2709;0.8845;0.6321;0.6062;0.3456;0.3326]/60;
MealKCL_UK = [2.4806;5.0813;4.1625;4.8269;3.8375;3.1731]/60;
MealKCL_UK_err = [0.4405;0.7608;0.4691;0.5415;0.4783;0.4322]/60;


%% Cumulative UK data
time_UK_cmlt = [0,60,120,180,240,300];
Meal_UK_cmlt = [5.6460;8.8850;10.7434;12.3894;14.3009;16.5310];
Meal_UK_cmlt_err = [0;0.7433;0.9026;0.9557;1.0088;1.0088];
KCL_UK_cmlt = [5.2743;15.3628;24.8673;31.2389;36.3894;40.3186];
KCL_UK_cmlt_err = [0;1.1682;1.1150;1.5399;1.5929;1.9115];
MealKCL_UK_cmlt = [4.9558;10.1593;14.3540;19.2920;23.1681;26.4071];
MealKCL_UK_cmlt_err = [0;0.9557;1.2743;1.6461;1.8054;1.9646];

baseline = (Meal_UK(1) + KCL_UK(1) + MealKCL_UK(1))/3;
pars = set_params();
% need to scale so the SS UK matches
Meal_UK_scaled = Meal_UK;
Meal_UK_scaled_nodatapoint = Meal_UK_nodatapoint;
Meal_UK_weighted_scaled = Meal_UK_weighted;
KCL_UK_scaled = KCL_UK;
MealKCL_UK_scaled = MealKCL_UK;

% Meal_UK_scaled = Meal_UK/Meal_UK(1)*(0.9 * pars.Phi_Kin_ss);
% KCL_UK_scaled = KCL_UK/KCL_UK(1)*(0.9 * pars.Phi_Kin_ss);
% MealKCL_UK_scaled = MealKCL_UK/MealKCL_UK(1) *(0.9 * pars.Phi_Kin_ss);

%% cumulative UK data
time_sumUK = [0; 60; 120; 180; 240; 300];
Meal_sumUK = [0; 10; 12; 14; 16; 18];
MealKCL_sumUK = [0; 11; 15; 20; 24; 28];
KCL_sumUK = [0; 16; 27; 32; 37; 40];

%% [ALD] data
time_ALD = [0; 15; 30; 45; 60; 90; 150; 210; 270];
Meal_ALD = [18.6167;19.1422;17.6275;17.6584;17.9057;17.5657;18.864;21.1515;21.0587]*10; 
KCL_ALD = [21.2751;27.4884;31.9706;32.187;32.2798;29.9923;25.541;25.0464;24.1808]*10;
MealKCL_ALD = [19.8223;24.9845;25.7264;25.9428;25.6337;26.1901;26.6538;26.8083;25.0773]*10;


Meal_ALD_scaled = (Meal_ALD)/Meal_ALD(1)*85;
KCL_ALD_scaled = (KCL_ALD)/KCL_ALD(1)*85;
MealKCL_ALD_scaled = (MealKCL_ALD)/MealKCL_ALD(1)*85;

%% save data to PrestonData.mat to use in fitting
save('C:\Users\melis\OneDrive - University of Waterloo\Layton Lab Research\Research-K-homeostasis\manuscript\code\Kregulation\Data\PrestonData.mat')

% Notes:
% A nice way to load could be data = load('PrestonData.mat')
% then I can call what I want using data.Meal_ALD for example rather than
% have all the variables
% i.e., data would be struct that I can work with