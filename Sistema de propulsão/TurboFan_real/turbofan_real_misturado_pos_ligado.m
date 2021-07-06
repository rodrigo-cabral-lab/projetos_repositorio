function output = turbofan_real_misturado_pos_ligado(input)
    %% Turbofan real - escoamento misturado com pós combustor ligado - ciclo de análise
    %% Inputs:
    %   M_0: inlet mach number 
    %   T_0: inlet temperature [K]
    %  h_PR: low heating value of fuel [J/(kg.K)]
    %   y_c: specific heats ratio na camar de combusto
    %  c_pc: calor especifico a pressao constante no compressor [J/kg.K]
    %   y_t: razao de calor especifico na turbina
    %  c_pt: calor especifico a pressao constante na turbina [J/kg.K]
    %  y_AB:
    % c_pAB:
    %  T_t4: total temperature at combustion chamber [K]
    %  T_t7:
    % P0_P9: razao de pressoes entrada-saida
    % P0_P19: razao de pressoes entrada-saida do fan
   %pi_dmax: razao de pressao no difusor maxima
    %  pi_c: Tt3/Tt2 razão de pressão no compressor
    %  pi_b: Tt4/Tt3 razão de pressão na camara de combustao
    %  pi_f: razão de pressão ndo fan
    % pi_AB:
   %pi_Mmax:
    % pi_fn: razao de pressao na exausatau do fan
    %  pi_n: Tt9/Tt7 razão de pressão na exaustao
    %   e_f: eficiencia politropica do fan
    %   e_c: eficiencia politropica do compressor
    %   e_t: eficiencia politropic da turbina
    %   n_b: eficiencia da queima
    %   n_m: eficiencia mecanic de eixo
    %  n_AB:    
    %   M_6:
     
    pi_AB = input.pi_AB;
    pi_Mmax = input.pi_Mmax;
    n_AB = input.n_AB;
    M_6 = input.M_6;
    M_0 = input.M_0;
    T_0 = input.T_0;
    h_PR = input.h_PR;
    y_c = input.y_c;
    y_AB = input.y_AB;
    c_pc = input.c_pc;
    c_pAB = input.c_pAB;
    y_t = input.y_t;
    c_pt = input.c_pt;
    T_t4 = input.T_t4;
    T_t7 = input.T_t7;
    P0_P9 = input.P0_P9;
    pi_dmax = input.pi_dmax;
    pi_c = input.pi_c;
    pi_b = input.pi_b;
    pi_f = input.pi_f;
    pi_n = input.pi_n;
    e_f = input.e_f;
    e_c = input.e_c;
    e_t = input.e_t;
    n_b = input.n_b;
    n_m = input.n_m;
 
    %% obs
    %  units conversion: pg 3
    %  nomenclature: Ix
    %  propriedades dos gases ideais: pg 83
    
    %% ciclo de análise
    % constante ideal dos gases [kJ/(kg.K)]
    R = @(y,c_p)(((y-1)/y)*c_p);
    R_c = R(y_c, c_pc);
    R_t = R(y_t, c_pt);
    R_AB = R(y_AB, c_pAB);
    % velocidade do som na entrada
    a_0 = sqrt(y_c*R_c*T_0);
    % velocidade do escoamento livre
    V_0 = a_0*M_0;
    % razão de temperaturas total/estatica do escoamento livre tau_r T_t0/T_0
    tau_r = 1 + ((y_c-1)/2)*M_0^2;
     % razão de pressão total/estatica do escomaneto livre
    pi_r = tau_r^(y_c/(y_c-1));
    % parametro de eficiencia do difusor ?
    if M_0 <= 1
        n_r = 1;
    else
        n_r = 1-0.075*(M_0-1)^1.35;
    end    
    
    % razao de pressao no difusor
    pi_d = pi_dmax*n_r;
    % razão de saixa de entalpia tau_h = (c_p4*T_t4)/(c_p0*T_0) no caso ideial
    tau_h = (c_pt*T_t4)/(c_pc*T_0);
    % razão de temperatura total na camara de combustao (relacao
    % isentrópica)
    %
    tau_hAB = c_pAB*T_t7/(c_pc*T_0);
    %
    tau_c = pi_c^((y_c-1)/(y_c*e_c));
    % eficiencia do compressor
    n_c = (pi_c^((y_c-1)/y_c)-1)/(tau_c -1);
    % razão ar combustível 
    f = (tau_h - tau_r*tau_c)/(n_b*h_PR/(c_pc*T_0) - tau_h);
    % razao de temperatura do fan
    tau_f = pi_f^((y_c-1)/(y_c*e_f));
    % eficiencia do fan
    n_f = (pi_f^((y_c-1)/y_c)-1)/(tau_f -1);
   
    %
    a = (n_m*(1+f)*(tau_h/tau_r)*(1-(pi_f/(pi_c*pi_b))^((y_t-1)*e_t/y_t)) - ...
        (tau_c - 1))/(tau_f -1);
    % 
    tau_t = 1 - (tau_r*(tau_c-1 + a*(tau_f-1)))/(n_m*(1+f)*tau_h);
    %
    pi_t = tau_t^(y_t/((y_t-1)*e_t));
    %
    n_t = (1-tau_t)/(1-tau_t)^(1/e_t);
    % P_t16/P_t6
    P_t16_P_t6 = pi_f/(pi_c*pi_b*pi_t);
    %
    M_16= sqrt(2*((P_t16_P_t6*(1+ (y_t-1)*M_6^2/2)^(y_t/(y_t-1)))^((y_c-1)/y_c) ...
        -1)/(y_c-1) );
    % a'
    a_ = a/(1+f);
    % 
    c_p6A = (c_pt + a_*c_pc)/(1+a_);
    % 
    R_6A = (R_t+a_*R_c)/(1+a_);
    %
    y_6A = c_p6A/(c_p6A - R_6A);
    % T_t16/T_t6
    T_t16_T_t6 = T_0*tau_r*tau_f/(T_t4*tau_t);
    % 
    tau_M = c_pt*(1 + a_*(c_pc/c_pt)*T_t16_T_t6)/(c_p6A*(1+a_));
    % phi - linha de Reyleigh
    phi = @(M,y)(M^2*(1+(y-1)*M^2/2)/(1+y*M^2)^2);
    
    phi_6 = phi(M_6,y_t);
    phi_16 = phi(M_16, y_c);
    
    phi_6A = ((1+a_)/(1/sqrt(phi_6) + a_*sqrt(R_c*y_t*T_t16_T_t6/(...
        R_t*y_c*phi_16))))^2*R_6A*y_t*tau_M/(R_t*y_6A);
    
    % 
    M_6A = sqrt(2*phi_6A/(1-2*y_6A*phi_6A + sqrt(1- 2*(y_6A+1)*phi_6A)));
    % A_16/A_6
    A_16_A_6 = a_*sqrt(T_t16_T_t6)*M_6/(M_16*sqrt(y_c*R_t*((1+(y_c-1)*M_16^2/2)/...
        (1+(y_t-1)*M_6^2/2))/(y_t*R_c)));
    %
    MFP = @(M,y,R)(M*sqrt(y/R)/((1+(y-1)*M^2/2)^(y+1/(2*(y-1)))));
    % 
    pi_Mideal = (1+a_)*sqrt(tau_M)*MFP(M_6,y_t,R_t)/((1+A_16_A_6)*MFP(M_6A,y_6A,R_6A));
    %
    pi_M = pi_Mmax*pi_Mideal;
    
    % P_t9/P_9
    Pt9_P9 = P0_P9*pi_r*pi_d*pi_c*pi_b*pi_t*pi_M*pi_AB*pi_n;
    
