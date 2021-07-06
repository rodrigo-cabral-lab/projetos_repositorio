%----------Rodrigo Vidal Cabral---------------
%Pouso lunar 

clear all
close all
clc
format long

%dados do problema 
M = 1; %massa do m�dulo (kg)
g_L = 1.8; %gravidade da Lua (m/s�)
E = 3.6; %empuxo do jato de g�s (N)
vf = 0; %velocidade final (m/s)
theta = [-30 0 30]; %
ci = [0 18 0 -7]; %condi��es iniciais [posi��o_x posi��o_y velocidade_x velocidade_y]




%-----------------------------CURVAS DE POUSO------------------------------
P = M * g_L; %for�a peso (N)

for i = [1:length(theta)];
    y_pontoponto(i) = (E * cosd(theta(i)) - P)/M; %acelera��o vertical (cada coluna um theta) (m/s�)
end

for j = [1:length(y_pontoponto)];
y_ponto = [-10:0.01:0]; % velocidade inicial (m/s)
y(:,j) = ((y_ponto.^2)/(2*y_pontoponto (j))); %posi��o (cada coluna um theta) (m)
end
   
% figure (1)
% plot(y_ponto, y(:,1), 'y');
% hold on;
% plot(y_ponto, y(:,2), 'b');
% hold on;
% plot(y_ponto, y(:,3), 'r')
% hold on;
% plot (ci(4), ci(2), '*');
% legend('\theta = -30�','\theta = 0�','\theta = 30�','Posicao Inicial');
% ylabel('Posi��o Inicial [m]');
% xlabel('Velocidade Inicial [m/s]');
% ylim([0 50])

%--------------------------CURVAS DE CADA �NGULO---------------------------
%inicial
% queda livre
y_qli = ((y_ponto.^2 - ci(4)^2)./(2*(-g_L))) + ci(2); %posi��o para queda livre (m)

% - 30�
y_m30i = ((y_ponto.^2 - ci(4)^2)./(2*y_pontoponto (1))) + ci(2); %posi��o para -30� (m)

% 0�
y_0i = ((y_ponto.^2 - ci(4)^2)./(2*y_pontoponto (2))) + ci(2); %posi��o para 0� (m)

% 30�
y_30i = ((y_ponto.^2 - ci(4)^2)./(2*y_pontoponto (3))) + ci(2); %posi��o para 30� (m)

%final
% queda livre
y_qlf = ((y_ponto.^2)./(2*(-g_L))); %posi��o para queda livre (m)

% - 30�
y_m30f = ((y_ponto.^2)./(2*y_pontoponto (1))); %posi��o para -30� (m)

% 0�
y_0f = ((y_ponto.^2)./(2*y_pontoponto (2))); %posi��o para 0� (m)

% 30�
y_30f = ((y_ponto.^2)./(2*y_pontoponto (3))); %posi��o para 30� (m)


%------------------------------ESTRAT�GIAS 1D------------------------------
erro = 0.05;

%1) 0� --> 30�
%interse��o
inter = find(abs(y_0i - y_30f) < erro, 1); 
y1_int = y_0i(inter);
y1_pontoint = y_ponto(inter);


%2) 30� --> 0�
%interse��o
inter = find(abs(y_30i - y_0f) < erro, 1); 
y2_int = y_30i(inter);
y2_pontoint = y_ponto(inter);


%3) queda livre --> 0�
%interse��o
inter = find(abs(y_qli - y_0f) < erro, 1); 
y3_int = y_qli(inter);
y3_pontoint = y_ponto(inter);


%4) queda livre --> 30�
%interse��o
inter = find(abs(y_qli - y_30f) < erro, 1);
y4_int = y_qli(inter);
y4_pontoint = y_ponto(inter);

%-----------------------Tempo das estrat�gias------------------------------
%Estrat�gia 1 - queda livre para 0� pouso suave
t3_i = (y3_pontoint - ci(4)) / (-g_L); %tempo da primeira parte da descida (s)
t3_f = (0 - y3_pontoint) / y_pontoponto(2); %tempo da segunda parte da descida (s)
t3 = t3_i + t3_f; %tempo de queda total (s)

