%arquivo diferencas_finitas_MCAE_asa.m
%março 2018 - Prof. Reyolando Brasil
%integração no tempo por diferenças finitas
%vários graus de liberdade
%Exemplo: asa
clear all
close all
clc
%
nn=4;
L=6;
%E=10;
%I=10;
EI=10800;
mbarra=0.42;
w1=(pi^2)*sqrt(EI/(mbarra*L^4))
w4=16*(pi^2)*sqrt(EI/(mbarra*L^4))
%h=w4/10;



K=(EI)*[12/(L^3) 6/(L^2) -12/(L^3) 6/(L^2);
    6/(L^2) 4/L -6*(L^2) 2/L;
   -12/(L^3) -6*(L^2) 12/(L^3) -6/(L^2);
   6/(L^2) 2/L -6/(L^2) 4/L];


    M=((mbarra*L)/420)*[156 22*L 54 -13*L;
                         22*L 4*L^2 13*L -3*L^2;
                         54 4*L^2 156 -22*L;
                         22*L -3*L^2 -22*L 4*L^2];
%
tf=7; %tempo final em segundos
h=0.0035;% passo de integração em segundos // para calcular pegar omega4 (maior período) e dividir por 10
%omega4=16*pi²sqrt(E*I/(mbarra*L^4))
%omega1=pi²sqrt(E*I/(mbarra*L^4))
np=tf/h; % número de passos de integração
p=zeros(nn,np);%vetor de carregamento
u=zeros(nn,np);%vetor de deslocamentos
up=zeros(nn,np);%vetor de velocidades
t=zeros(np);
dp=zeros(np,1);
%
% matriz de amortecimento
alfa=1;beta=0.001;% %coef de amortecimento de Rayleigh
C=alfa*M+beta*K;%matriz de amortecimento de Rayleigh
%
%constantes do método
%
KC=M/h/h+C/2/h;A1=2*M/h/h-K;A2=C/2/h-M/h/h;
%
% condições inciais
%u(:,1)= ;up(:,1); % consideradas nulas no exemplo
t(1)=0;
p(:,1)=cargasa(t(1));%chamar função carregamento
%
upp=M\(p(:,1)-C*up(:,1)-K*u(:,1));%aceleração incial
u(:,2)=upp*h*h/2+h*up(:,1)+u(:,1);%deslocamento no início do segundo passo
%
%loop principal
%
for n=2:np
    t(n)=t(n-1)+h;
    p(:,n)=cargasa(t(n)); %chamar função carregamento
    pc=p(:,n)+A1*u(:,n)+A2*u(:,n-1);
    u(:,n+1)=KC\pc;
    up(:,n)=(u(:,n+1)-u(:,n-1))/(2*h);
end
%
%plotagem de deslocamentos
%
% direção 1
%
for i=1:np
    dp(i,1)=u(1,i);
end
plot(t,dp)
xlabel('t (s)')
ylabel('Deslocamentos diração 1 (m)')
grid



    