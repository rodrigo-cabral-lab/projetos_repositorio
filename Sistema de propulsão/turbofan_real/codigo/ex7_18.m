% exercicio 7.18 lista do pimentinha

clc; close all; clear all;


set(groot, 'DefaultFigurePaperUnits', 'inches', ...
           'DefaultFigureUnits', 'inches', ...
           'DefaultFigurePaperPosition', [0 0 1480 640]/200, ...
           'DefaultFigurePaperSize', [1480 640]/200, ...
           'DefaultFigurePosition', [0 0 1480 640]/200);

%% graficos do turbofan real

input.M_0 = 0.8;
input.T_0 = 216.7; %K
input.h_PR = 42.8e6; %J/kg
input.y_c = 1.4;
input.c_pc = 1004; %J/kgK
input.y_t = 1.3;
input.c_pt = 1239; %J/kgK
input.T_t4 = 1390; 
input.P0_P9 = 1;
input.P0_P19 = 1; 
input.pi_dmax = 0.95;
input.pi_b = 0.92;
input.pi_f = [1.6:0.01:1.63 1.9:0.01:1.93];
input.pi_fn = 1;
input.pi_n = 0.97;
input.e_f = 0.82;
input.e_c = 0.84;
input.e_t = 0.85;
input.n_b = 0.94;
input.n_m = 0.97;
input.pi_c = [2:0.1:40];


real = resolve(@turbofan_real_a_opt,input,'pi_c','pi_f');

%% tracao especifica
figure()
hold on; grid minor;
plot(input.pi_c, real.F_m_0);
xlabel('\pi_c');
ylabel('F/m_0 [N/(kg/s)]');
ylim([130 200])
legenda(input.pi_f, '\pi_f=');

%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1480 840]/200);
%pause(0.1)
saveas(gcf,'/home/ppiper/Dropbox/Sistemas_de_propulsao_I/Lista/imgs/ex7_18_1','epsc');

%% consumo especifico
figure()
hold on; grid minor;
plot(input.pi_c, real.S);
xlabel('\pi_c');
ylabel('S [(mg/s)/N]');
ylim([27 28])
legenda(input.pi_f, '\pi_f=');

%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1480 840]/200);
%pause(0.1)
saveas(gcf,'/home/ppiper/Dropbox/Sistemas_de_propulsao_I/Lista/imgs/ex7_18_2','epsc');