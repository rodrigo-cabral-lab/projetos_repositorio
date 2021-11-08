clc; clear all; close all;
%% graficos par o turbojet real
% dados:
input.T_0 = 217; %K
input.y_c = 1.4;
input.c_pc = 1004; %J/kgK
input.h_PR = 42.8e6; %J/kg
input.y_t = 1.3;
input.c_pt = 1235; %J/kgK
input.pi_dmax = 0.95;
input.pi_b = 0.94;
input.pi_n = 0.95;
input.n_b = 0.96;
input.n_m = 0.98;
input.P0_P9 = 1;
input.T_t4 = 1800; %K
input.M_0 = [1:0.1:3];

%% resolve
% variando com pi_c e curvas de M_0
output = resolve(@ramjet_real, input, 'M_0','trunca');

%% grafico da tração específica F_m_0
figure(); subplot(2,2,1); hold on; grid minor;
plot(input.M_0, output.F_m_0);
%legenda(input.M_0,'M_0=');
xlabel('\pi_c');
ylabel('F/m_0 [N/kg.s] ');

%% grafico de consumo específico S
subplot(2,2,2); hold on; grid minor;
plot(input.M_0, output.S);
% ylim([20 65]);
xlabel('\pi_c');
ylabel('S [mg/N.s]');

%% grafico da razao ar-combustivel
subplot(2,2,3); hold on; grid minor;
plot(input.M_0, output.f);
xlabel('\pi_c');
ylabel('f');

%% graficos das eficiencias
input.M_0 = [1:1:3];
output = resolve(@ramjet_real, input, 'M_0','trunca');
subplot(2,2,4); hold on; grid minor;
plot(input.M_0, output.n_T,'-.');
legenda('','\eta_T');
plot(input.M_0, output.n_P,'--');
legenda('','\eta_P');
plot(input.M_0, output.n_0,':');
legenda('','\eta_0');
ylim([0 1]);
xlabel('\pi_c');
ylabel('\eta');

