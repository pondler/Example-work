function w = theta(r,eta,epsilon)
% perform the modified weight calculation

theta = exp(-r^2/(eta));
if (theta < epsilon)
  theta = 0.0;
end
w = theta;
