function dx = propmenos30(t,x)

% M = param(1);
% g_L = param(2);
% E = param(3);
% theta = param(4); 

M = 1; %massa do módulo (kg)
g_L = 1.8; %gravidade da Lua (m/s²)
E = 3.6; %empuxo do jato de gás (N)
theta = -30; %angulo 

% ci = [0 18 0 -7]; %condições iniciais [posição_x posição_y velocidade_x velocidade_y]

dx = zeros(4,1);

dx(1) = x(3); %posição em x
dx(2) = x(4); %posição em y
dx(3) = (E * sind(theta))/M; %velocidade em x
dx(4) = ((E * cosd(theta)) - (M * g_L))/M; %velocidade em y
end