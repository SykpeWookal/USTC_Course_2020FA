clear, clc, clf
LW = 'LineWidth'; lw = 2;
FS = 'FontSize'; fs = 20;
MS = 'MarkerSize'; ms = 18;

% data
m = 101;
x = linspace(0, 1, m).';
Y = .05*sin(1000*x) + .5*cos(pi*x) - .4*sin(10*x);
N = 5;
coeffs = zeros(N);

% find polynomial coefficients
for n = 1:N
    coeffs(1:n, n) = polynomialfit(x, Y, n);
end

% Evaluate and plot
xx = linspace(0, 1, 101).';
yy = ones(101, N);

% Evaluate the polynomial for plotting using Horner's method 
for n = 1:N
    yy(:, n) = yy(:, n) * coeffs(n, n);
    for j = n-1:-1:1
        yy(:, n) = yy(:, n).*xx + coeffs(j, n);
    end
end

plot(xx, yy, x, Y, 'ro')
xlabel('x')

% Print the norm of the residuals
yy = ones(m, N);
for n = 1:N
    yy(:, n) = yy(:, n) * coeffs(n, n);
    for j = n-1:-1:1
        yy(:, n) = yy(:, n).*x + coeffs(j, n);
    end
    r = norm(yy(:, n) - Y, 2)
end

%%
function coeffs = polynomialfit (t, b, n)
% Construct coefficients of the polynomial of % degree at most n-1 that
% best fits data (t,b)
t = t(:);
b = b(:);
m = length(t);

% skinny and tall A
A = ones(m,n);
for j = 1:n-1
    A(:,j+1) = A(:,j).*t;
end
% normal equations and solution
B = A'*A; y = A'*b;
coeffs = B \ y;
end