function T12 = pRoot(T)

% function to find the principal root of matrix T by T = X * D * X^T for X 
% orthogonal, D diagonal in the standard way 

% find evals
[evals, ~] = wilkinsonQR(T); 

% compute D12 such that T^0.5 = Q * D12 Q
D12 = diag(sqrt(evals)); 

% use inverse iteration to get the orthogonal eigenvalue matrix
X = invItr(T, evals);

% compute T ^ 0.5
T12 = X * D12 * X';
