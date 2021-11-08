clear all
clc


%Dados de entrada

T0=240; %K
gamac=1.4; %
cpc=1004; %J/Kg*K
gamat=1.35;
cpt=1108;
hpr=42800000; % J/Kg
pidmax=0.90;
pic=(0:0.2:40);
pib=0.90;
pin=0.95;
ec=0.80;
eth=0.80;
etl=0.80;
etab=0.85;
etamh=0.99;
etaml=0.99;
etaprop=0.83;
etag=0.99;
Tt4=1110; %K
M0=0.8;%adm
talt=(0.1:0.1:1);

%Declarando Vetores para taltl otimo

A=zeros(41,1);

pizao=zeros(41,1);

taltl_otimo=zeros(41,1);

pitl_otimo=zeros(41,1);

etatl_otimo=zeros(41,1);

Pt9_P0_otimo=zeros(41,1);

Pt9_P9_otimo=zeros(41,1);

P0_P9_otimo=zeros(41,1);

M9_otimo=zeros(41,1);

Tt9_T0_otimo=zeros(41,1);

T9_T0_otimo=zeros(41,1);

V9_a0_otimo=zeros(41,1);

Cprop_otimo=zeros(41,1);

Cc_otimo=zeros(41,1);

Ctotal_otimo=zeros(41,1);

F_m0_otimo=zeros(41,1);

S_otimo=zeros(41,1);

W_m0_otimo=zeros(41,1);

sp_otimo=zeros(41,1);

etaT_otimo=zeros(41,1);

etaP_otimo=zeros(41,1);

%Declarando Vetores para taltl fornecido

talc=zeros(41,1);

etac=zeros(41,1);

f=zeros(41,1);

talth=zeros(41,1);

pith=zeros(41,1);

etath=zeros(41,1);

taltl=zeros(41,1);

talt_otimo=zeros(41,1);

pitl=zeros(41,1);

etatl=zeros(41,1);

Pt9_P0=zeros(41,1);

Pt9_P9=zeros(41,1);

P0_P9=zeros(41,1);

M9=zeros(41,1);

Tt9_T0=zeros(41,1);

T9_T0=zeros(41,1);

V9_a0=zeros(41,1);

Cprop=zeros(41,1);

Cc=zeros(41,1);

Ctotal=zeros(41,1);

F_m0=zeros(41,1);

S=zeros(41,1);

W_m0=zeros(41,1);

sp=zeros(41,1);

etaT=zeros(41,1);

etaP=zeros(41,1);


%Declarando Matrizes

F_m0_mat=zeros(201,10);

S_mat=zeros(201,10);

Cprop_mat=zeros(201,10);

Cc_mat=zeros(201,10);
        
Ctotal_mat=zeros(201,10);


%Equa��es

Rc=(gamac-1)*cpc/gamac;

Rt=(gamat-1)*cpt/gamat;

a0=(gamac*Rc*T0)^(1/2);

V0=a0*M0;

talr=1+((gamac-1)/2)*M0^2;

pir=talr^(gamac/(gamac-1));

if M0<=1 
            
    etaR=1;
            
end

if M0>1
            
    etaR=1-0.075*(M0-1)^1.35;
            
end

pid=pidmax*etaR;

tallab=(cpt*Tt4)/(cpc*T0);

