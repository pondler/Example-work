function y = fwdsub(L,b)
% function to solve Ly=b for the column vector y, where L is lower
% triangular
%
% Input: L - lower triangular matrix 
%        b - vector of knowns in linear system
%
% Output: y - determined vector of unknowns in linear system

% store dimensions of matrices
n = size(L,2);
y = zeros(n,1);

% solve first linear equation
y(1) = b(1)/L(1,1);

% follow normal forwardsubsitution method to overwrite y with updated values
for k = 2:n
  y(k) = (b(k)-dot(L(k,1:k-1),y(1:k-1)))/L(k,k);
end

    