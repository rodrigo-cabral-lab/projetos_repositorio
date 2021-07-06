function output = turbofan_ideal_misturado(input)
    %% Turbofan Ideal com escoamento misturado- Ciclo de Análise
    %% Inputs:
    %   M_0: inlet mach number 
    %   T_0: inlet temperature [K]
    %     y: specific heats ratio
    %   c_p: specific heat at constant pressure [J/(kg.K)]
    %  h_PR: low heating value of fuel [J/(kg.K)]
    %  T_t4: total temperature at combustion chamber [K]
    %  pi_c: razão de pressão total na câmara de combustao
    %  pi_f ou a: razão de pressão total do fan ou razão de bypass
    M_0 = input.M_0;
    T_0 = input.T_0;
    y = input.y;
    c_p = input.c_p;
    h_PR = input.h_PR;
    T_t4 = input.T_t4;
    pi_c = input.pi_c;
    %% Outputs:
    % F__m_0: specific thrust
    %     f: fuel air ratio
    %   f_0: razao ar combustivel 0
    %     S: thrust specific fuel consumption
    %   n_T: thermal efficiency
    %   n_P: propulsive efficiency
    %   n_0: overall efficiency
    %  pi_f: razao de pressao total do fan
    %     a: razao de bypass
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
    if isfield(input,'pi_f')
        % se pi_f for fornecido
        pi_f = input.pi_f;
        % razao de temperaturas no fan
        tau_f = pi_f^((y-1)/y);
        % razao de bypass
        a = tau_h*(tau_c-tau_f)/(tau_r*tau_c*(tau_f-1)) - (tau_c-1)/(tau_f-1);
        if a < 0
            a = 0;
        end
    elseif isfield(input, 'a') ~=0
        % se a for fornecido
        a = input.a;
        % razao de temperaturas no fan
        tau_f = (tau_h/tau_r - (tau_c-1) + a)/(tau_h/(tau_r*tau_c)+a);
        % razao de pressao do fan
        pi_f = tau_f^(y/(y-1));
    else
        disp('espeficique a ou pi_f')
    end
    % razao de pressão total na turbina
    tau_t = 1 - (tau_r/tau_h)*(tau_c -1 + a*(tau_f-1));
    % razão ar combustível 
    f = (c_p*T_0)*(tau_h-tau_r*tau_c)/(h_PR);
    % tau_M definito como T_t6A/T_t6
    tau_M = (1+a*tau_r*tau_f/(tau_h*tau_t))/(1+a);
    % razão T_9/T_0
    T_9__T_0= tau_h*tau_t*tau_M/(tau_r*tau_f);
    % mach de saida
    M_9 = sqrt(2*(tau_r*tau_f-1)/(y-1));
    % razão de velocidade de saida e felocidade do som de entrara com
    % afterburner
    V_9__a_0  = sqrt(T_9__T_0)*M_9; 
    % razao ar combustivel considerando bypass
    f_0 = f/(1+a);
    % tração especifica
    F_m_0 = (a_0)*(V_9__a_0 - M_0);
    % consumo especifico por tracao
    S = f_0/F_m_0;
    % eficiencia termica
    n_T = (y-1)*c_p*T_0*(V_9__a_0^2-M_0^2)/(2*f_0*h_PR);
    % eficientia propulsiva 
    n_P = 2*M_0/(V_9__a_0 + M_0);
    % eficiencia total 
    n_0 = n_T*n_P;    
    
    output.F_m_0 = F_m_0 ;
    output.f = f;
    output.f_0 = f_0;
    output.S = S*1e6; % conversao para [mg/sN]
    output.n_T = n_T;
    output.n_P = n_P;
    output.n_0 = n_0; 
    output.pi_f = pi_f;
    output.a = a;
end