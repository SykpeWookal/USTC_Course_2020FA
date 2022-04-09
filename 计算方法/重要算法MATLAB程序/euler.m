function [w, t, h] = euler(dom, f, y0, h)

% A naive implementation of forward Euler method.
% Inputs:
% dom: time domain
% f: an anonymous function defined by the RHS of original ODE IVP
% y0: initial value
% h: step size

T = diff(dom);
N = ceil(T/h);
h = T/N;

t = dom(1):h:dom(2);
w = zeros(N+1, 1);
w(1) = y0;

for i = 1:N
    w(i+1) = w(i) + h*f(t(i), w(i)); % Euler method
end

end
