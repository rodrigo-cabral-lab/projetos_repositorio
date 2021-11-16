% Programa stodola2.m
% método de Stodola para obtenção da ultima frequencia 
% e do ultimo modo de vibração
clc
clear all
close all
n=3;
m=[1 0 0;0 1.5 0;0 0 2];
k=[600 -600 0;-600 1800 -1200;0 -1200 3000];
v=[-1;1;-1];
vn=zeros(n,1);
normava=norm(v,2);
e=inv(m)*k;
kk=0;
while (1)
    vn=e*v;
    maior=abs(vn(1,1));
    for i=2:n
        aux=abs(vn(i,1));
        if aux>maior
            maior=aux;
        end
    end
    for j=1:n
        v(j,1)=vn(j,1)/maior;
    end
    normav=norm(v,2);
    test=abs(normava-normav);
    if test<0.0001, break, end
    normava=normav;
    kk=kk+1;
end
kk
lambda=maior
omega=sqrt(lambda)
v
