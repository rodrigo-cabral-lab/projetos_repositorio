%-------------------------------------------------------------------------%
%         Turbo Fan Real  - Misturado - P�s Combustor Desligado!          %
%-------------------------------------------------------------------------%
clear all;
close all;
clc;

% Par�metros Iniciais
To = 216.7;  %K
gamma_c = 1.4;             
gamma_t = 1.3;
cpc = 1004; %J/(kg.K)
cpt = 1239; %J/(kg.K)
h_pr = 42800000; %J/kg
T_t4 = 1780; %K

pi_dmax = 0.94; pi_b = 0.94; pi_n = 0.95; pi_Mmax = 0.95;
e_c = 0.88; e_f = 0.86; e_t = 0.87;
eta_b = 0.98; eta_m = 0.99;
alfa = 0.4; %bypass
Po_P9 = 1;

M6 = 0.5; 
M = 2.0; %Mo                    

pi_c = 2:1:50;                 
n = length(pi_c);             % N�mero de elementos do vetor pi_c

%-------------------------------------------------------------------------%
%                           C�lculo dos par�metros                        %
%-------------------------------------------------------------------------%

Rc = ((gamma_c-1)/gamma_c)*cpc;             %1
Rt = ((gamma_t-1)/gamma_t)*cpt;             %2
a0 = sqrt(gamma_c*Rc*To);                   %3
Vo = a0*M;                                  %4
tau_r = 1 + 0.5*(gamma_c-1)*M.^2;           %5
pi_r = tau_r.^(gamma_c/(gamma_c-1));        %6

%Teste: 
if M <= 1
    eta_r = 1;                              %7
else
    eta_r = 1 - 0.075*(M-1).^(1.35); 
end

pi_d = pi_dmax*eta_r;                         %8   
tau_lambda = (cpt*T_t4)/(cpc*To);             %9    
tau_c = (pi_c).^((gamma_c-1)/(gamma_c*e_c));  %10    

% Empuxo, Consumo espec�fico, Rendimentos...

%Vari�vel auxiliar
aux1 = 1 + 0.5*(gamma_t-1)*M6.^2;
aux2 = aux1.^(gamma_t/(gamma_t-1));


