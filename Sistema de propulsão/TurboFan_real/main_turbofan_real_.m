clc; close all; clear all;
%% graficos do turbofan real

input.M_0 = 0.8;
input.T_0 = 390; %R
input.h_PR = 18400; %J/kg
input.y_c = 1.4;
input.c_pc = 0.240; %J/kgK
input.y_t = 1.33;
input.c_pt = 0.276; %J/kgK
input.T_t4 = 3000; %K
input.P0_P9 = 0.9;
input.P0_P19 = 0.9;
input.pi_dmax = 0.99;
input.pi_b = 0.96;
input.pi_f = 1.7;
input.pi_fn = 0.99;
input.pi_n = 0.99;
input.e_f = 0.89;
input.e_c = 0.90;
input.e_t = 0.89;
input.n_b = 0.99;
input.n_m = 0.99;
input.pi_c = 36;
input.a = 8;
% input.y = 1.4;
% input.c_p = 1004;

real = resolve(@turbofan_real_,input,'pi_c','a')
%ideal = resolve(@turbofan_ideal,input,'pi_c','a');

%% tracao especifica
figure(); hold on; grid minor;
plot(input.pi_c,real.F_m_0);
plot(input.pi_c,ideal.F_m_0,'--');

%% consumo especifico
figure(); hold on; grid minor;
plot(input.pi_c,real.S);
plot(input.pi_c,ideal.S,'--');
ylim([15 50]);
