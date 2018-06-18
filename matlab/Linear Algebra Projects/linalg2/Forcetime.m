function [t, grad] = Forcetime() 

% function to plot yForce algo-time for increasing N 
%
% Input: NULL 
%
% Output: t - 5x1 vector of run-time for prescribed N, b=4
%         grad - gradient of linear regression through log-time points

Nvals = [100; 200; 400; 800; 1600];
b = 4; 
t = zeros(5,1); 


for i=1:5
    N = Nvals(i);
    % call Force and store the run-time for this N 
    [t(i), ~] = Force(b,N);
end

% create log-log plot 
figure()
plot(log(Nvals), log(t))
xlabel('log N')
ylabel('log algo-time')
title(['log-log plot of N against Force run-time for b=' num2str(b)])
print('log-log_plot_Force','-dpng');

%  linear regression thorough the log-log plot
lin_reg = polyfit(log(Nvals),log(t), 1);

% get gradient of linear regression
grad = lin_reg(1);