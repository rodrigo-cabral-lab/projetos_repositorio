clc; clear all; close all;
%% graficos par o turbojet real
% dados:
% 1 lbf = 4.448 N 
% 1 lbm = 0.4536 kg
% queremos F_m_0 > 950
% e S < 40
% difusor tipo C e nozzle tipo F


input.M_0 = 0.8;
input.y_c = 1.4;
input.P0_P9 = 0.8;
input.y_t = 1.3;
input.c_pc = 1004; %[J/kgK] conversao de btu/lbm.R
input.c_pt = 1239 ; %[J/kgK]
input.h_PR = 42800*1e3; %[J/kg] covnersao btu/lbm
input.T_t4 = 1780; %[K]
input.pi_c = 9;
input.T_0 = 229; %[K] * fator de conversao rankine-kelvin
input.pi_dmax = 0.95;
input.pi_n = 0.98;
input.n_m = 0.98;
input.pi_b = 0.94;
input.n_b = 0.99;
input.e_c = 0.85;
input.e_t = 0.88;
input.P_0 = 29.92; %[kPa]


%% resolve
output = resolve(@turbojet_real, input, 'pi_c', 'raw');

% %% grafico da tração específica F_m_0
% subplot(2,1,1); hold on; 
% plot(input.pi_c, output.F_m_0);
% legenda(lvl(i),'lvl=');
% xlabel('\pi_c');
% ylabel('F/m_0 [N/kg.s] ');hold off;
% if i==3
%     grid minor;
% end
% hold off;
% 
% %% grafico de consumo específico S
% subplot(2,1,2); hold on; 
% plot(input.pi_c, output.S);
% legenda(lvl(i),'lvl=');
% % ylim([20 65]);
% xlabel('\pi_c');
% ylabel('S [mg/N.s]');
% if i==3
%     grid minor;
% end
% hold off;
% 
% % %% grafico da razao ar-combustivel
% % subplot(2,3,3); hold on; 
% % plot(input.pi_c, output.f);
% % legenda(lvl(i),'lvl=');
% % xlabel('\pi_c');
% % ylabel('f');
% % if i==1
% %     grid minor;
% % end
% % hold off;
% % 
% % %% graficos das eficiencias
% % %output = resolve(@ramjet_real, input, 'M_0','trunca');
% % subplot(2,3,4); 
% % hold on;
% % plot(input.pi_c, output.n_T,'-.');
% % legenda(lvl(i),'lvl=');
% % xlabel('\pi_c');
% % ylabel('\eta_T');
% % if i==1
% %     grid minor;
% % end
% % hold off;
% % 
% % subplot(2,3,5); 
% % hold on; 
% % plot(input.pi_c, output.n_P,'--');
% % legenda(lvl(i),'lvl=');
% % xlabel('\pi_c');
% % ylabel('\eta_P');
% % if i==1
% %     grid minor;
% % end
% % hold off;
% % 
% % subplot(2,3,6);
% % hold on; 
% % plot(input.pi_c, output.n_0,':');
% % legenda(lvl(i),'lvl=');
% % xlabel('\pi_c');
% % ylabel('\eta_0');
% % if i==1
% %     grid minor;
% % end
% % hold off;
