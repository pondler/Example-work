% script providing numerical evidence of backwards stability of parpivgelim
% creates a plot of residual error against N, (un/)adjusted for growth factor

% assign vector of N values
Nvals = [100; 200; 400];
b = 4;

% preallocate residual vector
r = ones(3,2); % easier to see correct calculation is done

for i = 1:3
    % assign N and create the matrix in question
    N = Nvals(i); 
    M = Msetup(b,N); 
    
    % compute the partial pivot LU decomposition
    [L, U, P] = parpivgelim(M); 
    
    % calculate the growth factor
    rho = max(U)/max(M); 
    
    % calculate the residual/backward error of the decomposition
    r(i,1) = norm(L*U - P*M)/norm(M);
    r(i,2) = r(i,1)/rho;
end


figure()
plot(Nvals/100, r)
legend('residual', 'rho residual'); 
xlabel('N values /100')
ylabel('Residual')
title('Plot of Residuals against N')
print('residual_plot','-dpng');