%     % com pos combustor desligado
%     c_p9 = c_p6A;
%     R_9 = R_6A;
%     y_9 = y_6A;
%     f_AB = 0;
%     % T_9/T_0
%     T9_T0 = T_t4*tau_t*tau_M/(T_0*Pt9_P9^((y_9-1)/y_9));
    
    %com pos combustor ligado
    c_p9 = c_pAB;
    R_9 = R_AB;
    y_9 = y_AB;
    f_AB = (1+f/(1+a))*(tau_hAB - c_p6A*tau_h*tau_t*tau_M/c_pt)/(n_AB*h_PR/(c_pc*T_0)...
        -tau_hAB);
    T9_T0 = (T_t7/T_0)/((Pt9_P9)^((y_9-1)/y_9));
    
    % mach de saida
    M_9 = sqrt(2*(Pt9_P9^((y_9-1)/y_9)-1)/(y_9-1));
    % razão de velocidade de saida e mach de entrada
    V9_a0 = M_9*sqrt(y_9*R_9*T9_T0/(y_c*R_c));
    % 
    f_0 = f/(1+a) + f_AB;
    % tração especifica
    F_m_0 = a_0*((1+f_0)*V9_a0 -M_0 + (1+f_0)*R_9*T9_T0*(1-P0_P9)/(R_c*V9_a0*y_c));
    % 
    S = f_0/F_m_0;
    
    % eficiencia termica
    n_T = a_0^2*((1+f_0)*V9_a0^2+-M_0^2)/(2*f_0*h_PR);
    % eficientia propulsiva
    n_P = 2*V_0*F_m_0/(a_0^2*((1+f_0)*V9_a0^2+-M_0^2));
    % eficiencia total
    n_0 = n_P*n_T;    
       
    %% Outputs:
    % F__m_0: specific thrust
    %     f: fuel air ratio
    %     S: thrust specific fuel consumption
    %   n_T: thermal efficiency
    %   n_P: propulsive efficiency
    %   n_0: overall efficiency
    %   n_c: eficiencia do compressor
    %   n_t: eficiencia da turbina
    %   etc ?
    % f_AB:
    %  f_0:
    
    output.F_m_0 = F_m_0 ;
    output.f = f;
    output.f_AB = f_AB;
    output.f_0 = f_0;
    output.S = S*1e6;
    output.n_T = n_T;
    output.n_P = n_P;
    output.n_0 = n_0; 
    output.n_c = n_c;
    output.n_t = n_t;
    output.a = a;
    %output.n_f = n_f;
    % etc
%     output.pi_r = (tau_r)^(y/(y-1));
%     output.T_t3 = tau_f*tau_r*T_0;
%     output.tau_t = 1 - (tau_r/tau_h)*(tau_c - 1 + a*(tau_f-1));
%     output.T_t5 = output.tau_t*T_t4;% tau_r*T_0*output.tau_t;
%     output.M_19 = sqrt((2/(y-1))*(tau_r*tau_f - 1));
%     output.V_9 = V_9__a_0*a_0;
%     %output.P_t3 = output.pi_r*input.P_0*input.pi_c;
%     output.M_9 = sqrt((2/(y-1))*(tau_r*tau_c*output.tau_t-1));
end