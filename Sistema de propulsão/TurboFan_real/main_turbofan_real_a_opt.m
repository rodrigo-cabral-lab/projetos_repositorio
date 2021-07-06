clc; close all; clear all;
%% graficos do turbofan real

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
input.pi_fn = 0.98;
input.pi_n = 0.98;
input.e_f = 0.88;
input.e_c = 0.90;
input.e_t = 0.91;
input.n_b = 0.99;
input.n_m = 0.98;
input.y = 1.4;
input.c_p = 1004;


input.M_0 = 0.9;
input.pi_c = [2:0.1:30]; 
input.pi_f = [2;2.5;3];

real = resolve(@turbofan_real_a_opt,input,'pi_c','pi_f');
ideal = resolve(@turbofan_ideal_a_opt,input,'pi_c','pi_f');

%% tracao especifica
figure(); hold on; grid minor;

%yyaxis left
[hax,ln1, ln2] = plotyy(input.pi_c, real.F_m_0, input.pi_c, real.a_opt); 
set(hax(1),'YLim',[0 250]);
set(hax(2),'YLim',[0 25]);
legenda(input.pi_f, 'real,\pi_f=');
legenda(input.pi_f, 'real,\pi_f=');

[hax,ln1, ln2] = plotyy(input.pi_c, ideal.F_m_0, input.pi_c, ideal.a_opt); 
set(ln1,'LineStyle','--');
set(ln2,'LineStyle','--');
set(hax(1),'YLim',[0 250]);
set(hax(2),'YLim',[0 25]);
ylabel(hax(1),'F/m_0');
ylabel(hax(2),'S');
legenda(input.pi_f, 'ideal,\pi_f=');
legenda(input.pi_f, 'ideal,\pi_f=');


% yyaxis right
%plotyy(input.pi_c,ideal.F_m_0, input.pi_c,ideal.a_opt,'--');

% legenda(input.a,'real, a=');
% legenda(input.a,'ideal, a=');
% xlabel('\pi_c');
% ylabel('F/m_0 [N/(kg/s)]');

%% consumo especifico
figure(); hold on; grid minor;
plot(input.pi_c,real.S);
plot(input.pi_c,ideal.S,'--');
%ylim([12 28]);
legenda(input.pi_f,'real, \pi_f=');
legenda(input.pi_f,'ideal, \pi_f=');
xlabel('\pi_c');
ylabel('S [(mg/s)/N]');
ylim([12 28]);


%% tração específica e a_opt
input.pi_c = 24;
input.M_0 = [0:0.1:3];
real = resolve(@turbofan_real_a_opt,input,'M_0','pi_f','trunca');
ideal = resolve(@turbofan_ideal_a_opt,input,'M_0','pi_f','trunca');
figure(); hold on; grid minor;
%yyaxis left
[hax,ln1, ln2] = plotyy(input.M_0, real.F_m_0, input.M_0, real.a_opt); 
set(hax(1),'YLim',[0 400]);
set(hax(2),'YLim',[0 40]);
legenda(input.pi_f, 'real,\pi_f=');
legenda(input.pi_f, 'real,\pi_f=');

[hax,ln1, ln2] = plotyy(input.M_0, ideal.F_m_0, input.M_0, ideal.a_opt); 
set(ln1,'LineStyle','--');
set(ln2,'LineStyle','--');
set(hax(1),'YLim',[0 400]);
set(hax(2),'YLim',[0 40]);
ylabel(hax(1),'F/m_0');
ylabel(hax(2),'S');
legenda(input.pi_f, 'ideal,\pi_f=');
legenda(input.pi_f, 'ideal,\pi_f=');

%% consumo especifico em funcao de M_0

figure(); hold on; grid minor;
plot(input.M_0,real.S);
plot(input.M_0,ideal.S,'--');
%ylim([12 28]);
legenda(input.pi_f,'real, \pi_f=');
legenda(input.pi_f,'ideal, \pi_f=');
xlabel('\pi_c');
ylabel('S [(mg/s)/N]');
ylim([5 40]);