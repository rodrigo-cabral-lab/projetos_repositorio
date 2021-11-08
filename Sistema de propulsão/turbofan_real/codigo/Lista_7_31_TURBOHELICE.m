

close all
clear all
clc
% TURBO HELICE REAL - MATLAB - 7-31 Lista
% 

% Entradas:
M0 = 0.8; %Mach 0 de entrada
T0 = 240; % Em Kelvin
gamaC = 1.4; % 1.4 para o AR
gamaT = 1.35;
cpc = 1004; % Em (J/Kg K)
cpt = 1108;
hpr = 42800e3; % Em (J/Kg) entalpia
Tt44 = [1370 1110 1390 1780 2000]; % Em Kelvin 
piDmax = 0.98;
piBB = [0.96 0.9 0.92 0.94 0.95];
piN = 0.99;
eCC = [0.9 0.8 0.84 0.88 0.9];
etH = 0.89;
etL = 0.91;
% piC e tauT variando !!
piCC = [1:1:40]; % Raz�o de Press�es
tauTT = [0.5 0.6 0.7] ; % Raz�o de Temperaturas da turbina
nBB = [0.99 0.85 0.91 0.98 0.99];
nG = 0.99;
nmH = 0.99;
nmL = 0.99;
nProp = 0.83; % Eficiencia da Helice

% Sa�das: 
%Fm0 % Em (N/ Kg/s) - > Empuxo especifico 
%Wm0
%f % raz�o combust�vel ar mf/m0
%S % Em (mg/s / N) -> Consumo espec�fico de comb. por Empuxo 
%Sp
%nT % Eficiencia T�rmica
%nP % Eficiencia Propulsiva 
%n0 % Eficiencia Total 
% Cc % Coef. TRabalho produzido - empuxo do escoamento do motor(n�cleo)
% Cprop
% Ctot % Coef. TRabalho para o turbo helice completo = Cc + Cprop

%% Equa��es

linha = 0 ;

for iii=1:5 % Varia��o dos casos
    
Tt4 = Tt44(iii);
piB = piBB(iii);
eC = eCC(iii);
nB = nBB(iii);

for ii=1:length(tauTT)
    tauT = tauTT(ii);
    
for i=1:length(piCC)
    piC = piCC(i);


%1
Rc = ((gamaC -1)*cpc)/(gamaC);

%2
Rt = ((gamaT -1)*cpt)/(gamaT);

%3
a0 = sqrt(gamaC*Rc*T0);

%4
V0 = a0*M0;

%5
tauR = 1 + (((gamaC - 1)/(2))*(M0 ^2));

%6
piR = tauR^((gamaC)/(gamaC - 1));

%7 TESTE !!!

if M0 <= 1
   nR = 1 ;
else
    nR = 1 - ((0.075)*((M0 - 1)^(1.35))) ;
end

%8
piD = piDmax*nR;

%9
tauLamb = (cpt*Tt4)/(cpc*T0);

%10
tauC = piC^((gamaC -1)/(gamaC*eC));

%11
nC = ((piC^((gamaC -1)/(gamaC))) -1)/(tauC -1);

%12
f = (tauLamb -(tauR*tauC))/(((nB*hpr)/(cpc*T0))-tauLamb) ;

%13
tauTh = 1 - ((1/(nmH*(1 + f)))*(tauR/tauLamb)*(tauC -1));

%14
piTh = tauTh^((gamaT)/((gamaT -1)*etH));

%15
nTh = (1 - tauTh)/(1 - (tauTh^(1/etH))) ;

%16 ~ %19 � para tauTl �timo

%20
tauTl = tauT/tauTh;

%21
piTl = tauTl^(gamaT/((gamaT - 1)*etL));

%22
nTl = (1 - tauTl)/(1 - (tauTl^(1/etL))) ; 

%23
Pt9P0 = piR*piD*piC*piB*piTh*piTl*piN ;

