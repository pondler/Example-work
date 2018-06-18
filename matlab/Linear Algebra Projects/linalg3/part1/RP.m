function [R, CS] = RP (R) 
% function to calculate R (of the QR decomposition) and store the givens rotation values for a
% tridiagonal matrix R. For use in the implicit RQ multiplication in
% wilkinsonQR


N = length(R); 

CS = zeros(N - 1, 2); 

for j = 1 : N - 1 
   
   % calculate givens rotations between diagonal and sub diagonal terms
   [c,s] = givens(R(j, j), R(j + 1, j)); 
   
   P = [c s; -s c]; 
   
   % carry out the rotation to push terms below the main diagonal above the
   % main diagonal
   R([j, j + 1], j:min(j + 2, N)) = P' *  R([j, j + 1], j:min(j + 2, N));
   
   CS(j,:) = [c,s];
   
end

% Q = eye(N); 
%for  j =  1 : N - 1
%    
%    P = [CS(j, 1), CS(j, 2); - CS(j, 2), CS(j, 1)]; 
%
%    Q(:, [j, j + 1]) = Q(:, [j, j + 1]) * P;
%end
