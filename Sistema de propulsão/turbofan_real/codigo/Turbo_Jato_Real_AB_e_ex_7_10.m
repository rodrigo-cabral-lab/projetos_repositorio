

%------Programa com os dados de entrada iguais aos dos Slides de Aula (Aula 12) do professor------% 
%------Programa pode ser utilizado para resolver a quest:o 7.10 do livro%

clc; clear all; close all;
format short 
format loose

%Sistemas de Propuls:o I

%Pedro Cavalcanti Magliari - RA: 11106413

%Inputs para os Loops

M0 = 2; %Varia:ao de Mach
Pi_C = 2 : 0.1 : 14; %Varia:ao da compressao do compressor

%Inputs das constantes do voo

T0 = 216.7; %Temperatura do escoamento livre em Kelvin
Tt4 = 1666.7; %Temperatura de saida da CC em Kelvin
Tt7 = 1944.4;
gama_C = 1.4; %gama dos gases nao queimados
gama_T = 1.33; %gama dos gases queimados
gama_AB = 1.3; %gama dos gases do AB
cp_C = 1004.832; %Cp dos gases nao queimados em J/Kg*k
cp_T = 1155.5568; %Cp dos gases queimados em J/Kg*K
cp_AB = 1235.106; %Cp dos gases do AB em K/Kg*K
hpr = 42798400; %Entalpia do combustivel em J/Kg
Pi_Dmax = 0.98;
Pi_B = 0.98;
Pi_AB = 0.98;
Pi_N = 0.98;
E_C = 0.89;
E_T = 0.91;
N_B = 0.99;
N_M = 0.98;
N_AB = 0.96;
P0_P9 = 1.0;

%C:lculo dos valores que nao variam nem com PI_C e nem com Mach_0

Rc = ((gama_C-1)/gama_C)*cp_C;
Rt = ((gama_T-1)/gama_T)*cp_T;
Rab = ((gama_AB-1)/gama_AB)*cp_AB;
A0 = sqrt(gama_C*Rc*T0);
TauL = (cp_T*Tt4)/(cp_C*T0);
TauLAB = (cp_AB*Tt7)/(cp_C*T0);

%C:lculos com os loops e condicional

for i=1:length(M0)
    
    if M0(i)<=1
        N_R = 1;
    else
        N_R = 1- 0.075*((M0(i)-1)^1.35);
    end
    
    Pi_D = Pi_Dmax*N_R;
    
    for j=1:length(Pi_C)
        
        TauC = Pi_C(j)^((gama_C-1)/(gama_C*E_C));
        TauR = 1+(((gama_C-1)*(M0(i)^2))/2);
        Pi_R = TauR^(gama_C/(gama_C-1));
        N_C = ((Pi_C(j)^((gama_C-1)/gama_C))-1)/(TauC-1);
        f(j) = (TauL-(TauR*TauC))/(((N_B*hpr)/(cp_C*T0))-TauL);
        Taut = 1-((TauR*(TauC-1))/(N_M*TauL*(1+f(j))));
        Pi_t = Taut^(gama_T/(E_T*(gama_T-1)));
        N_t = (1-Taut)/(1-Taut^(1/E_T));
        fab(j) = ((1+f(j))*(TauLAB-TauL*Taut))/(((N_AB*hpr)/(cp_C*T0))-TauLAB);
        Pt9_P9 = P0_P9*Pi_R*Pi_D*Pi_B*Pi_t*Pi_AB*Pi_N*Pi_C(j);
        T9_T0 = (Tt7/T0)/(Pt9_P9^((gama_AB-1)/gama_AB));
        M9 = sqrt((2/(gama_AB-1))*((Pt9_P9^((gama_AB-1)/gama_AB))-1));
        V9_A0 = M9*sqrt(((gama_AB*Rab)/(gama_C*Rc))*T9_T0);
        F_M0(j) = A0*(((1+f(j)+fab(j))*V9_A0)-M0(i)+((1+f(j)+fab(j))*(Rab/Rc)*T9_T0*(1/V9_A0)*(1-P0_P9)*(1/gama_C)));
        S(j) = (f(j)+fab(j))/(F_M0(j))*(10^6);
        N_T (j) = ((A0^2)*((1+f(j)+fab(j))*(V9_A0^2)-(M0(i)^2)))/(2*hpr*(f(j)+fab(j)));
        V0 = M0(i)*A0;
        N_P(j) = (2*V0*F_M0(j))/((A0^2)*((1+f(j)+fab(j))*(V9_A0^2)-(M0(i)^2)));
        N_0(j) = N_P(j)*N_T(j);
        ftot(j) = fab(j)+f(j);
        
        if Pi_C(j) == 4 %Valor o qual se quer as eficiencias
            
            fprintf('\n Valores para Pi_C = %.1f',Pi_C(j));
            fprintf('\n O valor de nc : %.5f',N_C);
            fprintf('\n O valor de nt : %.5f',N_t);
            fprintf('\n O valor de nT : %.5f',N_T(j));
            fprintf('\n O valor de nP : %.5f',N_P(j));
            fprintf('\n O valor de nO : %.5f\n',N_0(j));
            
        end
        
        if Pi_C(j) == 8 %Valor o qual se quer as eficiencias
           
            fprintf('\n Valores para Pi_C = %.1f',Pi_C(j));
            fprintf('\n O valor de nc : %.5f',N_C);
            fprintf('\n O valor de nt : %.5f',N_t);
            fprintf('\n O valor de nT : %.5f',N_T(j));
            fprintf('\n O valor de nP : %.5f',N_P(j));
            fprintf('\n O valor de nO : %.5f\n',N_0(j));
            
        end
        
        if Pi_C(j) == 12 %Valor o qual se quer as eficiencias
           
            fprintf('\n Valores para Pi_C = %.1f',Pi_C(j));
            fprintf('\n O valor de nc : %.5f',N_C);
            fprintf('\n O valor de nt : %.5f',N_t);
            fprintf('\n O valor de nT : %.5f',N_T(j));
            fprintf('\n O valor de nP : %.5f',N_P(j));
            fprintf('\n O valor de nO : %.5f\n',N_0(j));
            
        end 
        
    end
   
    subplot(2,2,1)
    plot (Pi_C, fab, '-.k',Pi_C,f,'--r', Pi_C,ftot,'-g')
    hold on
    %title ('Raz:o Combust:vel/Ar Turbo Jato Real com AB')
    xlabel('\pi_c')
    ylabel('f_a_b')
    legend('fab', 'f', 'ftot')
    axis([2 14 0.01 0.06])
    grid
    
    subplot(2,2,2)
    plot(Pi_C,F_M0, '-.k')
    hold on
    %title ('Empuxo Espec:fico Turbo Jato Real com AB')
    xlabel('\pi_c')
    ylabel('F/M_o')
    axis([2 14 800 1100])
    grid
    
    subplot(2,2,3)
    plot(Pi_C,S, '-.k')
    hold on
    %title ('Consumo Espec:fico Turbo Jato Real com AB')
    xlabel('\pi_c')
    ylabel('S')
    axis([2 14 40 60])
    grid
    
    subplot(2,2,4)
    plot(Pi_C,N_T, '-.k', Pi_C, N_P, '--r', Pi_C, N_0, '-g')
    hold on
    %title ('Efici:mcias Turbo Jato Real com AB')
    xlabel('\pi_c')
    ylabel('\eta')
    legend('\eta_T', '\eta_P','\eta_O')
    axis([2 14 0 1])
    grid

end         