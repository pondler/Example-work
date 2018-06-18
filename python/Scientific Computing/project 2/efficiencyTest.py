from time import time as t 
import BellmanFord as bf
import Dijkstra as di
import copy
import numpy as np
import sys

# create adj matrix in the normal way (pathFinder.py)
zer0 = sys.float_info.min 

duration = [41,51,50,36,38,45,21,32,32,49,30,19,26]
adj = np.zeros((28,28))
amm = np.zeros(27)
amm[1::2] = duration
adj = np.diag(amm,1)
adj[0,1::2] = zer0 
adj[::2,27] = zer0 

conx = [2,2,2,4,4,6,12,14,14,20,22]
cony = [3,15,21,9,25,7,15,11,19,23,25]

adj[conx,cony] = zer0   

Wei = - copy.copy(adj)


# use system time to time Dijkstra's algorithm on pos. conn/wei matrix
t00 = t()
print 'Dijk path;', di.Dijkst(0,27,adj)
t01 = t()

# use system time to time the Bellman-Ford algorithm on neg. conn/wei matrix
t10 = t()
print 'Bell path:', bf.BellmanFord(0,27,Wei)
t11 = t()

# average the time by path length 
t0 = (t01-t00)/len(di.Dijkst(0,27,adj))
t1 = (t11-t10)/len(di.Dijkst(0,27,Wei))



if __name__ == '__main__' :
    print 'Dijkstra Takes', t0,'s'
    print 'Bellman Ford Takes', t1,'s' 
    print 'Dijkstra is', (t1/t0),'times quicker'
    