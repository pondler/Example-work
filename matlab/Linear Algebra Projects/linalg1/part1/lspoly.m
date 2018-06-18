function [lsp] = lspoly(n)

% main function computing the n^th degree least squares polynomial for h 

load('tycho.mat') % loads in tycho data, stores x and h

A = vmon(x,n+1);% create the Vandermonde Matrix from x


[V, R] = house(A); % perform Householder transformation on A

b = Qadjh(V,h); % computes Q*h and stores the vector in Rx

coeff = backsub(R,b); % use backsub to find coefficients of lsq polynomial

% create polynomial fits of various degrees by matrix multiplication using
% the vandermonde matrix and coefficients
lsp = A*coeff;
end
