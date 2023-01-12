# K Regulation

Code files for K+ homeostasis regulation model described in [Stadt et al. "A mathematical model of potassium homeostasis: Effect of feedforward and feedback controls," PLOS Computational Biology, 2022.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010607)

## Key files

**checkIC.m** uses MATLAB function decic to check if the initial condition is consistent

**fit_FF.m** fit the FF parameter to the KCL only data, calls **fit_KCL_Preston2015**

**fit_insulin.m** fit insulin_A and insulin_B parameters to the Meal only data, calls **fit_Meal_Preston2015**

**fit_params** fits FF, insulin_A, insulin_B, cdKreab_A, cdKreab_B to Meal, KCL, Meal and KCL data by calling **fit_KCLandMeal_Preston2015**

**run_getSS.m** calls **getSS** which computes the steady state of the given system

**k_reg_mod** model equations

**get_Cinsulin** computes C_ins parameter
**plot_Cinsulin** calls **get_Cinsulin** to plot C_ins and rho_insulinso that the user can check whether the get_Cinsulin  behaves correctly

**get_PhiKin** computes K+ intake in mEq at a given time

**get_rhoins** computes rho_insulin at a given time

**get_FF** computes gamma_Kin

**run_Preston_exp** runs the Meal only, KCL only and Meal+KCL only simulations and then plots relevant results using **plot_Preston_exp**. This can be used to recreate Fig. 4, 5, and 6 from [Stadt et al. 2022](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010607).

**run_simulation** runs 2 simulations based on given specifications, plots relevant results using **plot_simulation**

**run_Kload** run K loading simulations, plot relevant results using **plot_Kload_sim**. Run to recreate Fig. 8 from 
[Stadt et al. 2022](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010607).

**run_Kdeplete** runs K depletion simulations, plot relevant results using **plot_Kdeplete**. Run to recreate Fig. 9 from [Stadt et al. 2022](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010607). 

**set_params** sets the model parameters

**sensitivity2** conducts local sensitivity analysis. Run to recreate Fig. 3 from [Stadt et al.](https://www.biorxiv.org/content/10.1101/2022.09.28.509841v1).

**run_feedback_sims** conducts simulations with feedback/feedforward mechanisms off, plots relevant results using **plot_5_sims**. Run to recreate Fig. 7 from [Stadt et al. 2022](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010607).


### Data/
contains data file from Preston et al. 2015
data file is generated from makePrestonData.m

### IGdata/
data for initial guesses


