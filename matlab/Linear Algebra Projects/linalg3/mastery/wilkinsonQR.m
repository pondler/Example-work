function [evals, T, t] = wilkinsonQR (T)

if length(T) == 1 

    evals(1) = T(1,1); 

else
    
    while abs(T(end , end - 1)) > 1e-16 * (abs(T(end - 1, end - 1)) + abs(T(end, end)))

        d = 0.5 * (T(end, end) - T(end - 1, end - 1)); 

        if d == 0
    
            mu = T(end, end) - abs(T(end, end - 1)); 
      
        else
            
            mu = T(end, end) - sign(d) * T(end, end - 1)^2 / (abs(d) + sqrt(d^2 + T(end, end - 1)^2));
       
        end 
        
        muI = mu * eye(length(T));
        T = T - muI; 
        
        % get upper tri matrix and Given's permutation matrices
        tic 
        [R, CS] = RP(T);

        % implicit RQ calculation
        for j = 1 : length(T) - 1
        
            P = [CS(j, 1), CS(j, 2); - CS(j, 2), CS(j, 1)]; 
        
            R(:, [j, j + 1]) = R(:, [j, j + 1]) * P;    
        
        end
        
        t = toc;
        
        T = R  + muI;

    end
    
    evals = [T(end, end); wilkinsonQR(T(1:end-1, 1:end-1))];

end
