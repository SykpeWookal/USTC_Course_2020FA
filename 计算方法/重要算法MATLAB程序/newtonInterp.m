clear, clc, clf
LW = 'linewidth'; lw = 2;

n = 10;
x = linspace(-1, 1, n)';
m = 100;
xx = linspace(-1, 1, m)';
F = @sin;
% F = @(x)1./(1+25*x.^2);
f = F(x);
p = ones(m, 1)*f(1);
l = ones(m, 1);
R = ones(m, 1);

for k = 1:n-1
    l = l.*(xx - x(k));
    f(k+1:n) = diff(f(k:n))./(x(k+1:n) - x(1:n-k));
    p = p + f(k+1)*l;
    R = R.*(xx - x(k));
end
R = R.*(xx - x(n));

figure(1)
plot(xx, F(xx), 'k', LW, lw), hold on
plot(xx, p, LW, lw)
legend('exact', 'interpolant', 'location', 'nw')

figure(2)
plot(2)
semilogy(xx, abs(F(xx) - p), 'k', LW, lw), hold on
semilogy(xx, abs(R)/factorial(n), LW, lw)
legend('error', 'error bound', 'location', 'se')