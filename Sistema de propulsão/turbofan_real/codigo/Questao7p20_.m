%.....::  ELEMENTS OF PROPULSION  EX-7.20  ::.....;
%An�lise dos par�metros de desempenho de um motor tipo TURBOFAN REAL;

close all;
clear all;
clc;


%C�CULOS PARA TECNOLOGIA N�VEL 2 (cooled turbine, type A diffuser, and type D nozzle
M0=0.9; %Mach zero
PId_max= 0.95; %Pt2/Pt0
PIb= 0.92; %Pt4/Pt3
PIn= 0.97; %Pt9/Pt7
T0=216.7;%Temperatura estagna��o externa [K]
Nb= 0.94;%Efici�ncia da combust�o???
Nm=0.98;
P0P19=1;
P0P9= 1;
gama_c=1.4;%Relac�o entre Cp/Cv, valor padr�o p/ o ar �: 1,4
gama_t=1.35;
Tt4=1670;%kelvin
Cp_c=1.004;%Calor espec�fico(P. Cte), valor padr�o p/ o ar �: 1,0035 kJ/Kg*K
Cp_t= 1.096;%kJ/Kg*K
Hpr=42800;%Entalpia do combust�vel [kJ/Kg]
R_c= (((gama_c-1)/gama_c)*Cp_c); %Cte do g�s, valor padr�o para o ar ~ 287 J/Kg*K
R_t= (((gama_t-1)/gama_t)*Cp_t);
Ec=0.84;
Et=0.83;
Ef=0.82;
alfa=5;
PIc=2:0.1:40;
PIf=2;
%gama_t==gama9 | gama_c==gama0 | R_t==R9 | R_c==R0
Nr=1;
%if M0<=1
%    Nr=1;
%else
%    Nr= 1-(0.075.*((M0-1).^(1.35)));
%end
PId=PId_max*Nr;
a0= sqrt(gama_c*T0*R_c);%Vel. de estagna��o do som [m/s]
V0=a0*M0;
TAUl=((Tt4*Cp_t)/(T0*Cp_c));
TAUr= ((((gama_c-1)/2)*(M0.^2))+1);%Rela��o t0/t;
PIr=((TAUr).^(gama_c/(gama_c-1)));%Rela��o P0/P
TAUd=((PId).^((gama_c-1)/(gama_c)));
TAUb=((PIb).^((gama_c-1)/(gama_c)));
TAUn=((PIn).^((gama_c-1)/(gama_c)));
TAUc=((PIc).^((gama_c-1)/(gama_c*Ec)));
Nc=((PIc).^((gama_c-1)/(gama_c))-1)/(TAUc-1);
TAUf=((PIf).^((gama_c-1)/(gama_c*Ef)));
Nf=((PIf).^((gama_c-1)/(gama_c))-1)/(TAUf-1);
far= (TAUl-(TAUr*TAUc))/(((Hpr*Nb)/(Cp_c*T0))-TAUl);
TAUt=(1.-((TAUr*(TAUc-1+(alfa*(TAUf-1))))./(Nm*TAUl.*(far+1))));
PIt=(TAUt).^((gama_t)/((gama_t-1)*Et));
Nt=(1-TAUt)/(1-(TAUt.^(1/Et)));
Pt9P9=P0P9.*PIr.*PId.*PIc*PIb.*PIt*PIn;
Pt19P19=((gama_c+1)/2)^(gama_c/(gama_c-1));
M9= (real(sqrt((2/(gama_t-1)).*(((Pt9P9).^((gama_t-1)/gama_t))-1))));
T9T0= (TAUl*TAUt*Cp_c./(Cp_t*(Pt9P9.^((gama_t-1)/(gama_t)))));
V9a0= M9.*real(sqrt(((gama_t*R_t)/(gama_c*R_c)).*T9T0));
M19=real(sqrt((2/(gama_c-1)).*(((Pt19P19).^((gama_c-1)/gama_c))-1)));
T19T0=(TAUr*TAUf)/(Pt19P19^((gama_c-1)/gama_c));
V19a0=(M19*(real(sqrt(T19T0))));
V19V0=V19a0/M0;
ST=((a0./(1+alfa)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))/(R_c.*V9a0.*gama_c)))))+(((a0.*alfa)./(1+alfa)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC=far./((1+alfa).*ST);
ST2=ST*53;
STFC2=STFC*1000000;

%valores para raz�o de bypass �timo
PIzao=((PIr.*PId.*PIc.*PIb.*PIn).^((gama_t-1)/gama_t));
V9V0_otimo=(((TAUr.*(TAUf-1))./(2*Nm.*(TAUr-1).*(V19V0-1))).*(1+((1-(Et.*(TAUt.^(-1./Et))))./(Et.*PIzao))));

%c�lculo intrativo
TAUn_otimo=(1./PIzao)+(1./(TAUl.*(TAUr-1))).*(((TAUr.*(TAUf-1))./((2*Nm*V19V0)-1))^2);
TAUt=TAUn_otimo;
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
while TAUt_otimo-TAUt > 0.0001
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
TAUt=TAUt_otimo;
end
alfa_otimo=((Nm.*(1+far).*TAUl.*(1+TAUt_otimo))-(TAUr.*(TAUc-1)))./(TAUr.*(TAUf-1));

ST_otimo=((a0./(1+alfa_otimo)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))./(R_c.*V9a0.*gama_c)))))+(((a0*alfa_otimo)./(1+alfa_otimo)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC_otimo=far./((1+alfa_otimo).*ST);
alfa_otm_PIf2=alfa_otimo;
ST_otm_PIf2=ST_otimo*100;
STFC_otm_PIf2=STFC_otimo*1000000;

%C�CULOS PARA TECNOLOGIA N�VEL 3 (cooled turbine, type A diffuser, and type D nozzle)
M0=0.9; %Mach zero
PId_max= 0.98; %Pt2/Pt0
PIb= 0.94; %Pt4/Pt3
PIn= 0.98; %Pt9/Pt7
T0=216.7;%Temperatura estagna��o externa [K]
Nb= 0.99;%Efici�ncia da combust�o???
Nm=0.98;
P0P19=1;
P0P9= 1;
gama_c=1.4;%Relac�o entre Cp/Cv, valor padr�o p/ o ar �: 1,4
gama_t=1.35;
Tt4=1670;%kelvin
Cp_c=1.004;%Calor espec�fico(P. Cte), valor padr�o p/ o ar �: 1,0035 kJ/Kg*K
Cp_t= 1.096;%kJ/Kg*K
Hpr=42800;%Entalpia do combust�vel [kJ/Kg]
R_c= (((gama_c-1)/gama_c)*Cp_c); %Cte do g�s, valor padr�o para o ar ~ 287 J/Kg*K
R_t= (((gama_t-1)/gama_t)*Cp_t);
Ec=0.88;
Et=0.87;
Ef=0.86;
alfa=5;
PIc=2:0.1:40;
PIf=2;
%gama_t==gama9 | gama_c==gama0 | R_t==R9 | R_c==R0
Nr=1;
%if M0<=1
%    Nr=1;
%else
%    Nr= 1-(0.075.*((M0-1).^(1.35)));
%end
PId=PId_max*Nr;
a0= sqrt(gama_c*T0*R_c);%Vel. de estagna��o do som [m/s]
V0=a0*M0;
TAUl=((Tt4*Cp_t)/(T0*Cp_c));
TAUr= ((((gama_c-1)/2)*(M0.^2))+1);%Rela��o t0/t;
PIr=((TAUr).^(gama_c/(gama_c-1)));%Rela��o P0/P
TAUd=((PId).^((gama_c-1)/(gama_c)));
TAUb=((PIb).^((gama_c-1)/(gama_c)));
TAUn=((PIn).^((gama_c-1)/(gama_c)));
TAUc=((PIc).^((gama_c-1)/(gama_c*Ec)));
Nc=((PIc).^((gama_c-1)/(gama_c))-1)/(TAUc-1);
TAUf=((PIf).^((gama_c-1)/(gama_c*Ef)));
Nf=((PIf).^((gama_c-1)/(gama_c))-1)/(TAUf-1);
far= (TAUl-(TAUr*TAUc))/(((Hpr*Nb)/(Cp_c*T0))-TAUl);
TAUt=(1.-((TAUr*(TAUc-1+(alfa*(TAUf-1))))./(Nm*TAUl.*(far+1))));
PIt=(TAUt).^((gama_t)/((gama_t-1)*Et));
Nt=(1-TAUt)/(1-(TAUt.^(1/Et)));
Pt9P9=P0P9.*PIr.*PId.*PIc*PIb.*PIt*PIn;
Pt19P19=((gama_c+1)/2)^(gama_c/(gama_c-1));
M9= (real(sqrt((2/(gama_t-1)).*(((Pt9P9).^((gama_t-1)/gama_t))-1))));
T9T0= (TAUl*TAUt*Cp_c./(Cp_t*(Pt9P9.^((gama_t-1)/(gama_t)))));
V9a0= M9.*real(sqrt(((gama_t*R_t)/(gama_c*R_c)).*T9T0));
M19=real(sqrt((2/(gama_c-1)).*(((Pt19P19).^((gama_c-1)/gama_c))-1)));
T19T0=(TAUr*TAUf)/(Pt19P19^((gama_c-1)/gama_c));
V19a0=(M19*(real(sqrt(T19T0))));
V19V0=V19a0/M0;
ST=((a0./(1+alfa)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))/(R_c.*V9a0.*gama_c)))))+(((a0.*alfa)./(1+alfa)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC=far./((1+alfa).*ST);
ST3=ST*53;
STFC3=STFC*100000;

%valores para raz�o de bypass �timo
PIzao=((PIr.*PId.*PIc.*PIb.*PIn).^((gama_t-1)/gama_t));
V9V0_otimo=(((TAUr.*(TAUf-1))./(2*Nm.*(TAUr-1).*(V19V0-1))).*(1+((1-(Et.*(TAUt.^(-1./Et))))./(Et.*PIzao))));

%c�lculo intrativo
TAUn_otimo=(1./PIzao)+(1./(TAUl.*(TAUr-1))).*(((TAUr.*(TAUf-1))./((2*Nm*V19V0)-1))^2);
TAUt=TAUn_otimo;
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
while TAUt_otimo-TAUt > 0.0001
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
TAUt=TAUt_otimo;
end
alfa_otimo=((Nm.*(1+far).*TAUl.*(1+TAUt_otimo))-(TAUr.*(TAUc-1)))./(TAUr.*(TAUf-1));

ST_otimo=((a0./(1+alfa_otimo)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))./(R_c.*V9a0.*gama_c)))))+(((a0*alfa_otimo)./(1+alfa_otimo)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC_otimo=far./((1+alfa_otimo).*ST);
alfa_otm_PIF3=alfa_otimo;
ST_otm_PIf3=ST_otimo*100;
STFC_otm_PIf3=STFC_otimo*1000000;


%C�CULOS PARA TECNOLOGIA N�VEL 4 (cooled turbine, type A diffuser, and type D nozzle
M0=0.9; %Mach zero
PId_max= 0.995; %Pt2/Pt0
PIb= 0.95; %Pt4/Pt3
PIn= 0.995; %Pt9/Pt7
T0=216.7;%Temperatura estagna��o externa [K]
Nb= 0.999;%Efici�ncia da combust�o???
Nm=0.98;
P0P19=1;
P0P9= 1;
gama_c=1.4;%Relac�o entre Cp/Cv, valor padr�o p/ o ar �: 1,4
gama_t=1.35;
Tt4=1670;%kelvin
Cp_c=1.004;%Calor espec�fico(P. Cte), valor padr�o p/ o ar �: 1,0035 kJ/Kg*K
Cp_t= 1.096;%kJ/Kg*K
Hpr=42800;%Entalpia do combust�vel [kJ/Kg]
R_c= (((gama_c-1)/gama_c)*Cp_c); %Cte do g�s, valor padr�o para o ar ~ 287 J/Kg*K
R_t= (((gama_t-1)/gama_t)*Cp_t);
Ec=0.9;
Et=0.89;
Ef=0.89;
alfa=5;
PIc=2:0.1:40;
PIf=2;
%gama_t==gama9 | gama_c==gama0 | R_t==R9 | R_c==R0
Nr=1;
%if M0<=1
%    Nr=1;
%else
%    Nr= 1-(0.075.*((M0-1).^(1.35)));
%end
PId=PId_max*Nr;
a0= sqrt(gama_c*T0*R_c);%Vel. de estagna��o do som [m/s]
V0=a0*M0;
TAUl=((Tt4*Cp_t)/(T0*Cp_c));
TAUr= ((((gama_c-1)/2)*(M0.^2))+1);%Rela��o t0/t;
PIr=((TAUr).^(gama_c/(gama_c-1)));%Rela��o P0/P
TAUd=((PId).^((gama_c-1)/(gama_c)));
TAUb=((PIb).^((gama_c-1)/(gama_c)));
TAUn=((PIn).^((gama_c-1)/(gama_c)));
TAUc=((PIc).^((gama_c-1)/(gama_c*Ec)));
Nc=((PIc).^((gama_c-1)/(gama_c))-1)/(TAUc-1);
TAUf=((PIf).^((gama_c-1)/(gama_c*Ef)));
Nf=((PIf).^((gama_c-1)/(gama_c))-1)/(TAUf-1);
far= (TAUl-(TAUr*TAUc))/(((Hpr*Nb)/(Cp_c*T0))-TAUl);
TAUt=(1.-((TAUr*(TAUc-1+(alfa*(TAUf-1))))./(Nm*TAUl.*(far+1))));
PIt=(TAUt).^((gama_t)/((gama_t-1)*Et));
Nt=(1-TAUt)/(1-(TAUt.^(1/Et)));
Pt9P9=P0P9.*PIr.*PId.*PIc*PIb.*PIt*PIn;
Pt19P19=((gama_c+1)/2)^(gama_c/(gama_c-1));
M9= (real(sqrt((2/(gama_t-1)).*(((Pt9P9).^((gama_t-1)/gama_t))-1))));
T9T0= (TAUl*TAUt*Cp_c./(Cp_t*(Pt9P9.^((gama_t-1)/(gama_t)))));
V9a0= M9.*real(sqrt(((gama_t*R_t)/(gama_c*R_c)).*T9T0));
M19=real(sqrt((2/(gama_c-1)).*(((Pt19P19).^((gama_c-1)/gama_c))-1)));
T19T0=(TAUr*TAUf)/(Pt19P19^((gama_c-1)/gama_c));
V19a0=(M19*(real(sqrt(T19T0))));
V19V0=V19a0/M0;
ST=((a0./(1+alfa)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))/(R_c.*V9a0.*gama_c)))))+(((a0.*alfa)./(1+alfa)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC=far./((1+alfa).*ST);
ST4=ST*53;
STFC4=STFC*1000000;

%valores para raz�o de bypass �timo
PIzao=((PIr.*PId.*PIc.*PIb.*PIn).^((gama_t-1)/gama_t));
V9V0_otimo=(((TAUr.*(TAUf-1))./(2*Nm.*(TAUr-1).*(V19V0-1))).*(1+((1-(Et.*(TAUt.^(-1./Et))))./(Et.*PIzao))));

%c�lculo intrativo
TAUn_otimo=(1./PIzao)+(1./(TAUl.*(TAUr-1))).*(((TAUr.*(TAUf-1))./((2*Nm*V19V0)-1))^2);
TAUt=TAUn_otimo;
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
while TAUt_otimo-TAUt > 0.0001
TAUt_otimo=((TAUt.^((-1.*(1-Et))./Et))./PIzao)+(1./(TAUl.*(TAUr-1))).*((((TAUr.*(TAUf-1))./((2.*Nm.*V19V0)-1)).*(1+((1-(Et.*(TAUt.^(-1/Et))))./(Et.*PIzao)))).^2);
TAUt=TAUt_otimo;
end
alfa_otimo=((Nm.*(1+far).*TAUl.*(1+TAUt_otimo))-(TAUr.*(TAUc-1)))./(TAUr.*(TAUf-1));

ST_otimo=((a0./(1+alfa_otimo)).*(((1+far).*V9a0)-M0+((1+far).*((R_t.*T9T0.*(1-P0P9))./(R_c.*V9a0.*gama_c)))))+(((a0*alfa_otimo)./(1+alfa_otimo)).*(V19a0-M0+((T19T0.*(1-P0P19))./(V19a0.*gama_c))));
STFC_otimo=far./((1+alfa_otimo).*ST);
alfa_otm_PIf4=alfa_otimo;
ST_otm_PIf4=ST_otimo*100;
STFC_otm_PIf4=STFC_otimo*1000000;

subplot(2,1,1); hold on; grid minor;
plot(PIc,STFC_otm_PIf2,'b',PIc,STFC_otm_PIf3,'r',PIc,STFC_otm_PIf4,'k')
%title('Empuxo espec�fico por consumo de combust�vel �TIMO x Raz�o de compress�o \pi_c')
ylabel('S')
xlabel('\pi_c')
legend('2','3','4')
axis([2 40 0 500]);

subplot(2,1,2); hold on; grid minor;
plot(PIc,ST_otm_PIf2,'b',PIc,ST_otm_PIf3,'r',PIc,ST_otm_PIf4,'k')
%title('Empuxo espec�fico �TIMO x Raz�o de compress�o \pi_c')
ylabel('F/m_0')
xlabel('\pi_c')
legend('2','3','4')
%axis([2 40 0 25]);