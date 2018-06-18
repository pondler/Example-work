
% script to time and count iterations from running PortfolioOpt for varying
% gamma, to compare CG and preconditioned CG methods.

load('PortfolioData.mat')

gammas = 0.1: 0.1: 0.9; 

t_CG = zeros(9,1); 
t_preconCG = t_CG;

N_CG = zeros(9,1); 
N_preconCG = N_CG;


for j = 1 : 9 
    
    gamma = gammas(j);
    
    [~, ~, ~, t, Niter] = PortfolioOpt(gamma, pbar, sigma, false, true, false); 
    t_CG(j) = t;
    N_CG(j) = Niter;

    [~, ~, ~, t, Niter] = PortfolioOpt(gamma, pbar, sigma, false, false, true);
    t_preconCG(j) = t;
    N_preconCG(j) = Niter; 
    
end

figure()
hold on 
plot(gammas, t_CG, '-o'); 
plot(gammas, t_preconCG, '-x'); 
hold off
xlabel('gamma')
ylabel('runtime of CG/preconCG algorithms in PortfolioOpt')
title('Plot of time against gamma for CG and preconCG')
legend('CG','preconCG')
print('CGvspreconCG_time','-dpng');


figure()
hold on 
plot(gammas, N_CG, '-o'); 
plot(gammas, N_preconCG, '-x'); 
hold off
xlabel('gamma')
ylabel('# of iterations of LDL/CG algorithms in PortfolioOpt')
title('Plot of Niter against gamma for CG and preconCG')
legend('CG','preconCG')
print('CGvspreconCG_Niter','-dpng');
    