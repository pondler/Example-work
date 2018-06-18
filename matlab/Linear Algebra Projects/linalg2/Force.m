function [t,F]= Force(b,N) 

% Function to solve for F in the 2Nx2N system MF = V for the prescribed 
% values of N and b as well as record the time taken 
%
% Input: b - spacing parameter (of particles) 
%        N - number of particles
%
% Output: t - vector of recorded algorithm run-time
%         F - vector of force solutions

% create velocity vector
V = ones(2*N,1);
V(1:2:2*N) = 0.0;

% make M
M = Msetup(b,N); 

tic 

% decompose M using partial pivot LU decomposition
[L, U, P] = parpivgelim(M);

% solve system LUF = PV
UF = fwdsub(L,P*V);
F  = backsub(U,UF); 

t = toc;

