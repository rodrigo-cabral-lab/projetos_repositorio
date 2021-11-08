%programa stodola1_asa.m
% método de Stodola para obtenção da primeira frequencia 
% e do primeiro modo de vibração (modo fundamental)
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
normava=norm(v,2);
vn=zeros(n,1);
d=inv(K)*M
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
v/v(1)
