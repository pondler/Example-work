function MLSp = MLSpoly(deg, eta, epsilon)
% function to perform moving least squares, i.e weighted least squares at every point

% load data
load('tycho.mat')

% initialise the output vector
MLSp = zeros(length(x),1);

% loop through data points
for i = 1:length(x)
  w = weightVec(x,i,eta,epsilon); % evaluate the weight vector at xi
  wls = weightedls(deg,w); % run the weighted least squares with weights at xi
  MLSp(i) = wls(i); % set the value to the ls at i
end
