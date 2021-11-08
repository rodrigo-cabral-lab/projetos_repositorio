% solu��o de vigas continuas
% equa��o dos 3 momentos
% arquivo tres_mom.m 22/01/2013
% dados do problema
% extremidades engastadas adicionar v�o fict�cio de grande rigidez
nv=4; %n�mero de vigas 
nn=nv+1; %n�mero de n�s 
E=70*10^9; %m�dulo de elasticidade 
L=[0.01; 3; 4; 5]; %n�o entra o comprimento final pois j� consegue calcular
I=[1000; 1; 1; 1]; %momento de in�rcia 
d=zeros(nn,1); 
e=zeros(nn,1);
b=zeros(nn,1);
X=zeros(nn,1);
for k=2:nn-1
    e(k)=L(k-1)/6/E/I(k-1);
    d(k)=L(k-1)/3/E/I(k-1)+L(k)/3/E/I(k);
end
e(nn)=L(nn-1)/6/E/I(nn-1);
% carregamento
% momento na extremidade esquerda
X(1)=0.0;
b(2)=-e(2)*X(1);
% momento na extremidade direita
X(nn)=0.5;
b(nn-1)=-e(nn)*X(nn);
%rota��es de apoio devidas ao carregamento
% carga uniformemente distribuida
p=[0; -1; -1; -1];
for k=1:nv
    b(k)=b(k)-p(k)*(L(k))^3/24/E/I(k);
    b(k+1)=b(k+1)-p(k)*(L(k))^3/24/E/I(k);
end
% solu��o do sistema tridiagonal sim�trico
% elimina��o a vante
for k=3:nn-1
    const=e(k)/d(k-1);
    d(k)=d(k)-const*e(k);
    b(k)=b(k)-const*b(k-1);
end
%retrosubstiuti��o
X(nn-1)=b(nn-1)/d(nn-1);
for k=nn-2:-1:2
    X(k)=(b(k)-e(k+1)*X(k+1))/d(k);
end
X