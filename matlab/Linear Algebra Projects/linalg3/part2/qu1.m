
% script to produce table of return, risk and optimal investment
% percentages, as per qu1

load('PortfolioData.mat'); 

gammas = 0.1: 0.1: 0.9; 
ret = zeros(9, 1); 
risk = ret;
xmax = zeros(9,2);

for j = 1: 9
    
    gamma = gammas(j); 
    
    [ret(j), risk(j), x, ~] = PortfolioOpt(gamma, pbar, sigma, true, false, false); 
    
    x = sort(x, 'descend');
    xmax(j,:) = x(1:2); 
  
end


tbl = table(gamma, ret, risk, xmax)