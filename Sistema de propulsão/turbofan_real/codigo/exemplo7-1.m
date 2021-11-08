clc; clear all; close all;
%% graficos par o turbojet real
% dados:
input.M_0 = 2;
input.pi_dmax = 0.95;
input.T_0 = 216.7; %[K]
input.y_c = 1.4;
input.pi_b = 0.94;
input.pi_c = 10;
input.n_b = 0.98;
input.n_m = 0.99;
input.pi_n = 0.96;
input.e_c = 0.9;
input.e_t = 0.9;
input.P0_P9 = 0.5;
input.c_pc = 1004; %[J/kgK]
input.y_t = 1.3;
input.c_pt = 1239; %[J/kgK]
input.h_PR = 42.8e6; %[J/kg]
input.T_t4 = 1800; %[K]


%% resolve
output = resolve(@turbojet_real, input, 'pi_c', 'M_0','trunca');

output