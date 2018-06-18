function x = levinson_solve(T, b)

%Levinson algorithm for solving symmetric positive definite Toeplitz
% systems Tx = b as provided in Ch.4 of Golub and Van Loan
%
% Input: spd Toeplitz matrix T = ( r_abs(r(i) - r(j)) ) 
%        b - the rhs of the linear system
%
% Output: x the vector of unknowns 


% Normalise so there are ones on the diagonal 
di = T(1,1); 
T = (1.0/di)*T; 
b = (1.0/di)*b;

% get the r unique non-diagonals of the Toeplitz matrix
r = T(2:end,1); 
n = length(r)+1;

% preallocate vectors for use 
y = zeros(n,1);
x = zeros(n,1);
v = zeros(n,1); 
z = zeros(n,1); % can do this without v and z, but they improve clarity

% begin levinson algorithm

y(1) = - r(1);
x(1) = b(1); 
beta = 1;
alpha = -r(1); 


for k = 1:n-1 
    
    beta = (1-alpha^2)*beta; 
    mu = (b(k+1) - r(1:k)'*x(k:-1:1))/beta; 
    v(1:k) = x(1:k) + mu*y(k:-1:1); 
    x(1:k+1) = [v(1:k); mu];
    
    if k < n-1 
        alpha = (-r(k+1) - r(1:k)'*y(k:-1:1))/beta; 
        z(1:k) = y(1:k) + alpha*y(k:-1:1); 
        y(1:k+1) = [z(1:k); alpha];
    end
end

