
L = Schrodinger(1024); 
T = tridiagonalize(L);

[E, ~, ~] = wilkinsonQR(T);

X  = invItr(L,E); 

figure()
for j = 1 : 4 
    subplot(2,2,j)
    plot((X(:,j).^2))
    title(['Plot of ' num2str(j) 'th most negative'])
end
print('negPsi','-dpng');

figure() 
plot(X(:,5).^2); 
title('plot for positive eigenvalue')
print('posPsi','-dpng');