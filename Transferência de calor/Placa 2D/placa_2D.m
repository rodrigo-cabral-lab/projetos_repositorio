%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lista 13 - Exemplo 01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problema: Difusão de Calor 2D, Sem Geração de Calor
% Solver: TDMA Linha-a-Linha
% Sweep na direção Horizontal ao longo das linhas verticais
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
tic
%% Dados de Entrada %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=0.3;
M=0.4;
dz=0.01;
k=1000;
q_flux=500e3;
T_norte=100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Malha Computacional na Direção X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L1=7; %número de pontos (5 internos + 2 de fronteira)
L2=L1-1; %penúltimo ponto
L3=L1-2; %antepenúltimo ponto
dx=L/(L1-2); %espaçamento entre os pontos internos
xu(2)=0; %distância da interface, tracejado entre cada ponto (P1=0.1; P2=0.2 ...)
x(1)=xu(2); %distância entre o início e o ponto (P1=0.05; P2=0.15; P3=0.25 ...)
for i=3:L1
xu(i)=xu(i-1)+dx ;   %cálculo da distância da interface dos volumes
end
for i=2:L2
x(i)=0.5*(xu(i+1)+xu(i)); %cálculo da distância dos pontos da malha
end
x(L1)=xu(L1); %assim como x(1)=xu(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Malha Computacional na Direção Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M1=7; %número de pontos (4 internos + 2 de fronteira)
M2=M1-1; %penúltimo ponto
M3=M1-2; %antepenúltimo ponto
dy=M/(M1-2); %espaçamento entre os pontos internos
yu(2)=0; %distância da interface, tracejado entre cada ponto (P1=0.1; P2=0.2 ...)
y(1)=yu(2); %distância entre o início e o ponto (P1=0.05; P2=0.15; P3=0.25 ...)
for j=3:M1
yu(j)=yu(j-1)+dy ;   %cálculo da distância da interface dos volumes
end
for j=2:M2
y(j)=0.5*(yu(j+1)+yu(j)); %cálculo da distância dos pontos da malha
end
y(M1)=yu(M1); %assim como y(1)=yu(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Valores Iniciais %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:L1
for j=1:M1
PHI(i,j)=0;
end
end

% itermax=3000;

% for iter=1:itermax
sair = 0; iter=1
COMP = ones(L2,M2);
while (sair==0)
    iter=iter+1
for ii=2:L2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Discretização na Direção X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=3:M3
% Discretização do ponto (2,2)
SC(2,2)=0;
SCA(2,2)=q_flux*dy*dz;
SP(2,2)=0;
SPA(2,2)=0;
AE(2,2)=(k*dy*dz)/dx;
AW(2,2)=0;
AN(2,2)=(k*dx*dz)/dy;
AS(2,2)=0;
AP(2,2)=AW(2,2)+AE(2,2)+AN(2,2)+AS(2,2)-(SP(2,2)*dx*dy*dz+SPA(2,2));
AD(2,2)=(SC(2,2)*dx*dy*dz)+SCA(2,2)+(AW(2,2)*PHI(1,2))+(AE(2,2)*PHI(3,2));

SC(2,j)=0;
SCA(2,j)=q_flux*dy*dz;
SP(2,j)=0;
SPA(2,j)=0;
AE(2,j)=(k*dy*dz)/dx;
AW(2,j)=0;
AN(2,j)=(k*dx*dz)/dy;
AS(2,j)=(k*dx*dz)/dy;
AP(2,j)=AW(2,j)+AE(2,j)+AN(2,j)+AS(2,j)-(SP(2,j)*dx*dy*dz+SPA(2,j));
AD(2,j)=(SC(2,j)*dx*dy*dz)+SCA(2,j)+(AW(2,j)*PHI(1,j))+(AE(2,j)*PHI(3,j));

% Discretização do ponto (L2,2)
SC(L2,2)=0;
SCA(L2,2)=0;
SP(L2,2)=0;
SPA(L2,2)=0;
AE(L2,2)=0;
AW(L2,2)=(k*dy*dz)/dx;
AN(L2,2)=(k*dx*dz)/dy;
AS(L2,2)=0;
AP(L2,2)=AW(L2,2)+AE(L2,2)+AN(L2,2)+AS(L2,2)-(SP(L2,2)*dx*dy*dz+SPA(L2,2));
AD(L2,2)=(SC(L2,2)*dx*dy*dz)+SCA(L2,2)+AW(L2,2)*PHI(L2-1,2)+AE(L2,2)*PHI(L2+1,2);

% Discretização do ponto L2, variando em j
SC(L2,j)=0;
SCA(L2,j)=0;
SP(L2,j)=0;
SPA(L2,j)=0;
AE(L2,j)=0;
AW(L2,j)=(k*dy*dz)/dx;
AN(L2,j)=(k*dx*dz)/dy;
AS(L2,j)=(k*dx*dz)/dy;
AP(L2,j)=AW(L2,j)+AE(L2,j)+AN(L2,j)+AS(L2,j)-(SP(L2,j)*dx*dy*dz+SPA(L2,j));
AD(L2,j)=(SC(L2,j)*dx*dy*dz)+SCA(L2,j)+AW(L2,j)*PHI(L2-1,j)+AE(L2,j)*PHI(L1,j);

% Discretização dos Pontos Internos
for i=3:L3
SC(i,j)=0;
SCA(i,j)=0;
SP(i,j)=0;
SPA(i,j)=0;
AE(i,j)=(k*dy*dz)/dx;
AW(i,j)=(k*dy*dz)/dx;
AN(i,j)=(k*dx*dz)/dy;
AS(i,j)=(k*dx*dz)/dy;
AP(i,j)=AW(i,j)+AE(i,j)+AN(i,j)+AS(i,j)-(SP(i,j)*dx*dy*dz+SPA(i,j));
AD(i,j)=(SC(i,j)*dx*dy*dz)+SCA(i,j)+AW(i,j)*PHI(i-1,j)+AE(i,j)*PHI(i+1,j);
end
%%% Fim da Discretização na Direção X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Discretização na Direção Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=3:L3
% Discretização do ponto 2, variando i
SC(i,2)=0;
SCA(i,2)=0;
SP(i,2)=0;
SPA(i,2)=0;
AE(i,2)=(k*dy*dz)/dx;
AW(i,2)=(k*dy*dz)/dx;
AN(i,2)=(k*dx*dz)/dy;
AS(i,2)=0;
AP(i,2)=AW(i,2)+AE(i,2)+AN(i,2)+AS(i,2)-(SP(i,2)*dx*dy*dz+SPA(i,2));
AD(i,2)=(SC(i,2)*dx*dy*dz)+SCA(i,2)+(AW(i,2)*PHI(i-1,2))+(AE(i,2)*PHI(i+1,2));

% Discretização do ponto (2,M2)
SC(2,M2)=0;
SCA(2,M2)=(q_flux*dy*dz)+(2*k*dx*dz*T_norte)/dy;
SP(2,M2)=0;
SPA(2,M2)=-(2*k*dx*dz)/dy;
AE(2,M2)=(k*dy*dz)/dx;
AW(2,M2)=0;
AN(2,M2)=0;
AS(2,M2)=(k*dx*dz)/dy;
AP(2,M2)=AW(2,M2)+AE(2,M2)+AN(2,M2)+AS(2,M2)-(SP(2,M2)*dx*dy*dz+SPA(2,M2));
AD(2,M2)=(SC(2,M2)*dx*dy*dz)+SCA(2,M2)+AW(2,M2)*PHI(1,M2)+AE(2,M2)*PHI(3,M2);

% Discretização do ponto M2, variando i
SC(i,M2)=0;
SCA(i,M2)=(2*k*dx*dz*T_norte)/dy;
SP(i,M2)=0;
SPA(i,M2)=-(2*k*dx*dz)/dy;
AE(i,M2)=(k*dy*dz)/dx;
AW(i,M2)=(k*dy*dz)/dx;
AN(i,M2)=0;
AS(i,M2)=(k*dx*dz)/dy;
AP(i,M2)=AW(i,M2)+AE(i,M2)+AN(i,M2)+AS(i,M2)-(SP(i,M2)*dx*dy*dz+SPA(i,M2));
AD(i,M2)=(SC(i,M2)*dx*dy*dz)+SCA(i,M2)+AW(i,M2)*PHI(i-1,M2)+AE(i,M2)*PHI(i+1,M2);

% Discretização do ponto (L2,M2)
SC(L2,M2)=0;
SCA(L2,M2)=(2*k*dx*dz*T_norte)/dy;
SP(L2,M2)=0;
SPA(L2,M2)=-(2*k*dx*dz)/dy;
AE(L2,M2)=0;
AW(L2,M2)=(k*dy*dz)/dx;
AN(L2,M2)=0;
AS(L2,M2)=(k*dx*dz)/dy;
AP(L2,M2)=AW(L2,M2)+AE(L2,M2)+AN(L2,M2)+AS(L2,M2)-(SP(L2,M2)*dx*dy*dz+SPA(L2,M2));
AD(L2,M2)=(SC(L2,M2)*dx*dy*dz)+SCA(L2,M2)+AW(L2,M2)*PHI(L2-1,M2)+AE(L2,M2)*PHI(L2+1,M2);
end
end
%%% Fim da Discretização na Direção Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% TDMA na Direção X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CALCULO DOS PARES
P(ii,2)=AN(ii,2)/AP(ii,2);
Q(ii,2)=AD(ii,2)/AP(ii,2);
for j=3:M2
DEN1=AP(ii,j)-AS(ii,j)*P(ii,j-1);
P(ii,j)=AN(ii,j)/DEN1;
Q(ii,j)=(AD(ii,j)+AS(ii,j)*Q(ii,j-1))/DEN1;
end
%%%% TEMPERATURA DOS NOS INTERNOS
PHI(ii,M2)=Q(ii,M2);
for H=2:M3
j=M1-H;
PHI(ii,j)=P(ii,j)*PHI(ii,j+1)+Q(ii,j);
end
for j=2:M2
PHIX(iter,ii,j)=PHI(ii,j);
end
FF=(1:1:iter);
end

    for iii=1:L1-1;
        for jjj=1:M1-1;
            if(abs(PHIX(iter,iii,jjj)-PHIX(iter-1,iii,jjj))<1e-4)
                diff(iii,jjj)=1;
            else
                diff(iii,jjj)=0;
            end
        end
    end
    
    if (isequal(COMP,diff))
       sair = 1;
    end
end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Condições de Contorno %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Condições de Contorno em X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:M1
PHI(L1,j)=PHI(L2,j);
end
% Fronteira x = 0, fluxo conhecido
for j=1:M1
PHI(1,j)=PHI(2,j)+((q_flux*dx)/(2*k));
end
% Condições de Contorno em Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fronteira y = 0, Adiabática
for i=1:L1
PHI(i,1)=PHI(i,2);
end
% Fronteira y = M, Temperatura Conhecida
for i=1:L1
PHI(i,M1)=T_norte;
end
PHIM=PHI';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc
%%% Cálculo da Temperatura Média %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TSOMA=0;
for i=1:L1
for j=1:M1
TSOMA=TSOMA+PHI(i,j);
end
end
TSOMA;
Tm=((dx*dy)/(L*M))*TSOMA;
NVols=(L1-2)*(M1-2);
% TimeExec=toc

%%% Gráficos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
[X,Y] = meshgrid(x,y);
contour(X,Y,PHI','ShowText','on')
xlabel('x, [m]')
ylabel('y, [m]')
saveas(gcf,'contour.png')

figure
plot(PHIX(:,3,3),'ko')
xlabel('iterações')
ylabel('Temperatura, [°C]')
legend('Sol. Numérica - PHI(3,3)','Location','SouthEast');
set(legend,'FontSize',10)
grid on
saveas(gcf,'PHI(3,3).png')

figure
[X,Y] = meshgrid(x,y);
% surf(X,Y,PHIM,'EdgeColor','None')
surf(X,Y,PHIM)
% shading interp 
colorbar
ylabel(colorbar,'Temperatura, [°C]')
xlabel('x , [m]')
ylabel('y , [m]')
view(2)
axis ([0 L,0 M])
saveas(gcf,'Surf2D.png')