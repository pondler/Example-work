function w = red_weightVec(x_red, i, eta)
   
load tycho

xi = x(i);
w = zeros(length(x),1);

for j = 1:length(x)
    xj = x_red(j); % set the jth point
    if abs(xj)>0.0001
        r = abs(xi-xj); % calculate distance to xi
        theta_j = exp(-r^2/(eta)); % calculate the weighting
        % of xj with respect to xi
        w(j) = theta_j; % assign to row of W
    end
end
