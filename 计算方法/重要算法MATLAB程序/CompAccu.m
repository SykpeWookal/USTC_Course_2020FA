% Comparison of the accuracy of different one-step methods by solving ODE
% IVP:
%     y' = y - t^2 + 1    s.t.   y(0) = 0.5
% up to final time t_final = 3.
% The true solution is y(t) = (t+1).^2 - 0.5*exp(t).

clear, clc, clf
LW = 'LineWidth'; lw = 2;
MS = 'MarkerSize'; ms = 18;

f = @(t, y) y - t.^2 + 1; % RHS
y = @(t) (t+1).^2 - 0.5*exp(t); % exact solution
y0 = 0.5; % initial value

dom = [0 3]; % domain
y_final = y(dom(2)); % true solution at final time

nh = 10; % number of powers
h = logspace(-1, -3, nh); % mesh size in logarithmic 
err_euler = zeros(nh, 1); % error vector for different h using Euler.
err_rk2 = zeros(nh, 1); % error vector for different h using RK2.
err_rk4 = zeros(nh, 1); % error vector for different h using RK4.

for k = 1:nh
    [w, ~, h(k)] = euler(dom, f, y0, h(k)); % Solving by Euler.
    err_euler(k) = abs(w(end) - y_final);
    
    [w, ~, h(k)] = rk2(dom, f, y0, h(k)); % Solving by RK2.
    err_rk2(k) = abs(w(end) - y_final);
    
    [w, ~, h(k)] = rk4(dom, f, y0, h(k)); % Solving by RK4.
    err_rk4(k) = abs(w(end) - y_final);
end

% h vs error in loglog plot
loglog(h, err_euler, '.-', LW, lw, MS, ms), hold on
loglog(h, err_rk2, '.-k', LW, lw, MS, ms)
loglog(h, err_rk4, '.-r', LW, lw, MS, ms)
grid on
xlabel('step size h')
ylabel('error at the final time')
xlim([10^-3.1 10^-0.9])

legend('Euler (1st-order)', 'RK2 (2nd-order)', 'RK4 (4th-order)', ...
    'location', 'se')