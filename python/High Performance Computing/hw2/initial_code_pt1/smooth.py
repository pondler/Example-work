def smooth(F):
    """ Apply a simple smoothing procedure to image matrix F
    """
    import numpy as np
    m, n, k = F.shape
    for i in range(k):

# 	average for cells surrounded by 8 others

        C = F[1:m-1,1:n-1,i]
        for ind, value in np.ndenumerate(C):
            C[ind[0],ind[1]]=(1/9)*(int(value)+int(F[ind[0]+1,ind[1],i])+int(F[ind[0]-1,ind[1],i])+int(F[ind[0],ind[1]+1,i])+int(F[ind[0],ind[1]-1,i])+int(F[ind[0]+1,ind[1]+1,i])+int(F[ind[0]-1,ind[1]+1,i])+int(F[ind[0]-1,ind[1]-1,i])+int(F[ind[0]+1,ind[1]-1,i]))
    	
# 	average for corners clockwise from (0,0)

        X = 0.25*(int(F[0,0,i]) + int(F[0,1,i]) + int(F[1,0,i]) + int(F[1,1,i]) )
        Y = 0.25*(int(F[m-1,0,i]) + int(F[m-1,1,i]) + int(F[m-2,0,i]) + int(F[m-2,1,i]) )
        Z = 0.25*(int(F[m-1,n-1,i]) + int(F[m-2,n-1,i]) + int(F[m-1,n-2,i]) + int(F[m-2,n-2,i]) )
        T = 0.25*(int(F[0,n-1,i]) + int(F[1,n-1,i]) + int(F[0,n-2,i]) + int(F[1,n-2,i]) )
    	
#	average for edges excluding corners clockwise from (0,0)

        N = F[0,1:n-1,i]
        for ind, value in np.ndenumerate(N):
            N[ind[0]] = (1/6)*(int(value)+int(F[0+1,ind[0],i])+int(F[0,ind[0]+1,i])+int(F[0,ind[0]-1,i])+int(F[0+1,ind[0]+1,i])+int(F[0+1,ind[0]-1,i]))
        E = F[1:m-1,0,i]
        for ind, value in np.ndenumerate(E):
            E[ind[0]] = (1/6)*(int(value)+int(F[ind[0]+1,0,i])+int(F[ind[0]-1,0,i])+int(F[ind[0],0+1,i])+int(F[ind[0]+1,0+1,i])+int(F[ind[0]-1,0+1,i]))
        S = F[m-1,1:n-1,i]
        for ind, value in np.ndenumerate(S):
            S[ind[0]] = (1/6)*(int(value)+int(F[m-1-1,ind[0],i])+int(F[m-1,ind[0]+1,i])+int(F[m-1,ind[0]-1,i])+int(F[m-1-1,ind[0]+1,i])+int(F[m-1-1,ind[0]-1,i]))
        W = F[1:m-1,n-1,i]
        for ind, value in np.ndenumerate(W):
            W[ind[0]] = (1/6)*(int(value)+int(F[ind[0]+1,n-1,i])+int(F[ind[0]-1,n-1,i])+int(F[ind[0],n-1-1,i])+int(F[ind[0]+1,n-1-1,i])+int(F[ind[0]-1,n-1-1,i]))
    	
# 	Reassign F 

        F[1:m-1,1:n-1,i] = C
        F[0,1:n-1,i] = N
        F[1:m-1,0,i] = E
        F[m-1,1:n-1,i] = S
        F[1:m-1,n-1,i] = W
        F[0,0,i] = X
        F[m-1,0,i] = Y
        F[m-1,n-1,i] = Z
        F[0,n-1,i] = T
    
# 	Normalise F

    big = F.max()
    F = (1/big)*F
    return F