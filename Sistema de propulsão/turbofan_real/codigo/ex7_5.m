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
input(1).T_0 = 390 * 0.555556; %[K] * fator de conversao rankine-kelvin
input(2).T_0 = 390 * 0.555556; %[K] * fator de conversao rankine-kelvin
input(3).T_0 = 390 * 0.555556; %[K] * fator de conversao rankine-kelvin
input(4).T_0 = 390 * 0.555556; %[K] * fator de conversao rankine-kelvin
input(1).y_c = 1.4;
input(2).y_c = 1.4;
input(3).y_c = 1.4;
input(4).y_c = 1.4;
input(1).pi_b = 0.9;
input(2).pi_b = 0.92;
input(3).pi_b = 0.94;
input(4).pi_b = 0.95;
input(1,:).pi_c = [1:0.1:40];
input(2,:).pi_c = [1:0.1:40];
input(3,:).pi_c = [1:0.1:40];
input(4,:).pi_c = [1:0.1:40];
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
input(1).P0_P9 = 1;
input(2).P0_P9 = 1;
input(3).P0_P9 = 1;
input(4).P0_P9 = 1;
input(1).c_pc = 0.24 * 4186.800000009; %[J/kgK] conversao de btu/lbm.R
input(2).c_pc = 1004; %[J/kgK]
input(3).c_pc = 1004; %[J/kgK]
input(4).c_pc = 1004; %[J/kgK]
input(1).y_t = 1.33;
input(2).y_t = 1.33;
input(3).y_t = 1.33;
input(4).y_t = 1.33;
input(1).c_pt = 0.276 * 4186.800000009; %[J/kgK]
input(2).c_pt = 0.276 * 4186.800000009; %[J/kgK]
input(3).c_pt = 0.276 * 4186.800000009; %[J/kgK]
input(4).c_pt = 0.276 * 4186.800000009; %[J/kgK]
input(1).h_PR = 18.4 * 2326; %[J/kg] covnersao btu/lbm
input(2).h_PR = 18.4 * 2326; %[J/kg] covnersao btu/lbm
input(3).h_PR = 18.4 * 2326; %[J/kg] covnersao btu/lbm
input(4).h_PR = 18.4 * 2326; %[J/kg] covnersao btu/lbm
input(1).T_t4 = 3000 * 0.555556; %[K]]
input(2).T_t4 = 3000 * 0.555556; %[K]]
input(3).T_t4 = 3000 * 0.555556; %[K]]
input(4).T_t4 = 3000 * 0.555556; %[K]]

figure(); hold on;
%% resolve
 for i=1:1
 output(i) = resolve(@turbojet_real, input(i), 'pi_c', 'trunca');
 %% grafico da tração específica F_m_0
 subplot(2,2,1); hold on;  grid minor;
 plot(input(i).pi_c, output(i).F_m_0);
 %legenda(input.M_0,'M_0=');
 xlabel('\pi_c');
 ylabel('F/m_0 [N/kg.s] ');

%% grafico de consumo específico S
subplot(2,2,2); hold on; grid minor;
plot(input(i).pi_c, output(i).S);
% ylim([20 65]);
xlabel('\pi_c');
ylabel('S [mg/N.s]');

%% grafico da razao ar-combustivel
subplot(2,2,3); hold on; grid minor;
plot(input(i).pi_c, output(i).f);
xlabel('\pi_c');
ylabel('f');

%% graficos das eficiencias
subplot(2,2,4); hold on; grid minor;
plot(input(i).pi_c, output(i).n_T,'-.');
%legenda('','\eta_T');
plot(input(i).pi_c, output(i).n_P,'--');
%legenda('','\eta_P');
plot(input(i).pi_c, output(i).n_0,':');
%legenda('','\eta_0');
%ylim([0 1]);
xlabel('\pi_c');
ylabel('\eta');

 
end

