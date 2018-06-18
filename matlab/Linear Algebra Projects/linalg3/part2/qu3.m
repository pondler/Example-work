
% script to time and count iterations from running PortfolioOpt for varying
% gamma, to compare CG and LDL^T methods.


load('PortfolioData.mat')

gammas = 0.1: 0.1: 0.9; 

t_LDL = zeros(9,1); 
t_CG = t_LDL; 

N_LDL = t_LDL;
N_CG = N_LDL;

for j = 1: 9
    
    gamma = gammas(j); 
    
    [~, ~, ~, t, Niter] = PortfolioOpt(gamma, pbar, sigma, true, false, false); 
    t_LDL(j) = t;
    N_LDL(j) = Niter;
    
    tic 
    [~, ~, ~, t, Niter] = PortfolioOpt(gamma, pbar, sigma, false, true, false);
    t_CG(j) = t;
    N_CG(j) = Niter; 
    
end

figure()
hold on 
plot(gammas, t_LDL, '-o'); 
plot(gammas, t_CG, '-x'); 
hold off
xlabel('gamma')
ylabel('runtime of LDL/CG algorithms in PortfolioOpt')
title('Plot of time against gamma for LDL and CG')
legend('LDL','CG')
print('CGvsLDL_time','-dpng');


figure()
hold on 
plot(gammas, N_LDL, '-o'); 
plot(gammas, N_CG, '-x'); 
hold off
xlabel('gamma')
ylabel('# of iterations of LDL/CG algorithms in PortfolioOpt')
title('Plot of Niter against gamma for LDL and CG' )
legend('LDL','CG')
print('CGvsLDL_Niter','-dpng');