function [w] = pentDiagSolve (R, v)
% function to solve the pentadiagonal system Rw = v for w (R is
% pentadiagonal) using givens rotations to transform R to an upper
% triangular matrix to then be solved by banded back substitution

N = length(v); 

% rotate to eliminate the second diagonal below the main
for k = 1 : N - 2
    
   [c, s] = givens(R(k + 1, k), R(k + 2, k));  

   P = [c s; -s c]; 
    
   % multiply the affected sub-matries to 0 the 2nd sub diagonal entries
   R([k + 1, k + 2], k:min(k + 5, N)) = P' *  R([k + 1, k + 2], k:min(k + 5, N));
   
   % compute givens rotations on the right hand side implicitly on
   % submatrices which are affected
   v(k + 1: k + 2) = P' * v(k + 1: k + 2);

end

% rotate to eliminate the first diagonal below the main
for j = 1 : N - 1 

   [c, s] = givens(R(j, j), R(j + 1, j));

   P = [c s; -s c];
   
   % multiply the affected sub-matries to 0 the 1st sub diagonal entries
   R([j, j + 1], j:min(j + 7, N)) = P' *  R([j, j + 1], j:min(j + 7, N));
   
   % compute givens rotations on the right hand side implicitly on
   % submatrices which are affected
   v(j: j + 1) = P' * v(j: j + 1);

end

% perform banded back substitution
w = bandBacksub(R, v, 5); 
