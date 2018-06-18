
% script to collate run-times of thet hree solves of MF=V for F and create
% a 'speed up' matrix to analyze performance increase and demonstratie plot
% WARNING: this script will take a *very* long time, Forcetime alone can take 8 mins 

T = zeros(3,5);
S = zeros(3,5); 

% call each function to get the time taken for the algo to run for each
% N value
[T(1,:), ~] = Forcetime();
[T(2,:), ~] = fastForce(false);
[T(3,:), ~] = levinsontime(false); 

% calculate speed-up ratios
S(1,:) = T(1,:)./T(2,:);
S(2,:) = T(2,:)./T(3,:); 
S(3,:) = T(1,:)./T(3,:); 


% display results in tables 
A1 = array2table(T, 'RowNames',{'Force','fastForce','levinson'}, ...
               'VariableNames', {'N_100','N_200','N_400','N_800','N_1600'})

A2 = array2table(S, 'RowNames',{'Force/fastF','fastF/levin','Force/levin'}, ...
               'VariableNames', {'N_100','N_200','N_400','N_800','N_1600'}) 
           
% make a log-log plot of the results 
Nvals = [100; 200; 400; 800; 1600]; 
algos = char('parpivgelim','fastForce','levinson'); 
legendInfo = cell(3,1); 

for j=1:3   

   plot(log(Nvals), log(T(j,:)))
   hold on 
   legendInfo{j} = algos(j,:);
end

legend(legendInfo);
xlabel('log N')
ylabel('log algo-time')
title('log-log plot of N against algorithm run-time for b=4')
print('log-log_plot_timecomparison','-dpng');


hold off 

