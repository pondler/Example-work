function w = weightVec(x, i, eta, epsilon)

  xi = x(i);
  % initialise the weight vector
  w = zeros(length(x),1);

  % calculate maximum distance of an xj to xi
  r_max = sqrt(-eta*log(epsilon));
  % calculate what the furthest xj are in each direction from xi
  x_max = min(xi + r_max,x(end));
  x_min = max(xi - r_max,x(1));

  % logical index x to get the non-zero silce of the weight vector
  nz_slice = x((x>=x_min) & (x<=x_max));
  nz1 = find(x == nz_slice(1));

  % loop through x to create the weighted entries
  for j = 1:length(nz_slice)
    xj = nz_slice(j); % set the jth point
    r = abs(xi-xj); % calculate distance to xi
    theta_j = exp(-r^2/(eta)); % calculate the weighting
    % of xj with respect to xi
    w(nz1 + j - 1) = theta_j; % assign to row of W
  end