%24
if Pt9P0 > (((gamaT + 1 )/(2))^((gamaT)/(gamaT - 1)))
   %25
    M9 = 1 ;
    Pt9P9 = ((gamaT + 1)/2)^(gamaT/(gamaT - 1));
    P0P9 = (Pt9P9)/(Pt9P0);
else
    %26
    M9 = sqrt((2/(gamaT - 1))*((Pt9P0^((gamaT - 1)/gamaT)) - 1));
    Pt9P9 = Pt9P0 ;
    P0P9 = 1 ;
end

%27
Tt9T0 = (Tt4/T0)*tauTh*tauTl;

%28
T9T0 = (Tt9T0)/(Pt9P9^((gamaT - 1)/gamaT));

%29
V9a0 = sqrt(((2*tauLamb*tauTh*tauTl)/(gamaC - 1))*...
    (1 - (Pt9P9^((-1)*(gamaT -1)/gamaT)))) ;


%30
Cprop = nProp*nG*nmL*(1 + f)*tauLamb*tauTh*(1 - tauTl);

%31
Cc = (gamaC - 1)*M0*...
    (((1+f)*V9a0)- M0 + ((1+f)*(Rt/Rc)*(T9T0/V9a0)*((1 - P0P9)/gamaC)));

%32
Ctot = Cprop + Cc  ;

%33
Fm0 = (Ctot*cpc*T0)/(V0) ;

%34
S = f/Fm0 ;


if (((2*tauLamb*tauTh*tauTl)/(gamaC - 1))*...
    (1 - (Pt9P9^((-1)*(gamaT -1)/gamaT)))) < 0

V9a0 = 0;
end

    % Sa�das para o vetor: 
    Fm0vetor(linha + ii,i) = Fm0;
    Svetor(linha + ii ,i) = S ;
    V9a0vetor(linha + ii,i) = V9a0 ;
    Ccvetor(linha + ii,i) = Cc ;
    Cpropvetor(linha + ii,i) = Cprop ;
    Ctotvetor(linha + ii,i) = Ctot ;



end

end
 
linha = linha + 3 ;

end

disp('Calculado Turbo Helice Ideal')

%% Gr�ficos 

%Ctot 
subplot(2,2,1)
xlabel('piC')
ylabel('Ctotal')
hold on
plot(piCC(14:40),Ctotvetor(1,[14:40]),'black.')
plot(piCC(7:40),Ctotvetor(2,[7:40]),'black--')
plot(piCC(4:40),Ctotvetor(3,[4:40]),'black')
plot(piCC(15:40),Ctotvetor(4,[15:40]),'red.')
plot(piCC(7:40),Ctotvetor(5,[7:40]),'red--')
plot(piCC(4:40),Ctotvetor(6,[4:40]),'red')
plot(piCC(15:40),Ctotvetor(7,[15:40]),'green.')
plot(piCC(7:40),Ctotvetor(8,[7:40]),'green--')
plot(piCC(4:40),Ctotvetor(9,[4:40]),'green')
plot(piCC(14:40),Ctotvetor(10,[14:40]),'yellow.')
plot(piCC(7:40),Ctotvetor(11,[7:40]),'yellow--')
plot(piCC(4:40),Ctotvetor(12,[4:40]),'yellow')
plot(piCC(14:40),Ctotvetor(13,[14:40]),'blue.')
plot(piCC(7:40),Ctotvetor(14,[7:40]),'blue--')
plot(piCC(4:40),Ctotvetor(15,[4:40]),'blue')
grid minor
hold off


