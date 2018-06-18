import numpy as np
def regularsvd(F2d):
    """
    Created on Sat Nov  5 14:52:39 2016

    @author: Jzorde
    """
    U, s, V = np.linalg.svd(F2d)
    m,n = F2d.shape
    S = np.zeros((m,n))
    p = len(s)
    S[:p,:p] = np.diag(s)
    
    return U@S@V