
% script to perform the polynomial approximation of A^(1/2) * z for z some 
% random vector and A is M as set up below.

clear

rng(10)

% set up problem 
M = Msetup(3, 5);
z = rand(10, 1); 

beta = norm(z); 

m = 2;
relerr = 1;
y2 = zeros(10, 1);
y1 = ones(10, 1);

while relerr > 1e-8
    
    e1 = zeros(m,1); e1(1) = 1; 
    
    % solve for basis
    [V, T] = lanczos(M, z, m);
    
    % find root
    T12 = pRoot(T); 
    
    % new estimate 
    y2 = beta * V * T12 * e1;
    
    % relative error
    relerr = norm(y2 - y1) / norm(y2); 
    
    y1 = y2; 
    
    m = m + 2;

end

y = y2 