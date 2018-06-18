% Script to time the tridiagonalization algorithm for varying n and create
% a log-log plot


t = zeros(6,1); 
N = [400,800,1200,1600,2000,2400,2800,3200]'; 

for i = 1 : 8
    
    Ni = N(i);
    L = Schrodinger(Ni); 
    
    tic 
    T = tridiagonalize(L); 
    t(i) = toc;
    
end


figure()
loglog(t, N, '-x');
xlabel('log N')
ylabel('log run time')
title('log-log plot of N against tridiagonalize run-time' )
print('log-log_tridiag','-dpng');


lin_reg = polyfit(log(N),log(t), 1);

grad = lin_reg(1) %#ok<NOPTS>