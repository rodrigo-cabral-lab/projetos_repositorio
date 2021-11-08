clc
format long

cpc = 0.24;
gamac = 1.4;
To =390;
pidmax =0.94;
pimmax = 0.95;
hpr = 18400;
ec = 0.88;
ef = 0.86;
et = 0.87;
pin = 0.95;
cpt = 0.296;
gamat = 1.3;
nb = 0.98;
pib = 0.94;
Tt4 = 3200;
cpab = 0.296;
gamaab = 1.3;
nab = 0.96;
piab = 0.94;
Tt7 = 3600;
M6 = 0.5;
nm = 0.99;
PoP9 = 1;
Mo = 0.9;
pic_var = 2:0.1:30;
pif_input =[1.5;2;3];
ask = 'L';

To = To/1.8;
Tt4 = Tt4/1.8;
Tt7 = Tt7/1.8;
cpc =  4.1868*cpc*1000;
cpt =  4.1868*cpt*1000;
cpab =  4.1868*cpab*1000;
hpr =  2.326*hpr*10^3;

[m,n] = size(pif_input);
i=0;

for d = pic_var
    i=i+1;
end


for cont = 1:m
    Pic{cont} = zeros(i,1);
    Empuxo{cont} = zeros(i,1);
    CombAr{cont} = zeros(i,1);
    EfTotal{cont} = zeros(i,1);
    EfProp{cont} = zeros(i,1);
    EfTermica{cont} = zeros(i,1);
    ETAturb{cont} = zeros(i,1);
    ETAcom{cont} = zeros(i,1);
    Alpha{cont} = zeros(i,1);
    X = zeros(i,1);
    Y1 = zeros(i,1);
    Y2 = zeros(i,1);
    Y3 = zeros(i,1);
      ii = 0;
      for pic = pic_var
        ii = ii+1; 
        pif = pif_input(cont,1);
        Pic{cont}(ii,1) = pic;
        tubofan_real_afterburn(ask, Mo, To, hpr, gamac, cpc, gamat, cpt, gamaab, cpab, Tt4, Tt7, PoP9, pidmax, pic, pib, pif, piab, pimmax, pin, ef, ec, et, nb, nab, nm, M6);        Empuxo{cont}(ii,1) = Fmo/9.8067;
        Empuxo{cont}(ii,1) = Fmo/9.8067;
        CombAr{cont}(ii,1) = f;
        Consumo{cont}(ii,1) = S/28.325;
        EfTotal{cont}(ii,1) = nO;
        EfProp{cont}(ii,1) = nP;
        EfTermica{cont}(ii,1) = nT;
        ETAturb{cont}(ii,1) = etat;
        ETAcom{cont}(ii,1) = etac;
        Alpha{cont}(ii,1) = alfa;
        Y1(ii,1) = 105;
        Y2(ii,1) = 1.845;
        Y3(ii,1) = 0.5;
        X(ii,1) = pic;
      end
  
end
 
figure();
subplot(2,1,1);
for cont = 1:m
    plot(Pic{cont},real(Empuxo{cont}))
       hold on
end

plot(X,Y1,'--')
xlabel('\pi_c')
ylabel('F/$\dot{m_0}$[N/(kg/s)]','Interpreter','latex')
grid minor
hold off
% 
subplot(2,1,2);
for cont = 1:m
    plot(Pic{cont},real(Consumo{cont}))
       hold on
end
plot(X,Y2,'--')
%ylim([0 2])
xlabel('\pi_c')
ylabel('S','Interpreter','latex')
grid minor
hold off