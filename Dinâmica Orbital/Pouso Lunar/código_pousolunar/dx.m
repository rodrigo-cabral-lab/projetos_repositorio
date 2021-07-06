function [dx] = intc(t, ci, param)

M = param(1);
g_L = param(2);
E = param(3);
theta = param(4); 

dx = zeros(4,1);

dx(1) = ci(3); %dx/dt
dx(2) = ci(4); %dy/dt
dx(3) = (E * sind(theta))/M; %dVx/dt
dx(4) = ((E * cosd(theta)) - (M * g_L))/M; %dVy/dt
end