%Estrat�gia 2 - 0�livre para 30�pouso suave
t1_i = (y1_pontoint - ci(4)) / y_pontoponto(2); %tempo da primeira parte da descida (s)
t1_f = (0 - y1_pontoint) / y_pontoponto(3); %tempo da segunda parte da descida (s)
t1 = t1_i + t1_f; %tempo de queda total (s)

%Estrat�gia 3 - 30�livre para 0� pouso suave
t2_i = (y2_pontoint - ci(4)) / y_pontoponto(3); %tempo da primeira parte da descida (s)
t2_f = (0 - y2_pontoint) / y_pontoponto(2); %tempo da segunda parte da descida (s)
t2 = t2_i + t2_f; %tempo de queda total (s)


%-----------------------------------PLOTS----------------------------------
%1) 0� --> 30�
figure (2)
plot(y_ponto, y_0i, 'r');
hold on;
plot(y_ponto, y_30i, 'm');
hold on;
plot(y_ponto, y_m30i, '');
hold on;
plot (ci(4), ci(2), '*');
hold on;
plot(y1_pontoint,y1_int,'b*');
plot(y_ponto, y_qli, 'y');
hold on;
plot(y_ponto, y_m30f, 'k');
hold on;
plot(y_ponto, y_0f, 'c');
hold on;
plot(y_ponto, y_30f, 'g')
hold on;
plot(y3_pontoint,y3_int , 'm*');
hold on;
plot(y2_pontoint,y2_int , 'k*');
hold on;
grid on
grid minor
legend('prop 0� - livre','prop 30� - livre','prop -30� - livre','Posicao Inicial','Pto Int. 2','queda livre','prop -30� - suave','prop 0� - suave','prop 30� - suave','Pto Int. 1','Pto Int. 3');
ylabel('Posi��o em Y [m]');
xlabel('Velocidade em Y [m/s]');

% %-------------------------Parte 2 (Vertical + Horizontal)------------
% %Aplicando integrador para as diferentes estrat�gias
% 
% %Estrat�gia 1 - queda livre para 0� pouso suave
% %in�cio
% param = [M g_L E]; %par�metros de referencia pro integrador
% t3_i=5;
% t3i = [0 t3_i];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx_ql, t3i, ci, options, param);
% x3_i = R(:,1); %dx/dt
% y3_i = R(:,2); %dy/dt
% x3_iponto = R(:,3); %dvx/dt
% y3_iponto = R(:,4); %dvy/dt
% 
% %final
% l = size(x3_i,1);
% c3f = [x3_i(l) y3_i(l) x3_iponto(l) y3_iponto(l)]; 
% theta3f = theta(2);
% param = [M g_L E theta3f]; %par�metros de referencia pro integrador
% t3f = [t3_i t3];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx, t3f, c3f, options, param);
% x3_f = R(:,1); %dx/dt
% y3_f = R(:,2); %dy/dt
% x3_fponto = R(:,3); %dvx/dt
% y3_fponto = R(:,4); %dvy/dt
% 
% %Estrat�gia 2 - 0�livre para 30�pouso suave
% %in�cio
% theta1i = theta(2);
% param = [M g_L E theta1i]; %par�metros de referencia pro integrador
% t1i = [0 t1_i];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx, t1i, ci, options, param);
% x1_i = R(:,1); %dx/dt
% y1_i = R(:,2); %dy/dt
% x1_iponto = R(:,3); %dvx/dt
% y1_iponto = R(:,4); %dvy/dt
% 
% %final
% l = size(x1_i,1);
% c1f = [x1_i(l) y1_i(l) x1_iponto(l) y1_iponto(l)]; 
% theta1f = theta(3);
% param = [M g_L E theta1f]; %par�metros de referencia pro integrador
% t1f = [t1_i t1];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx, t1f, c1f, options, param);
% x1_f = R(:,1); %dx/dt
% y1_f = R(:,2); %dy/dt
% x1_fponto = R(:,3); %dvx/dt
% y1_fponto = R(:,4); %dvy/dt
% 
% 
% %Estrat�gia 3 - 30�livre para 0� pouso suave
% %in�cio
% theta2i = theta(3);
% param = [M g_L E theta2i]; %par�metros de referencia pro integrador
% t2i = [0 t2_i];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx, t2i, ci, options, param);
% x2_i = R(:,1); %dx/dt
% y2_i = R(:,2); %dy/dt
% x2_iponto = R(:,3); %dvx/dt
% y2_iponto = R(:,4); %dvy/dt
% 
% %final
% l = size(x2_i,1);
% c2f = [x2_i(l) y2_i(l) x2_iponto(l) y2_iponto(l)]; 
% theta2f = theta(2);
% param = [M g_L E theta2f]; %par�metros de referencia pro integrador
% t2f = [t2_i t2];
% options = odeset('RelTol',1e-8);
% [t,R] = ode45 (@dx, t2f, c2f, options, param);
% x2_f = R(:,1); %dx/dt
% y2_f = R(:,2); %dy/dt
% x2_fponto = R(:,3); %dvx/dt
% y2_fponto = R(:,4); %dvy/dt
% 
% %estrat�gia 1 
% figure (3)
% plot (y3_iponto,y3_i,y3_fponto,y3_f);
% legend('Trajet�ria Inicial em Queda Livre','Trajet�ria Final 30�');
% ylabel('velocidade em y [m]');
% xlabel('Posi��o em y [m]');

