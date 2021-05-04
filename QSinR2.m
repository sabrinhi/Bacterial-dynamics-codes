function [n] = QSinR(x,k1,k2,u)
global g d
% Initial conditions for the simulation
x0 = 1;
r0 = 1;

eqn = @(t,coeff)[coeff(1).*((g.*(1+k1).*(k2./(k2+coeff(1))).*((coeff(2))./((coeff(2))+k1)))-d);...
   -u.*g.*(1+k1).*(k2./(k2+coeff(1))).*((coeff(2))./((coeff(2))+k1)).*coeff(1).*(coeff(2))];

[t,coeff] = ode45(eqn,x,[x0 r0]);
%'NonNegative'
n = coeff(:,1);
r = coeff(:,2);
end