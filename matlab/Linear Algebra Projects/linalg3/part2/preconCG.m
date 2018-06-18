function x = preconCG (A, b)

%function to compute the conjugate gradient algorithm to solve Ax = b for x
%as developed from [3]

N = length(A);

% select the tridiagonal entries of the matrix A
C = diag(diag(A)) + diag(diag(A,1), 1) + diag(diag(A,-1),-1);

x = zeros(N, 1);
r1 = b;
rho = norm(b);

% introduced step: solve the preconditioned system
z1 = symTriSolve(C,r1);   % solve the system 
p = z1; 

k = 1; 

while rho > 1e-8
    w = A * p; 
    a = (r1' * z1) / (p' * w); 
    x = x + a * p; 
    r2 = r1 - a * w; 
    
    z2 = symTriSolve(C,r2); % solve the system
    
    B = (r2' * z2) / (r1' * z1); 
    p = z2 + B * p; 
    
    r1 = r2;
    z1 = z2;
    
    rho = norm(r2); 
    
    k = k + 1; 
    
end