%arquivo diferencas_finitas_MCAE_2.m
%julho 2016 - Prof. Reyolando Brasil
%integração no tempo por diferenças finitas
%vários graus de liberdade
%Exemplo: viga com massas em hastes sobre os apoios
clear all
close all
clc
%
nn = 2; % número de graus de liberdade
%
%dimensões das matrizes
%
% entrada das matrizes
M=[1*0.5^2 0;0 1*0.5^2]; %matriz de massa tm²
K=[40 20;20 40]; %matriz de rigidez KNm/rad
%
tf=25; %tempo final em segundos
h=0.025;% passo de integração em segundos
np=tf/h; % número de passos de integração
p=zeros(nn,np);%vetor de carregamento
u=zeros(nn,np);%vetor de deslocamentos
up=zeros(nn,np);%vetor de velocidades
t=zeros(np);
dp=zeros(np,1);
%
% matriz de amortecimento
alfa=1;beta= 0.0;% %coef de amortecimento de Rayleigh
C=alfa*M+beta*K;%matriz de amortecimento de Rayleigh
%
%constantes do método
%
KC=M/h/h+C/2/h;A1=K-2*M/h/h;A2=M/h/h-C/2/h;
%
% condições inciais
%u(:,1)= ;up(:,1); % consideradas nulas no exemplo
t(1)=0;
p(:,1)=[sin(t(1));sin(t(1))];%função carregamento
%
upp=M\(p(:,1)-C*up(:,1)-K*u(:,1));%aceleração incial
u(:,2)=upp*h*h/2+h*up(:,1)+u(:,1);%deslocamento no início do segundo passo
%
%loop principal
%
for n=2:np
    t(n)=t(n-1)+h;
    p(:,n)=[sin(t(n));sin(t(n))]; %chamar função carregamento
    pc=p(:,n)-A1*u(:,n)-A2*u(:,n-1);
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
figure(1)
plot(t,dp)
xlabel('t (s)')
ylabel('Deslocamentos direção 1 (rad)')
grid
%
% direção 2
%
for i=1:np
    dp(i,1)=u(2,i);
end
figure(2)
plot(t,dp)
xlabel('t (s)')
ylabel('Deslocamentos direção 2 (rad)')
grid
%
    


    