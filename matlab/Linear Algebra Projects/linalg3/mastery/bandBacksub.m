function [b] = bandBacksub(R,b,bw)
% function to solve Rc = b for c where R is a an upper triangular matrix
% computed in the QR decomposition of a banded symmetric matrix of bandwith
% bw

% store dimensions of matrices
N = size(R,2);

% follow normal backsubsitution method to overwrite b with updated values
for j = N: -1: 1
    b(j) = b(j) / R(j, j);
    % only carry out the necessary number of multiplications
    for k = max(1, j - bw): j - 1
        b(k) = b(k) - R(k, j) * b(j); 
    end
end




