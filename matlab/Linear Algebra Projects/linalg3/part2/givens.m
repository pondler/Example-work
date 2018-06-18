function [c,s] = givens (a,b)
% function to calculate the givens roation values to rotate (a,b) -> (r,0)

if b == 0
    c = 1; s = 0;
elseif abs(b)>abs(a)
    t = -a/b;
    s = 1/sqrt(1+t^2); 
    c = s*t;
else
    t = -b/a;
    c = 1/sqrt(1+t^2); 
    s = c*t;
end