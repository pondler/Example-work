function [L, D] = LDLt (A) 

% fucntion to find L and D of the LDL^T factorisation of A as implemented
% from [3]


N = length(A); 

v = zeros(N, 1); 

for j = 1 : N 
    
    for i = 1 : j - 1
        
        v(i) = A(j, i) * A(i, i); 
        
    end
    
    v(j) = A(j, j) - A(j, 1: j - 1) * v(1:j - 1); 
    
    A(j, j) = v(j); 
    
    A(j + 1:N, j) = (A(j + 1: N, j) - A(j + 1: N, 1:j - 1) * v(1: j - 1)) / v(j); 
    
end 


L = tril(A, -1) + diag(ones(N, 1)); 

D = diag(diag(A));