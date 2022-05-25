% run K+ depletion experiments
close all; clear all;

% simulations 1 (baseline model -- no MKX)
pars1 = set_params();

Kin1.Kin_type = 'long_simulation'; % CHANGE THIS?
Kin1.Meal = 1;
Kin1.KCL = 1;

MealInfo1.t_breakfast = 7;
MealInfo1.t_lunch = 13;
MealInfo1.t_dinner = 19; 
MealInfo1.K_amount = 100/3; % how much K is ingested per meal
MealInfo1.meal_type = 'Kload'; % CHANGE THIS?