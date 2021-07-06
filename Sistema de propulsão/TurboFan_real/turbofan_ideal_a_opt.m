function output = turbofan_ideal_a_opt(input)
    %% a otimo com relacao ao consumo especifico de combustivel minimo
    %% Turbojet Ideal - Ciclo de Análise
    %% Inputs:
    %   M_0: inlet mach number 
    %   T_0: inlet temperature [K]
    %     y: specific heats ratio
    %   c_p: specific heat at constant pressure [J/(kg.K)]
    %  h_PR: low heating value of fuel [J/(kg.K)]
    %  T_t4: total temperature at combustion chamber [K]
    %  pi_c: razão de pressão total na câmara de combustao
    M_0 = input.M_0;
    T_0 = input.T_0;
    y = input.y;
    c_p = input.c_p;
    h_PR = input.h_PR;
    T_t4 = input.T_t4;
    pi_f = input.pi_f;
    pi_c = input.pi_c;
    %% Outputs:
    % F__m_0: specific thrust
    %     f: fuel air ratio
    %     S: thrust specific fuel consumption
    %   n_T: thermal efficiency
    %   n_P: propulsive efficiency
    %   n_0: overall efficiency
    %% obs
    %  units conversion: pg 3
    %  nomenclature: Ix
    %  propriedades dos gases ideais: pg 83
    
    %% ciclo de análise
    % constante ideal dos gases [kJ/(kg.K)]
    R = ((y-1)/y)*c_p;
    % velocidade do som na entrada
    a_0 = sqrt(y*R*T_0);
    % razão de temperaturas total/estatica do escoamento livre tau_r T_t0/T_0
    tau_r = 1 + ((y-1)/2)*M_0^2;
    % razão de saixa de entalpia tau_h = (c_p4*T_t4)/(c_p0*T_0) no caso ideial
    % todos os c_p sao iguais e tau_h = tau_r*tau_b
    tau_h = T_t4/T_0;
    % razão de temperatura total na camara de combustao (relacao
    % isentrópica)
    tau_c = pi_c^((y-1)/y);
    % razao de temperaturas no fan
    tau_f = pi_f^((y-1)/y);
    % razao de bypass otima
    a= (1/(tau_r*(tau_f-1)))*(tau_h - tau_r*(tau_c-1)-tau_h/(tau_r*tau_c) - (1/4)*(sqrt(tau_r*tau_f-1)+sqrt(tau_r-1))^2);
    % razão de velocidade de saida e felocidade do som de entrara com
    % afterburner
    V_9__a_0  = sqrt((2/(y-1))*(tau_h-tau_r*((tau_c-1)+a*(tau_f-1)) -tau_h/(tau_r*tau_c)));
    V_19__a_0  = sqrt((2/(y-1))*(tau_r*tau_f-1));

    % tração especifica
    F_m_0 = (a_0*(1+2*a)/(2*(1+a)))*(V_19__a_0 - M_0);
    % razão ar combustível 
    f = (c_p*T_0)*(tau_h-tau_r*tau_c)/(h_PR);
    % consumo especifico por tracao
    S = f/((1+a)*F_m_0);
    % eficiencia termica
    n_T = 1-1/(tau_r*tau_c);
    % eficientia propulsiva 
    n_P = 4*(1+2*a)*M_0/((3+4*a)*M_0 + (1+4*a)*(V_19__a_0));  
    % eficiencia total 
    n_0 = n_T*n_P;    
    % parametro de eficiencia
    FR = (V_9__a_0 - M_0)/(V_19__a_0 - M_0);
    
    output.F_m_0 = F_m_0 ;
    output.f = f;
    output.S = S*1e6;
    output.n_T = n_T;
    output.n_P = n_P;
    output.n_0 = n_0; 
    output.FR = FR;
    output.a_opt = a;
end