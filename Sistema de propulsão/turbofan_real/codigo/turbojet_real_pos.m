function output = turbojet_real_pos(input)
    %% TurboJet real com pos combustor - Ciclo de Análise
    %% Inputs:
    %   M_0: inlet mach number 
    %   T_0: inlet temperature [K]
    %  h_PR: low heating value of fuel [J/(kg.K)]
    %   y_c: specific heats ratio na camar de combusto
    %  c_pc: calor especifico a pressao constante no compressor [J/kg.K]
    %   y_t: razao de calor especifico na turbina
    %  c_pt: calor especifico a pressao constante na turbina [J/kg.K]
    %  y_AB: razão de calores específicos no afterburner
    % c_pAB: calor especifico a pressao constante no afterburner
    %  T_t4: total temperature at combustion chamber [K]
    %  T_t7: temperatura total apos afterburner
    % P0_P9: razao de pressoes entrada-saida
   %pi_dmax: razao de pressao no difusor maxima
    %  pi_c: Tt3/Tt2 razão de pressão no compressor
    %  pi_b: Tt4/Tt3 razão de pressão na camara de combustao
    %  pi_n: Tt9/Tt7 razão de pressão na exaustao
    %   e_c: eficiencia politropica do compressor
    %   e_t: eficiencia politropic da turbina
    %   n_b: eficiencia da queima
    %   n_m: eficiencia mecanic de eixo
    %  y_AB: 
    % c_pAB:
    % n_AB:
    % T_t7:
    %pi_AB:
    
    M_0 = input.M_0;
    T_0 = input.T_0;
    h_PR = input.h_PR;
    c_pc = input.c_pc;
    c_pt = input.c_pt;
    y_c = input.y_c;
    y_t = input.y_t;
    T_t4 = input.T_t4;
    P0_P9 = input.P0_P9;
    pi_c = input.pi_c;
    pi_b = input.pi_b;
    pi_n = input.pi_n;
    e_c = input.e_c;
    e_t = input.e_t;
    n_b = input.n_b;
    n_m = input.n_m;
    pi_dmax = input.pi_dmax;
    y_AB = input.y_AB;
    c_pAB = input.c_pAB;
    n_AB = input.n_AB;
    T_t7 = input.T_t7;
    pi_AB = input.pi_AB;
    
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
    tau_c = pi_c^((y_c-1)/(y_c*e_c));
    % eficiencia do compressor
    n_c = (pi_c^((y_c-1)/y_c)-1)/(tau_c -1);
    % razão ar combustível 
    f = (tau_h - tau_r*tau_c)/(n_b*h_PR/(c_pc*T_0) - tau_h);
    % razão de temperatura na turbina
    tau_t = 1 - tau_r*(tau_c-1)/(n_m*tau_h*(1+f));
    % razão de pressão na turbina
    pi_t = tau_t^(y_t/((y_t-1)*e_t));
    % eficiencia da turbina
    n_t = (1-tau_t)/(1-tau_t^(1/e_t));
    %
    tau_hAB = c_pAB*T_t7/(c_pc*T_0);
    %     
    f_AB = (1+f)*(tau_hAB - tau_h*tau_t)/(n_AB*h_PR/(c_pc*T_0) - tau_hAB);
    % razão de pressões totais na saida
    Pt9_P9 = P0_P9*pi_r*pi_d*pi_c*pi_b*pi_t*pi_n*pi_AB;
    % razão de temperatura de saida e entrada
    T9_T0 = (T_t7/T_0)/(Pt9_P9^((y_AB-1)/y_AB));
    % mach de saida
    M_9 = sqrt(2*(Pt9_P9^((y_AB-1)/y_AB)-1)/(y_AB-1));
    % razão de velocidade de saida e mach de entrada
    V9_a0 = M_9*sqrt(y_AB*R_AB*T9_T0/(y_c*R_c));
    % tração especifica
    F_m_0 = a_0*((1+f+f_AB)*(V9_a0 + R_AB*T9_T0*(1-P0_P9)/(R_c*V9_a0*y_c)) - M_0);
    % consumo especifico por tracao
    S = (f+f_AB)/F_m_0;
    % eficiencia termica
    n_T = a_0^2*((1+f+f_AB)*V9_a0^2-M_0^2)/(2*(f+f_AB)*h_PR);
    % eficientia propulsiva
    n_P = 2*V_0*(F_m_0)/(a_0^2*((1+f+f_AB)*V9_a0^2-M_0^2));
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
    
    output.F_m_0 = F_m_0 ;
    output.f = f;
    output.S = S*1e6; % conversao para [mg/sN]
    output.n_T = n_T;
    output.n_P = n_P;
    output.n_0 = n_0; 
    output.n_c = n_c;
    output.n_t = n_t;
end