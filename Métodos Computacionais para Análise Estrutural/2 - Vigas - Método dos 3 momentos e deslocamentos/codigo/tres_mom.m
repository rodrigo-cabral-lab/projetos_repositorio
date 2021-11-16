% solução de vigas continuas
% equação dos 3 momentos
% arquivo tres_mom.m 
% dados do problema
% extremidades engastadas adicionar vão fictício de grande rigidez
nv=4;
nn=nv+1;
E=1;
L=[0.01; 3; 4; 5];
I=[1000; 1; 1; 1];
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
%rotações de apoio devidas ao carregamento
% carga uniformemente distribuida
p=[0; -1; -1; -1];
for k=1:nv
    b(k)=b(k)-p(k)*(L(k))^3/24/E/I(k);
    b(k+1)=b(k+1)-p(k)*(L(k))^3/24/E/I(k);
end
% solução do sistema tridiagonal simétrico
% eliminação a vante
for k=3:nn-1
    const=e(k)/d(k-1);
    d(k)=d(k)-const*e(k);
    b(k)=b(k)-const*b(k-1);
end
%retrosubstiutição
X(nn-1)=b(nn-1)/d(nn-1);
for k=nn-2:-1:2
    X(k)=(b(k)-e(k+1)*X(k+1))/d(k);
end
X