%-----------------------------Aplicando o integrador-----------------------

%Estrat�gia 1 - queda livre > prop 0�
%1�parte
tspan = [0 0.302]; %tempo inicial e final de integra��o em segundos
x0 = [0 18 0 -7]; %condi��es iniciais x1 x2 x3 x4
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@quedalivre,tspan, x0, options); 

figure (3)
subplot (2,1,1);
plot (x(:,4),x(:,2));%plot em y
hold on;
grid on;
title ('Estrat�gia 1')
xlabel('Velocidade em Y');
ylabel('Posi��o em Y');
subplot (2,1,2)
plot (x(:,1),x(:,3));%plot em x
hold on;
grid on;
ylabel('Velocidade em X [m/s]');
xlabel('Posi��o em X [m]');
%2� parte 
tspan = [0.302 4.492]; %tempo inicial e final de integra��o em segundos
x0 = [0 15.80391639 0 -7.54360]; %condi��es iniciais x y vx vy
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@propzero,tspan, x0, options);

figure (3)
subplot (2,1,1);
plot (x(:,4),x(:,2),'k');%plot em y
hold on;
grid on;
legend('Parte 1 - Queda livre','Parte 2 - Prop 0�');
subplot (2,1,2);
plot (x(:,1),x(:,3),'r');%plot em x
hold on;
grid on;
legend('Parte 1 - Queda livre','Parte 2 - Prop 0�');

%Estrat�gia 2 - prop 0� > prop 30�
%1�parte
tspan = [0 0.2395]; %tempo inicial e final de integra��o em segundos
x0 = [0 18 0 -7]; %condi��es iniciais x y vx vy
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@propzero,tspan, x0, options); 

figure (4)
subplot (2,1,1);
plot (x(:,4),x(:,2));%plot em y
hold on;
grid on;
title ('Estrat�gia 2')
xlabel('Velocidade em Y [m/s]');
ylabel('Posi��o em Y [m]');
subplot (2,1,2);
plot (x(:,1),x(:,3));%plot em x
hold on;
grid on;
title ('Estrat�gia 2')
ylabel('Velocidade em X [m/s]');
xlabel('Posi��o em X [m]');
% %2� parte 
tspan = [0.2395 5.225]; %tempo inicial e final de integra��o em segundos
x0 = [0 16.3751 0 -6.5689]; %condi��es iniciais x1 x2 x3 x4
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@prop30,tspan, x0, options);

