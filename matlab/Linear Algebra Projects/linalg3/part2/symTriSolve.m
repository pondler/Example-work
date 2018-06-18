function w = symTriSolve (R, v)

N = length(v); 

% rotate to eliminate the first diagonal below the main by pushing the
% terms above the diagonal 
for j = 1 : N - 1 

   [c, s] = givens(R(j, j), R(j + 1, j));

   P = [c s; -s c];
   
   % multiply the affected sub-matries to 0 the 1st sub diagonal entries
   R([j, j + 1], :) = P' *  R([j, j + 1], :);
   
   % compute givens rotations on the right hand side implicitly on
   % submatrices which are affected   
   v(j: j + 1) = P' * v(j: j + 1);

end

% perform banded back substitution
w = bandBacksub(R, v, 3); 
