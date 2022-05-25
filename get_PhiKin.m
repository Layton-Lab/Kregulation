function [Phi_Kin, t_insulin] = get_PhiKin(t, SS, pars, Kin, MealInfo)
% returns Phi_Kin and t_insulin values based on inputs
if strcmp(Kin.Kin_type, 'long_simulation')
    if SS
        % steady state values
        t_insulin = pars.t_insulin_ss;
        Phi_Kin = pars.Phi_Kin_ss;
    elseif ~SS
        exp_start = 0;%fast_start + 6*60;
        day_cntr = 1; % day counter
        while t>1440   
            t = t - 1440;
            day_cntr = day_cntr +1; % increase the counter by 1
        end
        t_breakfast = MealInfo.t_breakfast * 60;  % *60 converts the time from hours to minutes
        t_lunch = MealInfo.t_lunch * 60;
        t_dinner = MealInfo.t_dinner * 60;
        if t <= exp_start  
            Phi_Kin = 0;
            t_insulin = 0;
            %% experiment starts
        else   % parabola shaped ingestion
            t1 = exp_start + t_breakfast + 30;
            t2 = exp_start + t_breakfast + 15;
            t3 = exp_start + t_lunch + 30;
            t4 = exp_start + t_lunch + 15;
            t5 = exp_start + t_dinner + 30;
            t6 = exp_start + t_dinner + 15;

            %%%%% this is to recreate fig 3
            if strcmp(MealInfo.meal_type, 'Kload')
                if ismember(day_cntr, [3,4,5,6])
                    k_amount = 400/3;
                else
                    k_amount = MealInfo.K_amount;
                end
            elseif strcmp(MealInfo.meal_type, 'Kdeplete')
                %%%% this is to recreate fig 4
                if day_cntr < 35 && day_cntr > 5
                    k_amount = 25/3; %50/3;
                else
                    k_amount = 100/3;
                end
            else
                k_amount = MealInfo.K_amount;
            end


            if t<=t_breakfast %if t>t1   % fasting before breakfast
                Phi_Kin = Kin.KCL*0;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t<= t1   % eating breakfast
                %disp('Parabola shaped K ingestion')
                m = -7/900;
                b = 7/4;
                Phi_Kin = k_amount*(Kin.KCL*(m*(t-t2)*(t-t2)+b))/35;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t<=t_lunch %if t>t1  % fasting before lunch
                Phi_Kin = Kin.KCL*0;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t<= t3   % eating lunch
                %disp('Parabola shaped K ingestion')
                m = -7/900;
                b = 7/4;
                Phi_Kin = k_amount*(Kin.KCL*(m*(t-t4)*(t-t4)+b))/35;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t<=t_dinner %if t>t1   % fasting before dinner
                Phi_Kin = Kin.KCL*0;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t<= t5   % eating dinner
                %disp('Parabola shaped K ingestion')
                m = -7/900;
                b = 7/4;
                Phi_Kin = k_amount*(Kin.KCL*(m*(t-t6)*(t-t6)+b))/35;
                t_insulin = Kin.Meal*(t-exp_start);
            elseif t>t5 %after dinner
                Phi_Kin = Kin.KCL*0;
                t_insulin = Kin.Meal*(t-exp_start);
            else
                disp("WARNING: get_PhiKin long simulation didn't get into any of the statements")
            end

        end %step_Kin
    end %if SS
else
    if SS
        % steady state values
        t_insulin = pars.t_insulin_ss;
        Phi_Kin = pars.Phi_Kin_ss;
    elseif ~SS
        if strcmp(Kin.Kin_type, 'Preston_SS')
            dec_shift = 100;
            if t<=pars.tchange
                Phi_Kin = pars.Phi_Kin_ss;
                t_insulin = pars.t_insulin_ss;
            elseif t<= pars.tchange + dec_shift
                % linear decreased down to 60/1440
                temp = 100/1440 - 60/1440;
                m = temp/100;
                Phi_Kin = -m*(t-pars.tchange) + 100/1440;
                t_insulin = pars.t_insulin_ss + (t - pars.tchange);
            else
                Phi_Kin = 60/1440;
                t_insulin = pars.t_insulin_ss + (t-pars.tchange);
            end
        else
            fast_start = pars.tchange + 60;
            exp_start = fast_start + 6*60;
            if t <= pars.tchange
                Phi_Kin = pars.Phi_Kin_ss;
                t_insulin = pars.t_insulin_ss;
            elseif t<=fast_start
                %first linear decrease to 0
                %Phi_Kin = max(0,-pars.Phi_Kin_ss/120*(t-pars.tchange) + pars.Phi_Kin_ss);
                Phi_Kin = max(0, -pars.Phi_Kin_ss/30*(t-pars.tchange)+pars.Phi_Kin_ss);
                t_insulin = pars.t_insulin_ss + (t - pars.tchange);
            elseif t <= exp_start
                Phi_Kin = 0;
                t_insulin = 0;
                %% experiment starts
            elseif strcmp(Kin.Kin_type, 'gut_Kin')
                t1 = exp_start + 15;
                t2 = t1 + 15;
                if t<= t1
                    h = 35/15;
                    m = (h)/15;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start));
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t2
                    h = 35/15;
                    m = -h/15;
                    b = -m*30;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start) + b);
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t>t2
                    %else
                    Phi_Kin = Kin.KCL*0;
                    t_insulin = Kin.Meal*(t-exp_start);
                end
            elseif strcmp(Kin.Kin_type, 'gut_Kin2')
                t1 = exp_start + 10;
                t2 = t1 + 10;
                t3 = t2 + 10;
                if t<= t1
                    disp('In get_PhiKin gut_Kin2 option was chosen')
                    h = 1.5;
                    m = h/10;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start));
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t2
                    Phi_Kin = 1.5;
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t3
                    h = 1.5;
                    m = -h/10;
                    b = -m*30;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start)+b);
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t>t3
                    %else   % just switching to 'else' instead of 'elseif' has
                    %fixed some errors before.. not sure why
                    Phi_Kin = Kin.KCL*0;
                    t_insulin = Kin.Meal*(t-exp_start);
                end
            elseif strcmp(Kin.Kin_type, 'gut_Kin3')
                t1 = exp_start + 30;
                t2 = exp_start + 15;
                if t<= t1
                    %disp('Parabola shaped K ingestion')
                    m = -7/900;
                    b = 7/4;
                    Phi_Kin = Kin.KCL*(m*(t-t2)*(t-t2)+b);
                    t_insulin = Kin.Meal*(t-exp_start);
                else %if t>t1
                    Phi_Kin = Kin.KCL*0;
                    t_insulin = Kin.Meal*(t-exp_start);
                end

            else
                fprintf('What is this? Kin_type: %s', Kin.Kin_type)
            end %step_Kin
        end % if Preston_60
    end %if SS
end % if long sim

end %get_PhiKin