figure (4)
subplot (2,1,1);
plot (x(:,4),x(:,2),'k');%plot em y
hold on;
grid on;
legend('Parte 1 - Prop 0�','Parte 2 - Prop 30�');
subplot (2,1,2);
plot (x(:,1),x(:,3),'r');%plot em x
hold on;
grid on;
legend('Parte 1 - Prop 0�','Parte 2 - Prop 30�');

%Estrat�gia 3 - prop 30� > prop 0�
%1�parte
tspan = [0 3.475]; %tempo inicial e final de integra��o em segundos
x0 = [0 18 0 -7]; %condi��es iniciais x y vx vy
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@prop30,tspan, x0, options); 

figure (5)
subplot (2,1,1);
plot (x(:,4),x(:,2));%plot em y
hold on;
grid on;
title ('Estrat�gia 3')
xlabel('Velocidade em Y [m/s]');
ylabel('Posi��o em Y [m]');
subplot (2,1,2);
plot (x(:,1),x(:,3));%plot em x
hold on;
grid on;
title ('Estrat�gia 3')
ylabel('Velocidade em X [m/s]');
xlabel('Posi��o em X [m]');
% %2� parte 
tspan = [3.475 4.817]; %tempo inicial e final de integra��o em segundos
x0 = [10.8681 1.631 6.255 -2.4210]; %condi��es iniciais x1 x2 x3 x4
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@propzero,tspan, x0, options);

figure (5)
subplot (2,1,1);
plot (x(:,4),x(:,2),'k');%plot em y
hold on;
grid on;
legend('Parte 1 - Prop 30�','Parte 2 - Prop 0�');
subplot (2,1,2);
plot (x(:,1),x(:,3),'r');%plot em x
hold on;
grid on;
legend('Parte 1 - Prop 30�','Parte 2 - Prop 0�');

%------------------Estrat�gia escolhida p/ parte 2-------------------
%Foi escolhida a estrat�gia prop 30� > prop 0�
%Pois resulta em um menor tempo de propuls�o para o objetivo final 
%(x=0 e vx=0)

%Estrat�gia �tima - prop 30� > prop -30� > prop 0�
%1�parte
tspan = [0 1.7375]; %tempo inicial e final de integra��o em segundos
x0 = [0 18 0 -7]; %condi��es iniciais x y vx vy
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@prop30,tspan, x0, options); 

figure (6)
subplot (2,1,1);
plot (x(:,4),x(:,2));%plot em y
hold on;
grid on;
title ('Estrat�gia �tima')
xlabel('Velocidade em Y [m/s]');
ylabel('Posi��o em Y [m]');
subplot (2,1,2)
plot (x(:,1),x(:,3));%plot em x
hold on;
grid on;
% title ('Estrat�gia �tima')
ylabel('Velocidade em X [m/s]');
xlabel('Posi��o em X [m]');
%2� parte
tspan = [1.7375 3.475]; %tempo inicial e final de integra��o em segundos
x0 = [2.71701 7.826493 3.12750 -4.710511]; %condi��es iniciais x1 x2 x3 x4
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@propmenos30,tspan, x0, options);

figure (6)
subplot (2,1,1);
plot (x(:,4),x(:,2),'k');%plot em y
hold on;
grid on;
subplot (2,1,2);
plot (x(:,1),x(:,3),'k');%plot em x
hold on;
grid on;

% %3� parte 
tspan = [3.475 4.817]; %tempo inicial e final de integra��o em segundos
x0 = [5.4340  1.630973 0 -2.421022]; %condi��es iniciais x1 x2 x3 x4
options = odeset('RelTol',1e-8); %Corre��o do erro relativo
[t,x] = ode45(@propzero,tspan, x0, options);

figure (6)
subplot (2,1,1)
plot (x(:,4),x(:,2),'g');%plot em y
hold on;
grid on;
legend('Parte 1 - Prop 30�','Parte 2 - Prop -30�','Parte 3 - Prop 0�');
subplot (2,1,2);
plot (x(:,1),x(:,3),'g');%plot em x
hold on;
grid on;
legend('Parte 1 - Prop 30�','Parte 2 - Prop -30�','Parte 3 - Prop 0�');


