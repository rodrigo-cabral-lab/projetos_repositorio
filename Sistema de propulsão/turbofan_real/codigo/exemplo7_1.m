clc; clear all; close all;
%% graficos par o turbojet real
% dados:
input(1).M_0 = 2;
input(2).M_0 = 2;
input(3).M_0 = 2;
input(4).M_0 = 2;
input(1).pi_dmax = 0.9;
input(2).pi_dmax = 0.95;
input(3).pi_dmax = 0.98;
input(4).pi_dmax = 0.995;
input(1).T_0 = 216.7; %[K]
input(2).T_0 = 216.7; %[K]
input(3).T_0 = 216.7; %[K]
input(4).T_0 = 216.7; %[K]
input(1).y_c = 1.4;
input(2).y_c = 1.4;
input(3).y_c = 1.4;
input(4).y_c = 1.4;
input(1).pi_b = 0.9;
input(2).pi_b = 0.92;
input(3).pi_b = 0.94;
input(4).pi_b = 0.95;
input(1).pi_c = 10;
input(2).pi_c = 10;
input(3).pi_c = 10;
input(4).pi_c = 10;
input(1).n_b = 0.88;
input(2).n_b = 0.94;
input(3).n_b = 0.99;
input(4).n_b = 0.999;
input(1).n_m = 0.95;
input(2).n_m = 0.97;
input(3).n_m = 0.99;
input(4).n_m = 0.995;
input(1).pi_n = 0.95;
input(2).pi_n = 0.97;
input(3).pi_n = 0.98;
input(4).pi_n = 0.995;
input(1).e_c = 0.80;
input(2).e_c = 0.84;
input(3).e_c = 0.88;
input(4).e_c = 0.90;
input(1).e_t = 0.80;
input(2).e_t = 0.85;
input(3).e_t = 0.89;
input(4).e_t = 0.90;
input(1).P0_P9 = 0.5;
input(2).P0_P9 = 0.5;
input(3).P0_P9 = 0.5;
input(4).P0_P9 = 0.5;
input(1).c_pc = 1004; %[J/kgK]
input(2).c_pc = 1004; %[J/kgK]
input(3).c_pc = 1004; %[J/kgK]
input(4).c_pc = 1004; %[J/kgK]
input(1).y_t = 1.3;
input(2).y_t = 1.3;
input(3).y_t = 1.3;
input(4).y_t = 1.3;
input(1).c_pt = 1239; %[J/kgK]
input(2).c_pt = 1239; %[J/kgK]
input(3).c_pt = 1239; %[J/kgK]
input(4).c_pt = 1239; %[J/kgK]
input(1).h_PR = 42.8e6; %[J/kg]
input(2).h_PR = 42.8e6; %[J/kg]
input(3).h_PR = 42.8e6; %[J/kg]
input(4).h_PR = 42.8e6; %[J/kg]
input(1).T_t4 = 1110; %[K]
input(2).T_t4 = 1390; %[K]
input(3).T_t4 = 1780; %[K]
input(4).T_t4 = 2000; %[K]





%% resolve
for i=1:4
output(i) = resolve(@turbojet_real, input(i), 'pi_c', 'M_0','trunca');
output(i)
end

