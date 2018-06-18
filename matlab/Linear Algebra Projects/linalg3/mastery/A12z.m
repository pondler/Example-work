function [t, Niter] = A12z (b, n, z) 

% functional form of qu2. 

M = Msetup(b, n);

beta = norm(z); 

m = 2;
relerr = 1;
y2 = zeros(2*n, 1);
y1 = ones(2*n, 1);

tic
while relerr > 1e-8
    
    e1 = zeros(m,1); e1(1) = 1; 
    
    [V, T] = lanczos(M, z, m);
    
    %T12 = pRoot(T); 
    T12 = T ^ 0.5;
    
    y2 = beta * V * T12 * e1;
    
    relerr = norm(y2 - y1) / norm(y2); 
    
    y1 = y2; 
    
    Niter = m - 1; 
    m = m + 2;
    
end

y = y2;

t = toc;