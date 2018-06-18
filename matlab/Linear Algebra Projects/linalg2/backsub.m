function [b] = backsub(R,y)
% function to solve Rb = y for b 
%
% Input: R - upper triangular matrix 
%        y - vector of knowns in linear system
%
% Output: b - determined vector of unknowns in linear system

% store dimensions of matrices
n = size(R,2);
b = zeros(n,1);

% solve first linear equation
b(n) = y(n)/R(n,n);

% follow normal backsubsitution method to overwrite b with updated values
for k = n-1:-1:1
  b(k) = (y(k)-dot(R(k,k+1:n),b(k+1:n)))/R(k,k);
end
