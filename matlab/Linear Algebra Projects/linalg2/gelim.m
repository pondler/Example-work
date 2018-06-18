function [L, U] = gelim(A)

% function to compute the LU decomposition of an mxm matrix, such that 
% LU = A. adapted from parpivgelim code
%
% Input: A - m x m matrix.
%
% Outputs: L - m x m unit lower triangular matrix
%          U - m x m upper triangular matrix


M = size(A,1); % get dimensions of A

% Initialize U, L, and P.
U = A; 
L = eye(M);

for k = 1:M-1     
    for j = k+1:M
        Ljk = U(j,k)/U(k,k); %obtain entry L_ik 
        U(j,k:M) = U(j,k:M) - Ljk*U(k,k:M); % multiplication of jth row by matrix L_k
        L(j,k) = Ljk;
    end
end