for i=1:201
           
        talc(i)=pic(i)^((gamac-1)/(gamac*ec));
        
        etac(i)=(pic(i)^((gamac-1)/gamac)-1)/(talc(i)-1);
        
        f(i)=(tallab-talr*talc(i))/(((etab*hpr)/(cpc*T0))-tallab);
        
        talth(i)=1-(1/(etamh*(1+f(i))))*(talr/tallab)*(talc(i)-1);
        
        pith(i)=talth(i)^(gamat/((gamat-1)*eth));
        
        etath(i)=(1-talth(i))/(1-talth(i)^(1/eth));
        

        %processo iterativo para obter taltl otimo
        
        A(i)=(((gamac-1)/2)*((M0^2)/(tallab*talth(i))))/(etaprop*etag*etaml)^2;
        
        pizao(i)=(pir*pid*pic(i)*pib*pin)^((gamat-1)/gamat);
        
        taltl_i=((talth(i)^(-1/eth))/pizao(i))+A(i);
        
        taltl_otimo(i)=10;
        
        z=10;
        
        w=1;
        
        while abs(z)>0.0001
            
            taltl_otimo(i)=((talth(i)^(-1/eth))/pizao(i))*(taltl_i^(-(1-etl)/etl))+A(i)*(1+((1-etl)/etl)*(((talth(i)^(-1/eth))*taltl_i^(-1/etl))/pizao(i)))^2;

            z=taltl_otimo(i)-taltl_i;
            
            taltl_i=taltl_otimo(i);
            
            w=w+1;
            
        end  
        
        talt_otimo(i)=taltl_otimo(i)*talth(i);
        
        %calculos com taltl otimo
        
        pitl_otimo(i)=taltl_otimo(i)^(gamat/((gamat-1)*etl));
        
        etatl_otimo(i)=(1-taltl_otimo(i))/(1-taltl_otimo(i)^(1/etl));
        
        Pt9_P0_otimo(i)=pir*pid*pic(i)*pib*pith(i)*pitl_otimo(i)*pin;
        
        if Pt9_P0_otimo(i)>((gamat+1)/2)^(gamat/(gamat-1));
            
            M9_otimo=1;   
            
            Pt9_P9_otimo(i)=((gamat+1)/2)^(gamat/(gamat-1));
            
            P0_P9_otimo(i)=Pt9_P9_otimo(i)/Pt9_P0_otimo(i);
              
        else
            
            M9_otimo(i)=((2/(gamat-1))*(Pt9_P0_otimo(i)^((gamat-1)/gamat)-1))^(1/2);
            
            Pt9_P9_otimo(i)=Pt9_P0_otimo(i);
            
            P0_P9_otimo(i)=1;
            
        end
        
        Tt9_T0_otimo(i)=(Tt4/T0)*talth(i)*taltl_otimo(i);
        
        T9_T0_otimo(i)=Tt9_T0_otimo(i)/Pt9_P9_otimo(i)^(-(gamat-1)/gamat);
        
        V9_a0_otimo(i)=(((2*tallab*talth(i)*taltl_otimo(i))/(gamac-1))*(1-Pt9_P9_otimo(i)^(-(gamat-1)/gamat)))^(1/2);
        
        Cprop_otimo(i)=etaprop*etag*etaml*(1+f(i))*tallab*talth(i)*(1-taltl_otimo(i));
        
        Cc_otimo(i)=(gamac-1)*M0*((1+f(i))*V9_a0_otimo(i)-M0+(1+f(i))*(Rt/Rc)*(T9_T0_otimo(i)/V9_a0_otimo(i))*((1-P0_P9_otimo(i))/gamac));
        
        Ctotal_otimo(i)=Cprop_otimo(i)+Cc_otimo(i);
        
        F_m0_otimo(i)=Ctotal_otimo(i)*cpc*T0/V0;
        
        S_otimo(i)=f(i)*1e+6/F_m0_otimo(i);
        
        W_m0_otimo(i)=Ctotal_otimo(i)*cpc*T0;
        
        sp_otimo(i)=f(i)/(Ctotal_otimo(i)*cpc*T0);
        
        etaT_otimo(i)=Ctotal_otimo(i)/((f(i)*hpr)/(cpc*T0));
        
        etaP_otimo(i)=Ctotal_otimo(i)/((Cprop_otimo(i)/etaprop)+((gamac-1)/2)*((1+f(i))*(V9_a0_otimo(i))^2-M0^2));
end

for j=1:10
    
    for i=1:201
         
        %taltl fornecido
        
        taltl(i)=talt(j)/talth(i);
        
        
        %calculos com taltl fornecido
        
        pitl(i)=taltl(i)^(gamat/((gamat-1)*etl));
        
        etatl(i)=(1-taltl(i))/(1-taltl(i)^(1/etl));
        
        Pt9_P0(i)=pir*pid*pic(i)*pib*pith(i)*pitl(i)*pin;
        
        if Pt9_P0(i)>((gamat+1)/2)^(gamat/(gamat-1));
            
            M9=1;
            
            Pt9_P9(i)=((gamat+1)/2)^(gamat/(gamat-1));
            
            P0_P9(i)=Pt9_P9(i)/Pt9_P0(i);
              
        end
        
        if Pt9_P0(i)<=((gamat+1)/2)^(gamat/(gamat-1));
            
            M9(i)=((2/(gamat-1))*(Pt9_P0(i)^((gamat-1)/gamat)-1))^(1/2);
            
            Pt9_P9(i)=Pt9_P0(i);
            
            P0_P9(i)=1;
            
        end
        
        Tt9_T0(i)=(Tt4/T0)*talth(i)*taltl(i);
        
        T9_T0(i)=Tt9_T0(i)/Pt9_P9(i)^((gamat-1)/gamat);
        
        V9_a0(i)=(((2*tallab*talth(i)*taltl(i))/(gamac-1))*(1-Pt9_P9(i)^(-(gamat-1)/gamat)))^(1/2);
        
        Cprop(i)=etaprop*etag*etaml*(1+f(i))*tallab*talth(i)*(1-taltl(i));
        
        Cc(i)=(gamac-1)*M0*((1+f(i))*V9_a0(i)-M0+(1+f(i))*(Rt/Rc)*(T9_T0(i)/V9_a0(i))*((1-P0_P9(i))/gamac));
        
        Ctotal(i)=Cprop(i)+Cc(i);
        
        F_m0(i)=Ctotal(i)*cpc*T0/V0;
        
        S(i)=f(i)/F_m0(i);
        
        W_m0(i)=Ctotal(i)*cpc*T0;
        
        sp(i)=f(i)/(Ctotal(i)*cpc*T0);
        
        etaT(i)=Ctotal(i)/((f(i)*hpr)/(cpc*T0));
        
        etaP(i)=Ctotal(i)/((Cprop(i)/etaprop)+((gamac-1)/2)*((1+f(i))*(V9_a0(i))^2-M0^2));

        
        
        %Preenchendo matrizes para taltl fornecido
        
        F_m0_mat(i,j)=F_m0(i);

        S_mat(i,j)=S(i)*1e+6;

        Cprop_mat(i,j)=Cprop(i);

        Cc_mat(i,j)=Cc(i);
        
        Ctotal_mat(i,j)=Ctotal(i);
        
    end
    
