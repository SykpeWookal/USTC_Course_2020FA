clear, clc

F = @(x) exp(-x.^2);
a = 0;
b = 1;
tol = 1e-15; % preset tolerance
N = 50; % maximum # of the iterations
%%
h = b-a;
n = 1;
j = 1;
Rold(1) = h * (F(a) + F(b)) / 2;             % R(0,0)
%%
for k = 2:N
    h = h / 2;
    i = 1:n;
    Rnew = zeros(k, 1);
    Rnew(1) = (Rold(1) + 2 * h * sum(F(a+ (2*i-1)*h))) / 2;               % R(k,0) 
    for j = 2:k
        Rnew(j) = (4.^(j-1)*Rnew(j-1) - Rold(j-1)) / (4.^(j-1) - 1);   % R(k,j) 
    end
    if abs(Rnew(k) - Rold(k-1)) < tol       % quit if no improvement
        j
        break
    end
    Rold = Rnew;                            % algorithm optimization
    n = 2*n;                                % # of points
    j = j+1;                                % # of iterations
end

% print the results:
I = Rold(end)
syms t
f = F(t);
Iexact = double(int(f, a, b))
AbsErr = abs(I - Iexact)
RelErr = AbsErr / abs(Iexact)