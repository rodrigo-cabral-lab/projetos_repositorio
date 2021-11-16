% torção de seção retangular
% diferenças finitas
%
clc
clear
%
%geração da malha
%
nd=64;%número de divisões da malha
np1=nd+1;%número de nós da malha em cada direção
neq=(nd-1)^2;%número de equações a resolver
a=4;b=4;%dimensões do retângulo
hx=a/nd;hy=b/nd;
%
%inicialização
%
a=zeros(np1*np1,np1*np1);%número de nós da malha = np1*np1
b=zeros(np1*np1,1);
kk=zeros(neq,1);
aa=zeros(neq,neq);
bb=zeros(neq,1);
%
%geração das equações de diferenças finitas para os nós internos
%
m=0;
for i=2:nd % número da linha
    k=(i-1)*np1+1;ii=1;
    for j=2:nd %número da coluna
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







