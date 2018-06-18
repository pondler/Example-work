function [t, grad] = levinsontime(test)

% function to time and check accuracy of levinson_solve algorithm
%
% Output: 5x1 vector of run-time for prescribed N, b=4
%
% Input: test - flag, if true, runs tests the consistency of the force
%               with those of Force.m

Nvals = [100; 200; 400; 800; 1600];
b = 4; 
t = zeros(5,1); 

for i=1:5
    N = Nvals(i);
    
    Vy = ones(N,1); 
    M = Msetup(b,N); 
    M2 = M(2:2:2*N, 2:2:2*N); 
   
    % collect run-time of the levinson algorithm 
    tic
    Fy = levinson_solve(M2, Vy); 
    t(i) = toc; 
    
    % use test flag to speed up if the check is already known to be true
    % (Force takes a long time to run)
    if test==true    
        % get y forces by calling the Force algo
        [~, F_bench] = Force(b,N);
        Fy_bench = F_bench(2:2:2*N); 
        
        % test against limit (reduced for rounding error as levinson is
        % slightly less robust) 
        if max(abs(Fy - Fy_bench)) > 1e-13
            disp(['Non convergence for N = ' num2str(N) ', error = ' ...
                  num2str(max(abs(Fy-Fy_bench)))])
            break 
        end
    end
    
end

%  linear regression thorough the log-log plot
lin_reg = polyfit(log(Nvals),log(t), 1);

% get gradient of linear regression
grad = lin_reg(1);

figure()
plot(log(Nvals), log(t))
xlabel('log N')
ylabel('log algo-time')
title(['log-log plot of N against levinson run-time for b=' num2str(b)])
print('log-log_plot_levinson','-dpng');

