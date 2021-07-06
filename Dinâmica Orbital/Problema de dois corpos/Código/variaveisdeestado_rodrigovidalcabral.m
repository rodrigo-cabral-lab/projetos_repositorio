function dx = orbita(t,x) 
u = 3.986e5; % constante gravitacional x massa da Terra
% modelo em espaço de estados
dx = zeros(6,1); 
dx(1) = x(4);  % velocidades
dx(2) = x(5); 
dx(3) = x(6); 
dx(4) = -u*(x(1)/(sqrt(x(1)^2+x(2)^2+x(3)^2))^3); % acelerações
dx(5) = -u*(x(2)/(sqrt(x(1)^2+x(2)^2+x(3)^2))^3); 
dx(6) = -u*(x(3)/(sqrt(x(1)^2+x(2)^2+x(3)^2))^3); 

disp(dx)
