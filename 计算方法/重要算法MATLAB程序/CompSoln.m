% Solving y'=y-t^2+1 s.t. y(0) = 0.5 for 0<=t<=2 using forward Euler, RK2, and RK4.

clear, clc, clf
LW = 'LineWidth'; lw = 2;
MS = 'MarkerSize'; ms = 18;

f = @(t, y) y-t^2+1;
h = 0.5;
T = 2;
N = T/h;

t = zeros(N+1, 1);
w_euler = zeros(N+1, 1);
w_euler(1) = 0.5;
w_rk2 = w_euler;
w_rk4 = w_euler;

t(2:end) = (1:N)*h;
for i = 1:N
    
    % Euler:
    w_euler(i+1) = w_euler(i) + h*f(t(i), w_euler(i));
    
    % RK2:
    k1 = h*f(t(i), w_rk2(i));
    k2 = h*f(t(i)+h/2, w_rk2(i)+k1/2);
    w_rk2(i+1) = w_rk2(i) + k2; 
    
    % RK4 method:
    k1 = h*f(t(i), w_rk4(i));
    k2 = h*f(t(i)+h/2, w_rk4(i)+k1/2);
    k3 = h*f(t(i)+h/2, w_rk4(i)+k2/2);
    k4 = h*f(t(i)+h, w_rk4(i)+k3);
    w_rk4(i+1) = w_rk4(i) + (k1+2*k2+2*k3+k4)/6; 
end
plot(t, w_euler, '.-', LW, lw, MS, ms), hold on
plot(t, w_rk2, '.-r', LW, lw, MS, ms)
plot(t, w_rk4, '.-g', LW, lw, MS, ms)

% Exact solution:
F = @(t) (t+1).^2-.5*exp(t);
tt = linspace(0, 2, 1000);
ff = F(tt);
plot(tt, ff, 'k', LW, lw, MS, ms)

legend('Euler', 'RK2', 'RK4', 'exact', 'location', 'nw')