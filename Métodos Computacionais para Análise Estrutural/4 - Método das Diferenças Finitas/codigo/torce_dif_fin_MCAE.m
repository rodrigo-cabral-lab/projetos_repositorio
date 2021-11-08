% tor��o de se��o retangular
% diferen�as finitas
% Prof. Reyolando Brasil abril 2018
%
clc
clear
%
%gera��o da malha
%
nd=64;%n�mero de divis�es da malha
np1=nd+1;%n�mero de n�s da malha em cada dire��o
neq=(nd-1)^2;%n�mero de equa��es a resolver
a=4;b=4;%dimens�es do ret�ngulo
hx=a/nd;hy=b/nd;
%
%inicializa��o
%
a=zeros(np1*np1,np1*np1);%n�mero de n�s da malha = np1*np1
b=zeros(np1*np1,1);
kk=zeros(neq,1);
aa=zeros(neq,neq);
bb=zeros(neq,1);
%
%gera��o das equa��es de diferen�as finitas para os n�s internos
%
m=0;
for i=2:nd % n�mero da linha
    k=(i-1)*np1+1;ii=1;
    for j=2:nd %n�mero da coluna
        k=k+1;m=m+1;kk(m,1)=k;
        a(k,k-1)=-1/hx^2;
        a(k,k+1)=-1/hx^2;
        a(k,k)=2/(hx^2)+2/(hy^2);
        a(k+np1,k)=-1/hy^2;
        a(k-np1,k)=-1/hy^2;
        b(k,1)=2;
    end
end
%
for i=1:neq
    for j=1:neq
        aa(i,j)=a(kk(i),kk(j));
    end
    bb(i)=b(kk(i));
end
aa
bb
phi=aa\bb

torque=0

for i=1:neq
    torque=torque+2*(phi(i)*(hx*hy));
end

%torque total
torque







