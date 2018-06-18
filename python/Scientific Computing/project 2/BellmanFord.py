import numpy as np
import scipy as sp
import sys

def BellmanFord(ist,isp,wei):
    #----------------------------------
    #  ist:    index of starting node
    #  isp:    index of stopping node
    #  wei:    adjacency matrix (V x V)
    #
    #  shpath: shortest path
    #----------------------------------

    V = wei.shape[1]

    # step 1: initialization
    Inf    = sys.maxint
    d      = np.ones((V),float)*np.inf
    p      = np.zeros((V),int)*Inf
    d[ist] = 0

    # step 2: iterative relaxation
    for i in range(0,V-1):
        for u in range(0,V):
            for v in range(0,V):
                w = wei[u,v]
                if (w != 0):
                    if (d[u]+w < d[v]):
                        d[v] = d[u] + w
                        p[v] = u

    # step 3: check for negative-weight cycles
    for u in range(0,V):
        for v in range(0,V):
            w = wei[u,v]
            if (w != 0):
                if (d[u]+w < d[v]):
                    print('graph contains a negative-weight cycle')

    # step 4: determine the shortest path
    shpath = [isp]
    while p[isp] != ist:
        shpath.append(p[isp])
        isp = p[isp]
    shpath.append(ist)

    return shpath[::-1]