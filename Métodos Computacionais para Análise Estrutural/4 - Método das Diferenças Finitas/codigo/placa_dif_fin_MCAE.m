% placas retangular
% diferen�as finitas
% Prof. Reyolando Brasil abril 2018
%
clc
clear
%
%propriedade f�sicas
%
a=3;b=2;%dimens�es do ret�ngulo
EM=200e6;t=0.02;nu=0.3;p=2;
D=EM*t^3/(12*(1-nu^2));pdD=p/D;
%
%gera��o da malha
%
nd=4;%n�mero de divis�es da malha
np1=nd+1;
np3=nd+3;%m�mero de n�s da malha expandida em cada dire��o
neq=(nd-1)^2;%n�mero de equa��es a resolver
hx=a/nd;hy=b/nd;hx4=hx*hx*hx*hx;hy4=hy*hy*hy*hy;hx2hy2=hx*hx*hy*hy;
%
%inicializa��o
%
A=zeros(np3*np3,np3*np3);%n�mero de n�s da malha = np1*np1
B=zeros(np3*np3,1);
kk=zeros(neq,1);
aa=zeros(neq,neq);
bb=zeros(neq,1);
%
%gera��o das equa��es de diferen�as finitas para os n�s internos
%
m=0;
for i=3:np1 % n�mero da linha
    k=(i-1)*np3+2;
    for j=3:np1 %n�mero da coluna
        k=k+1;m=m+1;kk(m,1)=k;%n�mero do n�
        A(k,k-2)=1/hx4;
        A(k,k-1)=-4/hx4-4/hx2hy2;
        A(k,k+1)=-4/hx4-4/hx2hy2;
        A(k,k+2)=1/hx4;
        A(k,k)=6/hx4+6/hy4+8/hx2hy2;
        A(k+2*np3,k)=1/hy4;
        A(k+np3,k)=-4/hy4-4/hx2hy2;
        A(k-np3,k)=-4/hy4-4/hx2hy2;
        A(k-2*np3,k)=1/hy4;
        A(k+np3,k+1)=2/hx2hy2;
        A(k+np3,k-1)=2/hx2hy2;
        A(k-np3,k+1)=2/hx2hy2;
        A(k-np3,k-1)=2/hx2hy2;
        B(k,1)=pdD;
    end
end
%
%condi��es de contorno: isup, iinf, iesq, idir
%
%c�digo: -1=apoiado; 1=engastado
%
isup=-1;iinf=-1;iesq=1;idir=1;
%
%bordo superior
%
k=2*np3+2;
for j=3:np1
    k=k+1;
    A(k,k)=A(k,k)+isup*A(k-2*np3,k);
end
%
%bordo inferior
%
k=nd*np3+2;
for j=3:np1;
    k=k+1;
    A(k,k)=A(k,k)+iinf*A(k+2*np3,k);
end
%
%bordo esquerdo
%
k=2*np3+3;
for i=3:np1
    A(k,k)=A(k,k)+iesq*A(k,k-2);
    k=k+np3;
end
%bordo direito
%
k=3*np3-2;
for i=3:np1
    A(k,k)=A(k,k)+idir*A(k,k+2);
    k=k+np3;
end
%
%montagem sistema de equa��es
%
for i=1:neq
    for j=1:neq
        aa(i,j)=A(kk(i),kk(j));
    end
    bb(i)=B(kk(i));
end
%
%solu��o do sitema
%
w=aa\bb
%wmax=1000*max(w)%deslocamento m�ximo em mm