% solu��o sistemas lineares
% m�todo de Gauss com pivotamento
%
% exemplo a ser resolvido
%
n=3;
A=[0 2 3;4 6 7;2 1 6];
b=[8; -3; 5];
x=zeros(n,1);
%
% elimina��o de Gauss
%
for k=1:n-1
    %inicio pivotamento
    p=k;
    grande=abs(A(k,k));
    for ii=k+1:n
        aux=abs(A(ii,k));
        if aux>grande
            grande=aux;
            p=ii;
        end
    end
    if p ~= k
       for jj=k:n
          aux=A(p,jj);
          A(p,jj)=A(k,jj);
          A(k,jj)=aux;
       end
       aux=b(p);
       b(p)=b(k);
       b(k)=aux;
    end
    %
    % fim pivotamento
    %
    for i=k+1:n
        const=A(i,k)/A(k,k);
        for j=k:n
            A(i,j)=A(i,j)-const*A(k,j);
        end
        b(i)=b(i)-const*b(k);
    end
end
%
% retrosubstitui��o
%
x(n)=b(n)/A(n,n);
for i=n-1:-1:1
   s=0;
   for j=i+1:n
            s=s+A(i,j)*x(j);
   end
   x(i)=(b(i)-s)/A(i,i);
end
%
%resultado
%
x