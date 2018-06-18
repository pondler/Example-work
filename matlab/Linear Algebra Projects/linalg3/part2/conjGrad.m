function x = conjGrad(A, b) 

% statard conjugate gradient algorithm to solve Ax = b for x as extracted
% from [3]


N = length(A); 

x = zeros(N, 1); 
r1 = b;

p = r1; 
rho = norm(b);
k = 1;

while rho > 1e-8
    
    w = A * p;
    a = (r1' * r1) / (p' * w); 
    x = x + a * p;
    
    r2 = r1 - a * w;    
    
    B = (r2' * r2) / (r1' * r1);
    p = r2 + B * p;
    
    r1 = r2;
    
    rho = norm(r2); 
    
    k = k + 1; 

end

