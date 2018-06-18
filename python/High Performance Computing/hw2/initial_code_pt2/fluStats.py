def fluStats(t,y,i1,i2):
    """Compute mean and variance for data within the range, t[i1]<=t<t[i2]
    provided the size Nt array, t and size Nt x 4 array y which contains 
    S(t),E(t),C(t),R(t)
    """
#   Require sensible assertions about i1,i2
    assert (i1<i2), 'Error: i2 must be larger than i1'
    assert (i1=>0), 'Error: i1 must not be negative'
    assert (i2<=Nt), 'Error i2 must be in range of time sample'

#   Slice the solution between i1 and i2 
    yi = y[(t>i1) and (t<i2)
    ]
#   Compute mean for each solution
    yMean = np.zeros(4)
    for i in range(4):
        yMean[i] = np.average(yi[:,i])
#   Do the same for the variation
    yVar = np.zeros(4)
    for i in range (4):
        yVar[:,i] = np.var(yi[:,i])
    
    return yMean, yVar