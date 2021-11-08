% solução de treliças planas isostaticas
% por equilibrio de nos
% arquivo equi_nos.m fevereiro 2018
% dimensoes do problema
nn=3;
nb=3;
neq=nn*2;
ninc=nb+3;
if (ninc>neq)
    displ('estrutura hiperestatica')
else if (ninc<neq)
        dipl('estrutura hipostatica')
    end
end
a=zeros(neq,neq);
p=zeros(neq,1);
% coordenadas dos nos
coord=[3.4641 2.0;0.0 0.0;4.6188 0.0;-1.0 0.0;0.0 -1.0;4.6188 -1.0];
%incidencia de barras
kone=[2 1;2 3;3 1;4 2;5 2;6 3];
% montagem da matriz de coeficientes
%k é o número da barra e também o número da coluna da matriz
for k=1:neq
    no_in=kone(k,1);
    no_fn=kone(k,2);
    dx=coord(no_fn,1)-coord(no_in,1);
    dy=coord(no_fn,2)-coord(no_in,2);
    dl=sqrt(dx*dx+dy*dy);
    c=dx/dl;
    s=dy/dl;
    %nó inicial: número das equações na horizontal e na vertical
    % que são também números da linha
    if (no_in<=nn)
        neq_v=no_in*2;
        neq_h=neq_v-1;
        a(neq_h,k)=-c;
        a(neq_v,k)=-s;
    end
    %nó final: número das equações na horizontal e na vertical
    % que são também números da linha
    if (no_fn<=nn)
        neq_v=no_fn*2;
        neq_h=neq_v-1;
        a(neq_h,k)=c;
        a(neq_v,k)=s;
    end
end
a
% carregamento
p(2)=-1000.0;
%p(3)=2000.0;
%p(5)=-1000.0;
% solução do sistema
f=gausspivo(a,p,neq)
%
