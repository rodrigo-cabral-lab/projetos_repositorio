% Programa stodola2_asa.m
% método de Stodola para obtenção da ultima frequencia 
% e do ultimo modo de vibração
% Prof. Reyolando Brasil abril 2018
clc
clear all
close all
n=4;
M=[0.936   0.792   0.324  -0.468;
   0.792   0.864   0.468  -0.648;
   0.324   0.468   4.5   0.;
  -0.468  -0.648  0.   5];
K=[600.    1800.  -600.    1800.;
   1800.   7200.  -1800.   3600.;
  -600.   -1800.   1200.   0.;
   1800.   3600.  0.   14400.];
%
v=ones(n,1);
vn=zeros(n,1);
normava=norm(v,2);
e=inv(M)*K
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
v/v(1)
