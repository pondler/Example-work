function [V, T] = lanczos(A, z, m)

% function to implement lanczos to find basis of degree m for {Az,
% A^2z,...} as described in lectures


N = length(A);
V = zeros(N, m + 1); 
% important: set first basis vector to be z
V(:, 1) = z / norm(z); 

a = zeros(m, 1); 
b = zeros(m + 1, 1); 

for j = 1 : m
    
    if j == 1
        v = A * V(:, 1);
    else
        v = A * V(:, j) - b(j) * V(:, j - 1);
    end
    
    a(j) = V(:, j)' * v; 
    v = v - a(j) * V(:, j);
    b(j+1) = norm(v); 
    
    if b == 0
        break 
    end
    
    V(:, j + 1) = v / b(j + 1);

end

V = V(:, 1:m); 

T = diag(a(1:m)) + diag(b(2:m), 1) + diag(b(2:m), -1);