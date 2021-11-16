%programa stodola1.m
% método de Stodola para obtenção da primeira frequencia 
% e do primeiro modo de vibração
clc
clear all
close all
n=3;
m=[1 0 0;0 1.5 0;0 0 2];
k=[600 -600 0;-600 1800 -1200;0 -1200 3000];
v=ones(n,1);
normava=norm(v,2);
vn=zeros(n,1);
d=inv(k)*m;
kk=0;
while (1)
    vn=d*v;
    maior=abs(vn(1));
    for i=2:n
        aux=abs(vn(i));
        if aux>maior
            maior=aux;
        end
    end
    for j=1:n
        v(j)=vn(j)/maior;
    end
    normav=norm(v,2);
    test=abs(normava-normav);
    if test<0.0001, break, end
    normava=normav;
    kk=kk+1;
end
kk
lambda=1/maior
omega=sqrt(lambda)
v
