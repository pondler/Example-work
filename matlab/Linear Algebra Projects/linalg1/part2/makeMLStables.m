% Script for making tables of monomial coefficients and least squares differences
% for the prescribed values of n

load('tycho.mat')

% create a vector for the degrees of the polynomials
degvals = [1 3 10];
etavals = ['10^-2'; '10^-3'; '10^-4'];

% calculate the L2 norm of the least squares polynomials vs the actual height data
d1 = norm(MLSpoly(1,1e-3,1e-6)-h,2);
d3 = norm(MLSpoly(3,1e-3,1e-6)-h,2);
d10 = norm(MLSpoly(10,1e-3,1e-6)-h,2);

% create a table describing the error in the MLS polynomials for different deg
degVary = table(degvals',[d1; d3; d10]);
degVary.Properties.VariableNames = {'deg','error'};
degVary.Properties.Description = 'Table of errors between MLS data and actual, where degree is varied';

degVary

eta2 = norm(MLSpoly(3,1e-2,1e-6)-h,2);
eta3 = norm(MLSpoly(3,1e-3,1e-6)-h,2);
eta4 = norm(MLSpoly(3,1e-4,1e-6)-h,2);

% create a table describing the error in the MLS polynomials for different eta
etaVary = table(etavals,[eta2; eta3; eta4]);
etaVary.Properties.VariableNames = {'eta','error'};
etaVary.Properties.Description = 'Table of errors between MLS data and actual, where degree is varied';

etaVary
