function dx = propmenos30(t,x)

% M = param(1);
% g_L = param(2);
% E = param(3);
% theta = param(4); 

M = 1; %massa do m�dulo (kg)
g_L = 1.8; %gravidade da Lua (m/s�)
E = 3.6; %empuxo do jato de g�s (N)
theta = -30; %angulo 

% ci = [0 18 0 -7]; %condi��es iniciais [posi��o_x posi��o_y velocidade_x velocidade_y]

dx = zeros(4,1);

dx(1) = x(3); %posi��o em x
dx(2) = x(4); %posi��o em y
dx(3) = (E * sind(theta))/M; %velocidade em x
dx(4) = ((E * cosd(theta)) - (M * g_L))/M; %velocidade em y
end