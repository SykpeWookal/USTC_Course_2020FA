function [w, t, h] = rk4(dom, f, y0, h)

% A naive implementation of RK4 method.
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
    k1 = h*f(t(i), w(i));
    k2 = h*f(t(i)+h/2, w(i)+k1/2);
    k3 = h*f(t(i)+h/2, w(i)+k2/2);
    k4 = h*f(t(i)+h, w(i)+k3);
    w(i+1) = w(i) + (k1+2*k2+2*k3+k4)/6; % RK4 method
end

end