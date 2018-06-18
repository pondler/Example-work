function red_mls = reduced_MLSpoly(n)
% function computing the MLS polynomial weighted for a reduced percentage of the
% original data set
% n: sample size, e.g n = 601 of the original

load tycho

% set constant values
deg = 3;
eta = 1e-3;

% preallocate
red_mls = zeros(length(x),1);
x_red = zeros(length(x),1);

% use the bool_rand flag to construct the downsampled data set from x
n = floor(length(x)/n);
index_sample = downsample(1:length(x),n);
x_red(index_sample) = x(index_sample);


% augment the loop as in MLSpoly to carry out the same algorithm for
% loop through data points
for i = 1:length(x)
  w = red_weightVec(x_red,i,eta); % evaluate the weight vector at xi
  % this time the weight matrix is created for the downsampled data set
  wls = weightedls(deg,w); % run the weighted least squares with weights at xi
  red_mls(i) = wls(i); % set the value to the ls at i
end
