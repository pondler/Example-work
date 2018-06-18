import numpy as np
def compress(F2d,C):
    """ Compresses 2D image. P determined by solving C*mn = m*P + P*1 + P*n to match the compressed size of the array to the sum of the three elements creaed.
    """
    m,n = F2d.shape
#   Make sure parameter is in the boundary
    assert (0<C<1), "Ensure compression parameter C is in (0,1)"
    
#   Initialise the first SVD composition
    U, s, V = np.linalg.svd(F2d, full_matrices=False)
    
#   Determine P
    P = int(np.floor(C*m*n/(m+n+1)))
    
    U = U[:,:P]
    s =s[:P] 
    V = V[:P,:]
    
    return U, s, V 