for i = 1:n
    eta_c(i) = ((pi_c(i)).^((gamma_c-1)/gamma_c)-1)/(tau_c(i)-1); %11
    f(i) = (tau_lambda-tau_r*tau_c(i))/(((eta_b*h_pr)/(cpc*To))-tau_lambda); %12
    
    %Converg�ncia
    tau_f1(i) = (eta_m*(1+f(i))*tau_lambda + tau_r*(alfa -(tau_c(i)-1)))/...
        (tau_r*alfa - eta_m*(1+f(i))*(tau_lambda/((pi_c(i)*pi_b).^(((gamma_t-1)*e_t)/gamma_t)))); %13 - valor inicial
    cont = 1;
    
    %Loop
    while cont < 50
        tau_f(i) = (eta_m*(1+f(i))*tau_lambda + tau_r*(alfa-(tau_c(i)-1)))/...
            (tau_r*alfa + (eta_m*(1+f(i))*(tau_lambda/((pi_c(i)*...
            pi_b).^(((gamma_t-1)*e_t)/gamma_t))))*tau_f1(i).^(((gamma_t-1)/...
            (gamma_c-1))*(gamma_c/gamma_t)*e_f*e_t-1)); %14
        delta = abs(tau_f1(i)-tau_f(i));
        tau_f(i) = tau_f1(i);
        cont = cont + 1;
    end   
    
    %Uma vez calculado tau_f
    pi_f(i) = tau_f(i).^(gamma_c*e_f/(gamma_c-1)); %15
    eta_f(i) = (pi_f(i).^((gamma_c-1)/gamma_c)-1)/(tau_f(i)-1); %16
    tau_t(i) = (pi_f(i)/(pi_c(i)*pi_b)).^((gamma_t-1)*e_t/gamma_t); %17
    pi_t(i) = tau_t(i).^(gamma_t/((gamma_t-1)*e_t)); %18
    eta_t(i) = (1-tau_t(i))/(1-tau_t(i)^(1/e_t)); %19   
    Pt16_P6(i) = pi_f(i)/(pi_c(i)*pi_b*pi_t(i)); %20
    M16(i) =sqrt((2/(gamma_c-1))*((Pt16_P6(i)*aux2).^((gamma_c-1)/gamma_c)-1)); %21
    alfa1(i) =alfa/(1+f(i)); %22
    cp6A(i) = (cpt + alfa1(i)*cpc)/(1+alfa1(i)); %23
    R6A(i) = (Rt+alfa1(i)*Rc)/(1+alfa1(i)); %24
    gamma6A(i) = cp6A(i)/(cp6A(i)-R6A(i)); %25
    Tt16_Tt6(i) = (To*tau_r*tau_f(i))/(T_t4*tau_t(i)); %26
    tau_M(i) = (cpt/cp6A(i))*((1+alfa1(i)*(cpc/cpt)*Tt16_Tt6(i))/(1+alfa1(i))); %27
    phi_M6_g6(i) = (M6.^2*(1+0.5*(gamma_t-1)*M6.^2))/((1+gamma_t*M6.^2).^2); %28
    phi_M16_g16(i) = (M16(i).^2*(1+0.5*(gamma_t-1)*M16.^2))/((1+gamma_t*M16.^2).^2); %29
    phi_M6A_g6A(i) = tau_M(i)*(R6A(i)/Rt)*(gamma_t/gamma6A(i))*...
        ((1+alfa1(i))/((1/phi_M6_g6(i))+alfa1(i)*sqrt((Rc/Rt)*...
        (gamma_t/gamma_c)*(1/phi_M16_g16(i))*(Tt16_Tt6(i))))).^2; %30
    M6A(i) = sqrt(2*phi_M6A_g6A(i)/(1-2*gamma6A(i)*phi_M6A_g6A(i)+...
        sqrt(1-2*(gamma6A(i)+1)*phi_M6A_g6A(i)))); %31
    A16_A6(i) = alfa1(i)*sqrt(Tt16_Tt6(i))/((M16(i)/M6)*...
        sqrt((gamma_c/gamma_t)*(Rt/Rc)*((1+0.5*(gamma_c-1)*M16(i).^2)/...
        (1+0.5*(gamma_t-1)*M6.^2)))); %32
    MFP_M6(i) = M6*sqrt(gamma_t/Rt)/((1+0.5*(gamma_t-1)*...
        M6.^2).^((gamma_t+1)/(2*(gamma_t-1)))); %auxiliar1
    MFP_M6A(i) = M6A(i)*sqrt(gamma6A(i)/R6A(i))/((1+0.5*(gamma6A(i)-1)*...
        M6A(i).^2).^((gamma6A(i)+1)/(2*(gamma6A(i)-1)))); %auxiliar2
    pi_Mideal(i) = (1+alfa1(i))*sqrt(tau_M(i))*MFP_M6(i)/((1+A16_A6(i))*MFP_M6A(i)); %33
    pi_M(i) = pi_Mideal(i)*pi_Mmax; %34
    Pt9_P9(i) = Po_P9*pi_r*pi_d*pi_c(i)*pi_b*pi_t(i)*pi_M(i)*pi_n; %35
    Cp9(i) = cp6A(i);
    R9(i) = R6A(i);
    gamma_9(i) = gamma6A(i);
    T9_To(i) = ((T_t4*tau_t(i)*tau_M(i))/To)/((Pt9_P9(i).^((gamma_9(i)-1)/gamma_9(i)))-1); %36
    M9(i) = sqrt((2/(gamma_9(i)-1))*((Pt9_P9(i).^((gamma_9(i)-1)/gamma_9(i)))-1)); %37
    razao_v9(i) = M9(i)*sqrt((gamma_9(i)/gamma_c)*(R9(i)/Rc)*T9_To(i)); %38
    fo(i) = f(i)/(1+alfa); %39
    F_mo(i) = a0*((1+fo(i))*razao_v9(i)-M+(1+fo(i))*(R9(i)/Rc)*(T9_To(i)/razao_v9(i))*(1/gamma_c)*(1-Po_P9)); %40
    S(i) = 1000000*fo(i)/F_mo(i); %41
    
 
end

    
%% Gr�ficos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Para pi_c                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Gr�fico do F/mo ---> pic at� 
subplot(2,1,1); hold on; grid minor;
plot(pi_c,real(F_mo));
%title('Empuxo Espec�fico')
xlabel('\pi_c')
ylabel('F/m_o')
hold on
x = pi_c;
y = 539.4; %N.s/kg
plot(x,y*ones(1,size(x,2)))
hold on
subplot(2,1,2);hold on; grid minor;
plot(pi_c,real(S));
%title('Consumo Espec�fico de Combust�vel')
xlabel('\pi_c')
ylabel('S')
hold on
x = pi_c;
y = 36.8; %mg/(N.s)
plot(x,y*ones(1,size(x,2)))
grid on