%Fm0 % Em (N/ Kg/s) - > Empuxo especifico 
subplot(2,2,2)
xlabel('piC')
ylabel('Empuxo Especifico')
hold on
plot(piCC(14:40),Fm0vetor(1,[14:40]),'black.')
plot(piCC(7:40),Fm0vetor(2,[7:40]),'black--')
plot(piCC(4:40),Fm0vetor(3,[4:40]),'black')
plot(piCC(15:40),Fm0vetor(4,[15:40]),'red.')
plot(piCC(7:40),Fm0vetor(5,[7:40]),'red--')
plot(piCC(4:40),Fm0vetor(6,[4:40]),'red')
plot(piCC(15:40),Fm0vetor(7,[15:40]),'green.')
plot(piCC(7:40),Fm0vetor(8,[7:40]),'green--')
plot(piCC(4:40),Fm0vetor(9,[4:40]),'green')
plot(piCC(14:40),Fm0vetor(10,[14:40]),'yellow.')
plot(piCC(7:40),Fm0vetor(11,[7:40]),'yellow--')
plot(piCC(4:40),Fm0vetor(12,[4:40]),'yellow')
plot(piCC(14:40),Fm0vetor(13,[14:40]),'blue.')
plot(piCC(7:40),Fm0vetor(14,[7:40]),'blue--')
plot(piCC(4:40),Fm0vetor(15,[4:40]),'blue')
grid minor
hold off


%Cprop 
subplot(2,2,3)
xlabel('piC')
ylabel('Cprop')
hold on
plot(piCC(14:40),Cpropvetor(1,[14:40]),'black.')
plot(piCC(7:40),Cpropvetor(2,[7:40]),'black--')
plot(piCC(4:40),Cpropvetor(3,[4:40]),'black')
plot(piCC(15:40),Cpropvetor(4,[15:40]),'red.')
plot(piCC(7:40),Cpropvetor(5,[7:40]),'red--')
plot(piCC(4:40),Cpropvetor(6,[4:40]),'red')
plot(piCC(15:40),Cpropvetor(7,[15:40]),'green.')
plot(piCC(7:40),Cpropvetor(8,[7:40]),'green--')
plot(piCC(4:40),Cpropvetor(9,[4:40]),'green')
plot(piCC(14:40),Cpropvetor(10,[14:40]),'yellow.')
plot(piCC(7:40),Cpropvetor(11,[7:40]),'yellow--')
plot(piCC(4:40),Cpropvetor(12,[4:40]),'yellow')
plot(piCC(14:40),Cpropvetor(13,[14:40]),'blue.')
plot(piCC(7:40),Cpropvetor(14,[7:40]),'blue--')
plot(piCC(4:40),Cpropvetor(15,[4:40]),'blue')
grid minor
hold off
legend('exmpl TAut 0.5','exmpl TAut 0.6','exmpl TAut 0.7',...
    'lvl 1 TAut 0.5','lvl 1 TAut 0.6','lvl 1 TAut 0.7',...
    'lvl 2 TAut 0.5','lvl 2 TAut 0.6','lvl 2 TAut 0.7',...
    'lvl 3 TAut 0.5','lvl 3 TAut 0.6','lvl 3 TAut 0.7',...
    'lvl 4 TAut 0.5','lvl 4 TAut 0.6','lvl 4 TAut 0.7','location','westoutside')

%Ccvetor
subplot(2,2,4)
xlabel('piC')
ylabel('Cc')
hold on
plot(piCC(14:40),Ccvetor(1,[14:40]),'black.')
plot(piCC(7:40),Ccvetor(2,[7:40]),'black--')
plot(piCC(4:40),Ccvetor(3,[4:40]),'black')
plot(piCC(15:40),Ccvetor(4,[15:40]),'red.')
plot(piCC(7:40),Ccvetor(5,[7:40]),'red--')
plot(piCC(4:40),Ccvetor(6,[4:40]),'red')
plot(piCC(15:40),Ccvetor(7,[15:40]),'green.')
plot(piCC(7:40),Ccvetor(8,[7:40]),'green--')
plot(piCC(4:40),Ccvetor(9,[4:40]),'green')
plot(piCC(14:40),Ccvetor(10,[14:40]),'yellow.')
plot(piCC(7:40),Ccvetor(11,[7:40]),'yellow--')
plot(piCC(4:40),Ccvetor(12,[4:40]),'yellow')
plot(piCC(14:40),Ccvetor(13,[14:40]),'blue.')
plot(piCC(7:40),Ccvetor(14,[7:40]),'blue--')
plot(piCC(4:40),Ccvetor(15,[4:40]),'blue')
grid minor
hold off

