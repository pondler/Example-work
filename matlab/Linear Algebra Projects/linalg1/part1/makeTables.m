% Script for making tables of monomial coefficients and least squares differences
% for the prescribed values of n

load('tycho.mat')

% calculate and truncate the h(x_i)
y = lspoly(5);
y_t = y(1:6);


% create a vector for the degrees of the polynomials
degvals = [5 10 20];

% take the code used earlier to generate the coefficients and put them in a for
% loop to store them in a row of a matrix for each value of n
coeff = zeros(3,6); % preallocate an empty matrix to store the coefficients

for i=1:3
  deg = degvals(i);
%-------------------------old-code------------------------
  A = vmon(x,deg+1);
  [V, R] = house(A);
  b = Qadjb(V,h);
  ncoeff = backsub(R,b);
%-------------------------old-code------------------------
  coeff(i,:) = ncoeff(1:6);
end

% create table 1 of the monomial coefficient values
T_coeff = table(degvals', coeff(:,1),coeff(:,2),coeff(:,3),coeff(:,4),coeff(:,5),coeff(:,6));
T_coeff.Properties.VariableNames = {'deg', 'c0', 'c1', 'c2', 'c3', 'c4', 'c5'};
T_coeff.Properties.Description = 'Table of first six monomial coefficients for LS polys';

T_coeff

% calculate the L2 degorm of the least squares polynomials vs the actual height data
err5 = norm(lspoly(5)-h,2);
err10 = norm(lspoly(10)-h,2);
err20 = norm(lspoly(20)-h,2);

% create a table describing the error in the least squares polynomials for different n
T_err = table(degvals',[err5; err10; err20]);
T_err.Properties.VariableNames = {'deg','error'};
T_err.Properties.Description = 'Table of the error in the LS polynomial fit by degree';

T_err
