function [ret, risk, xn, t, i] = PortfolioOpt(gamma, pbar, sigma, LDL, CG, preCG)

clear val;
m = size(pbar,1);
% Set gamma and the tolerance for Newton convergence
% gamma = 0.5;
tol = 1e-8;

% Set the step size, the initial guess of the minimizer, and the vector 1 appearing in
% A

alpha = 0.1;
xn = ones(m,1)./m;
OneVec = ones(m,1);

i = 1;

tic

for n = 4:11
    % Fix the parameter t 
    t = 10^-n;
    res = 1;
    while (res > tol)
        % Set up the right hand side, r
        g = t./(xn) + (1 - gamma)*pbar - 2.0*gamma*sigma*xn;
        r = [g; 0];
        
        % Set up for the matrix, A
        A = ones(m+1);
        Phi = diag(t./(xn.^2));
        M = 2.0*gamma*sigma + Phi;
        A(1:m, 1:m) = M;
        A(m+1, m+1) = 0;
        
        % ****** INSERT HERE YOUR SOLVER FOR THE LINEAR SYSTEM to solve
        % A*dx = r for unknown dx. **********************
        
        
        if LDL
                        
            [L, D] = LDLt(A); 

            y = fwdsub(L, r); 
            dx = backsub(L', y .* diag(D).^-1);
        
        else
            
            N = length(M); 
            
            Z = diag([ones(N-1,1); 0]) + diag([ones(N-2,1);0],-1);
            ZMZ = Z' * M * Z; 
            Zg = Z' * g; 
            
            if CG 
                
                Zx = conjGrad(ZMZ, Zg); 
                dx = Z * Zx;
                                
            elseif preCG 
            
                Zx = preconCG2(ZMZ, Zg);
                dx = Z * Zx; 
                
            end
            
        end
        
                
        % ******* OWN CODE FINISHED *********************
        
        % Update the minimizer
        xnp1 = xn + alpha*dx(1:m);
        
        % Compute change in the minimizer to check for convergence. 
        res = norm(xnp1 - xn)./norm(xnp1);
        
        % Compute the value of the total cost function
        val(i) = gamma*xn'*sigma*xn - (1 - gamma)*pbar'*xn - t.*sum(log(xn)); 
        xn = xnp1;
        i = i + 1;
    end
end

t = toc; 

% Compute the portfolio return
ret = pbar'*xn;

% Compute the risk
risk = xn'*sigma*xn;
