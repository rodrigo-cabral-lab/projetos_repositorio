%Dados iniciais e cálculo do período orbital
%Rodrigo Vidal Cabral
clc;
clear all;
close all;

%Dados do problema 
u = 398600; % constante gravitacional x massa da Terra 
R=[10016.34 -17012.52 7899.28 ]; % vetor Posiçao
v =[2.50 -1.05 3.88]; % vetor velocidade
R=norm(R);
v=norm(v);
E = v^2/2 - u/R; % energia total especifica
a= -u/(2*E); % semi eixo maior da orbita
T= sqrt(4*pi^2*a^3/u); % periodo orbital em sec

disp('Período orbital')
disp(T)