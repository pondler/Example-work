
% Function to time and count iterations until convergence and run time of 
% A12z for varying b and n to produce contour plots

rng(10)

N = 100: 30 : 600;

B = 3 : 12; 

T = zeros(10); 
Niter = zeros(10); 

for i = 1:10
    
    n = N(i);
    z = rand(2 * n, 1); 
    
    for j = 1:10
    
        b = B(j);
        
        [T(i,j), Niter(i,j)] = A12z(b, n, z);
        
    end
   
end

figure()
contourf(T)
ylabel('N index')
xlabel('b index')
colorbar
title('contour plot of run-time for N against b' )
print('mastq4time','-dpng');
    

figure()
contourf(Niter)
ylabel('N index')
xlabel('b index')
colorbar
title('contour plot of N-iter for N against b' )
print('mastq4iter','-dpng');

