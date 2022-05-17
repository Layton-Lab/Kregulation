function rho_ins = get_rhoins(C_insulin, insulin_A, insulin_B)
    % computes value of rho_insulin
    ins_A = insulin_A;
    ins_B = 100*insulin_B;
    L = 100;
    x0 = 0.5381;
    k = 1.068;
    temp = (ins_A.*(L./(1+exp(-k.*(log10(C_insulin)-log10(x0)))))+ ins_B)./100;
    rho_ins = max(1.0, temp);
end

