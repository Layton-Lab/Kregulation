# KregW22

Code files for K+ regulation model.

## Key files

**checkIC.m** uses MATLAB function decic to check if the initial condition is consistent

**fit_FF.m** fit the FF parameter to the KCL only data, calls **fit_KCL_Preston2015**

**fit_insulin.m** fit insulin_A and insulin_B parameters to the Meal only data, calls **fit_Meal_Preston2015**

**fir_params** fits FF, insulin_A, insulin_B, cdKreab_A, cdKreab_B to Meal, KCL, Meal and KCL data by calling **fit_KCLandMeal_Preston2015**

**run_getSS.m** calls **getSS** which computes the steady state of the given system

**k_reg_mod** model equations

**get_Cinsulin** computes C_ins parameter
**plot_Cinsulin** calls **get_Cinsulin** to plot C_ins and rho_insulinso that the user can check whether the get_Cinsulin  behaves correctly

**get_PhiKin** computes K+ intake in mEq at a given time

**get_rhoins** computes rho_insulin at a given time

**get_FF** computes gamma_Kin

**run_Preston_exp** runs the Meal only, KCL only and Meal+KCL only simulations and then plots relevant results using **plot_Preston_exp**; makes plots for the manuscript using **plot_nicePreston**

**run_simulation** runs 2 simulations based on given specifications, plots relevant results using **plot_simulation**

**run_fig3_sim** runs 2 simulations (one - without MK Xtalk, one with DT K sec Xtalk); 2 days at 120 mEq/day of K+, 4 days at 400 mEq/day, 4 days at 120 mEq/day; plots relevant results using **plot_fig3_sim**

**run_fig4_sim** runs 3 simulations comparing different crosstalks; 10 days depletion at 35 mEq/day of K+, then 10 days at normal 120 mEq/day; plots relevant results using **plot_fig4_sim**

**set_params** sets the model parameters

**plot_dMKgut_dt** and **get_dMKgut_dt** work together dMKgut, dMKmuscle, Phi_ECtoIC, Phi_ICtoEC when called for by run_simulation code.

### Data/
contains data file from Preston et al. 2015
data file is generated from makePrestonData.m

### IGdata/
data for initial guesses

### fitting_eqns
files for investigating other functions in devlopment


