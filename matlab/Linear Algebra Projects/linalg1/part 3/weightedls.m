function wls = weightedls(deg,w)
% compute the weighted least squares at the point xi
%load in data
load('tycho.mat')

% create the vandermonde matrix as usual
A = vmon(x,deg+1);
% diagonalise the weight vector
W = diag(w);

% Weight the vandermonde matrix and height vectors
WA = W*A; 
Wh = W*h;

% calculate the householder, QR decompostion and backsub in the regular way
[V,R] = house(WA); % perform householder decomposition
b = Qadjh(V,Wh); % multiply rhs by Q* (the adjoin of Q)
w_coeff = backsub(R,b); % use backsubstitution to find coefficients

wls = A*w_coeff; % finally multiply by vandermonde mat to find wls polynomial
