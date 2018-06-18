function L = tridiagonalize (L)

N = length(L);

for j = 1 : N - 2

    a = L(j + 1, j); 
    b = L(j + 2, j); 
    
    [c, s] = givens(a,b); 
    G = [c s; -s c];
    
    L([j + 1, j + 2], j:min(j + 5, N)) = G' * L([j + 1, j + 2], j:min(j + 5, N));
    L(j:min(j + 5, N), [j + 1, j + 2]) = L(j:min(j + 5, N), [j + 1, j + 2]) * G; 
    
    % check if a 'g' term has appeared outside of band
    if floor(0.5 * (N - j - 2)) > 0 

        mu = j + 1;

        a = L(mu + 2, mu); 
        b = L(mu + 3, mu); 
        
        [c, s] = givens(a,b); 
        G = [c s; -s c];        
        
        
        for k = 1 : floor(0.5 * (N - j - 2))
        
            mu = 2 * (k - 1) + j + 1;

            L([mu + 2, mu + 3], mu:min(mu + 5, N)) = G' * L([mu + 2, mu + 3], mu:min(mu + 5, N));
            L(mu:min(mu + 5, N), [mu + 2, mu + 3]) = L(mu:min(mu + 5, N), [mu + 2, mu + 3]) * G; 
        
        end
        
    end
    
end
