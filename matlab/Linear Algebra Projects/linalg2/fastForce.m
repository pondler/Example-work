function [t, Fy] = fastForce(test) 

% function to plot yForce algo-time for increasing N 
%
% Input: test - flag, if true, runs tests the consistency of the force
%               with those of Force.m
%
% Output: t - 5x1 vector of run-time for prescribed N, b=4

Nvals = [100; 200; 400; 800; 1600];
b = 4; 
t = zeros(5,1); 

for i=1:5
    
    N = Nvals(i);
    
    % create Vx and Vy for the planar velocity vectors
    Vy = ones(2*N,1);
    
    % create the interation Matrix
    M = Msetup(b,N);
    
    tic
    
    % assign the block of contribution to the force in y from M
    M2 = M(2:2:2*N, 2:2:2*N); 
    % perform the 
    [L2, U2] = gelim(M2); 
   
    % solve system L*U = Vy, 
    Fy = backsub(U2,fwdsub(L2,Vy));     
    
    t(i) = toc;
    
    % use test flag to speed up if the check is already known to be true
    % (Force takes a long time to run) 
    if test == true
        % get y forces by calling the Force algo
        [~, F_bench] = Force(b,N);
        Fy_bench = F_bench(2:2:2*N); 
        
        if max(abs(Fy - Fy_bench)) > 1e-15
            disp(['Non convergence for N = ' num2str(N) ', error = ' ...
                  num2str(max(abs(Fy-Fy_bench)))])
            break 
        end
    end
    
end 

figure()
plot(log(Nvals), log(t))
xlabel('log N')
ylabel('log algo-time')
title(['log-log plot of N against fastForce run-time for b=' num2str(b)])
print('log-log_plot_fastForce','-dpng');