function [t, grad, tab] = wilkinsonAnalysis (timer, evalplot, lowtable)

N = [200:400:1800]'; 

if timer

    t = zeros(5,1); 

    for i = 1 : 5

        Ni = N(i);
        L = Schrodinger(Ni); 
        T = tridiagonalize(L); 

        [~,~,t(i)] = wilkinsonQR(T); 
        
    
    end
    
    figure()
    loglog(t, N, '-x');
    xlabel('log N')
    ylabel('log run time')
    title('log-log plot of N against wilkinsonQR run-time' )
    print('log-log_wilkinson','-dpng');
    
    lin_reg = polyfit(log(N),log(t'), 1);
    grad = lin_reg(1);
end
    
if evalplot 
    
    N = 1024;
    L = Schrodinger(N); 
    T = tridiagonalize(L); 
    
    [evals, ~, ~] = wilkinsonQR(T); 
    
    figure()
    plot(sort(evals), '-x');
    xlabel('index')
    ylabel('eigenvalue of T')
    title('Plot of QR Eigenvalues of T against their index' )
    print('evalplot','-dpng');
    
end

if lowtable
    
    N = 1024;
    L = Schrodinger(N); 
    T = tridiagonalize(L); 
    
    [evals, ~, ~] = wilkinsonQR(T); 
    
    tail = sort(evals, 'ascend');
    tail = tail(1:10); 
    
    tab = table(tail)
    
end
    
    