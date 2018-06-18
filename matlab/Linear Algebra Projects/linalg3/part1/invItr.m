function X = invItr (L, E) 

% function to find the eigenvectors for negative eigenvalues of T as well
% as one positive one by performing inverse iteration algorithm on L using
% eigenvales = E 

N = length(L);

negE = E(E < 0);

% pick an arbitrary > 0 Eval as well ... 
posE = E(E > 0); 
negE = [negE; posE(100)]; 

X = zeros(N, length(negE)); 
    
for j = 1 : length(negE)
    
    v = zeros(N, 1);
    v(1) = 1;
    lamj = negE(j);
    
    err = 1;
    
    while err > 1e-8
        
        % solve the pentadiagonal system 
        w = pentDiagSolve(L - lamj * eye(length(L)), v);
                
        v = w / norm(w);
        
        err = norm(abs(lamj * v - L * v));  
            
    end
    
    X(:, j) = v; 
    
end    

% create permutation matrix

P = zeros(N);

for i = 1:2:N
    k = (i-1)/2 + 1;
    j = N - k + 1;
    P(k,i) = 1;
    P(j,i+1) = 1;
end

% transfrom eigventors back 

X = P * X; 