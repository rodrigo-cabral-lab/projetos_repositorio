clc; close all; clear all;
%% graficos do turbofan real

input.M_0 = 0.9;
input.T_0 = 216.7; %K
input.h_PR = 42.8e6; %J/kg
input.y_c = 1.4;
input.c_pc = 1004; %J/kgK
input.y_t = 1.35;
input.c_pt = 1096; %J/kgK
input.T_t4 = 1670; %K
input.P0_P9 = 1;
input.P0_P19 = 1;
input.pi_dmax = 0.98;
input.pi_b = 0.98;
input.pi_f = 2;
input.pi_fn = 0.98;
input.pi_n = 0.98;
input.e_f = 0.88;
input.e_c = 0.90;
input.e_t = 0.91;
input.n_b = 0.99;
input.n_m = 0.98;
input.pi_c = [1:0.1:30];
input.a = [0.5;1;2;5];
input.y = 1.4;
input.c_p = 1004;

real = resolve(@turbofan_real,input,'pi_c','a');
ideal = resolve(@turbofan_ideal,input,'pi_c','a');

%% tracao especifica
figure(); hold on; grid minor;
plot(input.pi_c,real.F_m_0);
plot(input.pi_c,ideal.F_m_0,'--');
legenda(input.a,'real, a=');
legenda(input.a,'ideal, a=');
xlabel('\pi_c');
ylabel('F/m_0 [N/(kg/s)]');

%% consumo especifico
figure(); hold on; grid minor;
plot(input.pi_c,real.S);
plot(input.pi_c,ideal.S,'--');
ylim([15 50]);
legenda(input.a,'real, a=');
legenda(input.a,'ideal, a=');
xlabel('\pi_c');
ylabel('S [(mg/s)/N]');

%% razao ar combustivel
figure(); hold on; grid minor;
plot(input.pi_c,real.f);
plot(input.pi_c,ideal.f,'--');
xlabel('\pi_c');
ylabel('f');

%% mach_0 variando e pi_c = 24
input.M_0 = [0:0.1:3];
input.pi_c = 24;
real = resolve(@turbofan_real,input,'M_0','a','trunca');
ideal = resolve(@turbofan_ideal,input,'M_0','a','trunca');

%% tracao especifica
figure(); hold on; grid minor;
plot(input.M_0,real.F_m_0);
plot(input.M_0,ideal.F_m_0,'--');
legenda(input.a,'real, a=');
legenda(input.a,'ideal, a=');
xlabel('\pi_c');
ylabel('F/m_0 [N/(kg/s)]');
ylim([0 1000]);


%% consumo especifico
figure(); hold on; grid minor;
plot(input.M_0,real.S);
plot(input.M_0,ideal.S,'--');
legenda(input.a,'real, a=');
legenda(input.a,'ideal, a=');
xlabel('\pi_c');
ylabel('S [(mg/s)/N]');
ylim([10 40]);



