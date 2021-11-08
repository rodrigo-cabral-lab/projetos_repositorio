%Quest�o 7-26
%Turbofan Real com Escoamento Misturado com P�s-combustor

clearvars
close all
clc

%Dados(fixos)

mac_0 = 0.9;
pi_c = 24;
pi_f = 3.5;
cp_c = 240;
gama_c = 1.4;
T0 = 309;
pi_Mmax = 0.98;
hpr = 18400000;
cp_t = 295;
gama_t = 1.3;
cp_AB = 295;
gama_AB = 1.3;
mac_6 = 0.4;
eta_m = 0.99;
pi_09 = 1;

%Dados(variaveis)

pi_dmax = 0.96;
ec = 0.9;
ef = 0.89;
et = 0.89;
pi_n = 0.97;
eta_b = 0.999;
pi_b = 0.95;
Tt4 = 3600;
eta_AB = 0.99;
pi_AB = 0.95;
Tt7 = 4000;

%Equacionamento

R_c = cp_c.*((gama_c-1)./gama_c);
R_t = cp_t.*((gama_t-1)./gama_t);
R_AB = cp_AB.*((gama_AB-1)./gama_AB);
a0 = sqrt(gama_c.*R_c.*T0);
tau_l = (cp_t.*Tt4)./(cp_c.*T0);
V0 = a0.*mac_0;
tau_r = 1 + (((gama_c-1)./2).*mac_0.^2);
pi_r = tau_r.^(gama_c./(gama_c-1));

if mac_0 <= 1
        eta_r = 1;
else
        eta_r = 1 - 0.075.*(mac_0-1).^1.35;
end

pi_d = pi_dmax.*eta_r;
tau_lAB = (cp_AB.*Tt7)./(cp_c.*T0);
tau_c = pi_c.^((gama_c-1)./(gama_c.*ec));
eta_c = (pi_c.^((gama_c-1)./gama_c)-1)./(tau_c-1);
tau_f = pi_f.^((gama_c-1)./(gama_c.*ef));
eta_f = (pi_f.^((gama_c-1)./gama_c)-1)./(tau_f-1);
f = (tau_l - tau_r.*tau_c)./(((eta_b.*hpr)./(cp_c.*T0))-tau_l);
bypass = (eta_m.*(1+f).*(tau_l./tau_r).*(1-((pi_f./(pi_c.*pi_b)).^(((gama_t-1).*et)./gama_t)))-tau_c+1)./(tau_f-1);
tau_t = 1 - ((1./(eta_m.*(1+f))).*(tau_r./tau_l).*(tau_c-1+bypass.*(tau_f-1)));
pi_t = tau_t.^(gama_t./((gama_t-1).*et));
eta_turb = (1-tau_t)./(1-(tau_t.^(1/et)));
pi_166 = (pi_f)./(pi_c.*pi_b.*pi_t);
mac_16 = sqrt((2./(gama_c-1)).*((pi_166.*(1+((gama_t-1)/2).*(mac_6.^2)).^(gama_t./(gama_t-1))).^((gama_c-1)./gama_c)-1));
bypass_2 = bypass./(1+f);
cp_6a = (cp_t + (bypass_2.*cp_c))./(1+bypass_2);
R_6a = (R_t + (bypass_2.*R_c))./(1+bypass_2);
gama_6a = (cp_6a)./(cp_6a-R_6a);
tau_166 = (T0.*tau_r.*tau_f)./(Tt4.*tau_t);
tau_M = (cp_t./cp_6a).*((1+bypass_2.*((cp_c./cp_t).*(tau_166)))./(1+bypass_2));
phi_m6y6 = ((mac_6.^2).*(1+((gama_t-1)./2).*(mac_6.^2)))./((1+(gama_t.*(mac_6.^2))).^2);
phi_m16y16 = ((mac_16.^2).*(1+((gama_c-1)./2).*(mac_16.^2)))./((1+(gama_c.*(mac_16.^2))).^2);
phi_m6ay6a = (((1+bypass_2)./((1./(sqrt(phi_m6y6)))+bypass_2.*sqrt(((R_c.*gama_t)./(R_t.*gama_c))*(tau_166./phi_m16y16)))).^2).*(R_6a./R_t).*(gama_t./(gama_6a)).*(tau_M);
mac_6a = sqrt((2.*phi_m6ay6a)./(1-(2.*gama_6a.*phi_m6ay6a)+sqrt(1-(2.*(gama_6a+1).*phi_m6ay6a))));
a_166 = (bypass_2.*sqrt(tau_166))./((mac_16./mac_6).*sqrt((gama_c./gama_t).*(R_t./R_c).*((1+((gama_c-1)./2).*(mac_16.^2))./(1+((gama_t-1)./2).*(mac_16.^2)))));
MFP_6t = (mac_6.*sqrt(gama_t./R_t))./((1+((gama_t-1.)/2).*(mac_6.^2)).^((gama_t+1)./(2.*(gama_t-1))));
MFP_6a = (mac_6a.*sqrt(gama_6a./R_6a))./((1+((gama_6a-1.)/2).*(mac_6a.^2)).^((gama_6a+1)./(2.*(gama_6a-1))));
pi_Mideal = (((1+bypass_2).*sqrt(tau_M))./(1+a_166)).*(MFP_6t./MFP_6a);
pi_M = pi_Mmax.*pi_Mideal;
pi_9 = pi_09.*pi_r.*pi_d.*pi_c.*pi_b.*pi_t.*pi_M.*pi_AB.*pi_n;

%P�s-Combustor Ligado

cp_9 = cp_AB;
R_9 = R_AB;
gama_9 = gama_AB;

f_AB = (1+(f./(1+bypass))).*((tau_lAB-((cp_6a./cp_t).*tau_l.*tau_t.*tau_M))./(((eta_AB.*hpr)./(cp_c.*T0))-tau_lAB));
tau_90 = (Tt7./T0)./(pi_9.^((gama_9-1)./gama_9));
mac_9 = sqrt((2./(gama_9-1)).*((pi_9.^((gama_9-1)./gama_9))-1));
V9_a0 = mac_9.*sqrt(((gama_9.*R_9)/(gama_c.*R_c)).*tau_90); 
f0 = (f./(1+bypass))+f_AB;
F_m0 = a0.*((1+f0).*V9_a0-mac_0+(1+f0).*(R_9./R_c).*(tau_90./V9_a0).*((1-pi_09)./gama_c));
S = (f0./F_m0).*10^3;
eta_p = (2.*V0.*F_m0)./(a0.^2.*((1+f0).*((V9_a0).^2)-(mac_0.^2)));
eta_t = (a0.^2.*((1+f0).*((V9_a0).^2)-(mac_0.^2)))./(2.*f0*hpr);
eta_o = eta_p.*eta_t;

 T = table([pi_dmax],[ec],[ef],[et],[pi_n],[pi_b],[pi_AB],[eta_b],[Tt4],[Tt7],[eta_AB],[mac_9],[f0],[F_m0],[S],[eta_p],[eta_t],[eta_o]);;
 T.Properties.VariableNames = {'Pi_Dmax','ec','ef','et','pi_n','pi_b','pi_AB','eta_b','Tt4','Tt7','eta_AB','Mach_9','f0','F_m0','S','eta_p','eta_t','eta_o'}