end


%Plotando gr�fico de F_m0p x pi_c

figure(1)
plot(pic(:),F_m0_mat(:,5),'b',pic(:),F_m0_mat(:,6),'g',pic(:),F_m0_mat(:,7),'r',pic(:),F_m0_mat(:,8),'c',pic(:),F_m0_otimo(:),'k--')
xlabel('pi_c')
ylabel('F/m^._0')
title('Turboprop real')
% ylim([500 1400])
% xlim([0 40])
grid
legend('tal_t=0.5','tal_t=0.6','tal_t=0.7','tal_t=0.8','tal_t=�timo')



%Plotando gr�fico de S x pi_c

figure(2)
plot(pic(:),S_mat(:,5),'b',pic(:),S_mat(:,6),'g',pic(:),S_mat(:,7),'r',pic(:),S_mat(:,8),'c',pic(:),S_otimo(:),'k--')
xlabel('pi_c')
ylabel('S')
title('Turboprop real')
ylim([0 40])
xlim([0 40])
grid
legend('tal_t=0.5','tal_t=0.6','tal_t=0.7','tal_t=0.8','tal_t=�timo')



% %Plotando gr�fico de talt otimo x pi_c
% 
% figure(3)
% plot(pic(:),talt_otimo(:),'k--')
% xlabel('pi_c')
% ylabel('tal_t=otimo')
% title('Turboprop real')
% ylim([0.4 0.9])
% xlim([0 40])
% grid
% legend('tal_t=�timo')

figure(4)
plot(pic(:),Cprop_mat(:,5),'b',pic(:),Cprop_mat(:,6),'g',pic(:),Cprop_mat(:,7),'r',pic(:),Cprop_mat(:,8),'c',pic(:),Cprop_otimo(:),'k--')
xlabel('pi_c')
ylabel('C_p')
title('Turboprop real')
% ylim([0 1.4])
% xlim([0 40])
grid
legend('C_p tal_t=0.5','C_p tal_t=0.6','C_p tal_t=0.7','C_p tal_t=0.8','C_p tal_t=otimo')

figure(5)
plot(pic(:),Cc_mat(:,5),'b',pic(:),Cc_mat(:,6),'g',pic(:),Cc_mat(:,7),'r',pic(:),Cc_mat(:,8),'c',pic(:),Cc_otimo(:),'k--')
xlabel('pi_c')
ylabel('C_c')
title('Turboprop real')
% ylim([0 1.4])
% xlim([0 40])
grid
legend('C_c tal_t=0.5','C_c tal_t=0.6','C_c tal_t=0.7','C_c tal_t=0.8','C_c tal_t=otimo')

figure(6)
plot(pic(:),Ctotal_mat(:,5),'b',pic(:),Ctotal_mat(:,6),'g',pic(:),Ctotal_mat(:,7),'r',pic(:),Ctotal_mat(:,8),'c',pic(:),Ctotal_otimo(:),'k--')
xlabel('pi_c')
ylabel('C_t')
title('Turboprop real')
% ylim([0 1.4])
% xlim([0 40])
grid
legend('C_t tal_t=0.5','C_t tal_t=0.6','C_t tal_t=0.7','C_t tal_t=0.8','C_t tal_t=otimo' )