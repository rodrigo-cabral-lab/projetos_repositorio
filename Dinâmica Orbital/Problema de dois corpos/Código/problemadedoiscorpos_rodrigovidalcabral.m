%código para resolução do problema de dois corpos 
%Rodrigo Vidal Cabral
clear all; 
close all; 
clc;

tic %iniciar cronômetro
%% dados
t0 = [0; 4.2751e+04]; %periodo de 1 orbita 
x0=[10016.34 -17012.52 7899.28 2.50 -1.05 3.88];
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[t, x] = ode45(@variaveisdeestado_rodrigovidalcabral, 50*t0 , x0, options);

%Plot da órbita

plot3(x(: , 1),x(: , 2),x(: , 3));

grid on
hold on

%Plot da Terra

plotterra_rodrigovidalcabral

toc     %término do cronômetro
