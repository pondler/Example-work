function X = invItr (L, E) 

% compute inverse iteration L tridiagonal with eigenvalues E to solve 
% for eigenvectors

N = length(L);
X = zeros(N, length(E)); 
    
for j = 1 : length(E)
    
    v = zeros(N, 1);
    v(1) = 1;
    lamj = E(j);
    
    err = 1;
        
    while err > 1e-8
        
        w = spdTriSolve(L - lamj * eye(length(L)), v);

        v = w / norm(w);
               
        err = norm(abs(lamj * v - L * v)); 
        
    end
    
    X(:, j) = v; 
    
end    