function x = spdTriSolve (T, y)

% Accelerated solver for spd tridiagonal matrices as implemented in [3]

N = length(T);
x = zeros(N + 1,1);
g = zeros(N + 1,1); 
b = zeros(N + 1,1); 
     
g(1) = 0; b(1) = 0;

for j = 1 : N - 1 
      
    if j > 1 

        g(j + 1) = - T(j + 1, j) / (T(j, j) + T(j - 1, j) * g(j)) ; 
        b(j + 1) = (y(j) - T(j - 1, j) * b(j)) / (T(j, j) + T(j - 1, j) * g(j)); 

    else 

        g(j + 1) = -T(j + 1, j) / T(j, j) ;           
        b(j + 1) = y(j) / T(j, j);
        
    end

end

b(N + 1) = (y(N) - T(N - 1, N) * b(N)) / (T(N, N) + T(N - 1, N) * g(N)); 
g(N + 1) = 0;
x(N + 1) = 0; 

for k = N + 1 : -1 : 2
    
    x(k - 1) = g(k) * x(k) + b(k); 
    
end

x = x(1:N);

% https://www.uni-muenster.de/imperia/md/content/physik_tp/lectures/ws2016-2017/num_methods_i/appendix.pdf