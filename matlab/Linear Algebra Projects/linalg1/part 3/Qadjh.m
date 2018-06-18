function [h] = Qadjh(V,h)
% function to perform Q*h using Householder reflections and h.

% get dimensions of V 
m = size(V,1);
n = size(V,2);
 
% perform algo from lectures
for k = 1:n
  v = V(:,k);
  v = v(k:m);
  h(k:m) = h(k:m) - (2.0)*v*(v'*h(k:m));
end
