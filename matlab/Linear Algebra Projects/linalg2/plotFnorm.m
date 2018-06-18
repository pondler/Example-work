
% Script for plotting y-Force and making Norm-Force tables of for the prescribed values of N and b 

% assign vectors of N and b values
Nvals = [100; 200; 400];
bvals = [2; 4; 10];

NF = zeros(3);

legendInfo = cell(3,1);

for i=1:3 
    % set N value
    N = Nvals(i);
  
    % create x
    x = (0:1:N-1)'*(1.0/(N-1));
    
    figure(i)
    for j=1:3
       % set b value
       b = bvals(j); 
       
       % solve MF = V for F
       [~, F] = Force(b,N);
       
       % store the norm of the solution
       NF(i,j) = norm(F);
       
       % collect the y-component of the force
       Fy = F(2:2:2*N);

       plot(x, Fy)
       hold on 
       legendInfo{j} = ['N=' num2str(N) ', b=' num2str(b)];
    end
legend(legendInfo);
xlabel('xi/xN'); ylabel('F')
title(['Plot of Force as a Function of xi/xN for N =' num2str(N)]) 
print(['Plot_of_Force_N' num2str(N)],'-dpng');
hold off

end


array2table(NF, 'RowNames',{'b=2','b=4','b=10'},'VariableNames', {'N_100','N_200','N_400'})