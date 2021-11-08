%nome do arquivo VIGA_deslocamentos.m
%programa de EF para calculo est�tico de vigas
%viga
% Prof Reyolando Brasil - mar�o 2018
%
clc
clear all
close all
%entrada de dados
%
%dimens�es do problema
%
nno=3;%n�mero de n�s
nglpn=2;%n�mero de graus de liberdade por n�
nds=nno*nglpn; %n�mero de deslocamentos do sistema
nel=2;%n�mero de elementos
nnel=2; %n�mero de n�s por elemento
ndpel=nnel*nglpn;%n�mero de deslocamentos por elemento
%
%coordenadas X dos n�s da viga
%
gcoord=[0;6;10];
%
%conectividade por elemento (n. dos n�s de cada elemento)
%
nodel=[1 2;2 3];
%
% matriz de n�mero de graus de liberdade por n�
%
LN=zeros(nno,nglpn);
%
%condi��es de contorno (n. de n� restrito e dire��es restritas ou livres)
%se fixa = -1; se livre = 0
%
LN(1,:)=[-1 -1];
LN(3,:)=[-1 -1];
%
%dados f�sicos dos elementos, m�d elasticidade, densidade, area da se��o
%
EM(1)=1.2e+06;
EM(2)=1.2e+06;
%
Ie(1)=0.0006;
Ie(2)=0.0003;
%
%determina��o das matrizes
%
%matriz LN
%
ngl=0;
for i=1:nno
    for j=1:nglpn
        if  LN(i,j)==0
            ngl=ngl+1;
            LN(i,j)=ngl;
        end
    end
end
ngr=ngl;
for i=1:nno
    for j=1:nglpn
        if LN(i,j)<0
            ngr=ngr+1;
            LN(i,j)=ngr;
        end
    end
end      
%
LN
%inicializa��o de matrizes e vetores
%
K=zeros(nds,nds);
p=zeros(nds,1);
P=zeros(nds,1);
%
%vetor de carregamento
P(LN(2,2))=-10;
%
% deslocamentos impostos
p(LN(3,2))=-0.001;
%
%matriz de rigidez
%
%
for iel=1:nel
    for j=1:nnel
        nd(j)=nodel(iel,j);
    end
    xini=gcoord(nd(1));
    xfim=gcoord(nd(2));
    L=abs(xfim-xini);
%
I=Ie(iel);E=EM(iel);
k=E*I*[12/L^3 6/L^2 -12/L^3 6/L^2;
           6/L^2 4/L -6/L^2 2/L;
           -12/L^3 -6/L^2 12/L^3 -6/L^2;
           6/L^2 2/L -6/L^2 4/L]
%matriz global
%
    kl=0;
    for n=1:nnel
        kl=kl+1;
        d(kl)=LN(nd(n),1);
        kl=kl+1;
        d(kl)=LN(nd(n),2);
    end
    for i=1:ndpel
        for j=1:ndpel
            K(d(i),d(j))=K(d(i),d(j))+k(i,j);
        end
    end
end
K
%
% solu��o do sistema
%
disp('deslocamentos')
%
A=K(1:ngl,1:ngl);
b=(P(1:ngl)-K(1:ngl,ngl+1:nds)*p(ngl+1:nds));
p(1:ngl)=gausspivo(A,b,ngl)
%
%c�lculo das rea��es de apoio
%
disp('Esfor�os Nodais inclusive rea��es de apoio')
P(ngl+1:nds)=K(ngl+1:nds,1:ngl)*p(1:ngl)+K(ngl+1:nds,ngl+1:nds)...
    *p(ngl+1:nds)
%
%esfor�os nas barras
%
disp('Esfor�os nas barras')
disp('Q1(For�a) Q2(Momento) Q3(For�a) Q4(Momento)')
for iel=1:nel
    for j=1:nnel
        nd(j)=nodel(iel,j);
    end
    xini=gcoord(nd(1));
    xfim=gcoord(nd(2));
    L=abs(xfim-xini);
%
I=Ie(iel);E=EM(iel);
k=E*I*[12/L^3 6/L^2 -12/L^3 6/L^2;
           6/L^2 4/L -6/L^2 2/L;
           -12/L^3 -6/L^2 12/L^3 -6/L^2;
           6/L^2 2/L -6/L^2 4/L];
%
  kl=0;
    for n=1:nnel
        kl=kl+1;
        d(kl)=LN(nd(n),1);
        kl=kl+1;
        d(kl)=LN(nd(n),2);
    end
    for i=1:ndpel
        q(i)=p(d(i));
    end
    (k*q')'
end