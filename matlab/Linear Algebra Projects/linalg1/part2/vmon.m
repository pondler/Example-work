function B = vmon(x,n)
% function to create the nth degree Vandermonde matrix

% preallocate
B = zeros(length(x),n);

% construct the matrix
for i=1:n
    B(:,i) = x.^(i-1);
end
