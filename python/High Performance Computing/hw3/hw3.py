"""CHRISTOPHER MCLEOD, CID: 00947553
"""
import numpy as np
import matplotlib.pyplot as plt
from n1 import network as net
 
   
def visualize(e):    
    """Visualize a network represented by the edge list
    contained in e
    """
#   get dimensions of the edge list
    N, _ = np.shape(e)
    K = np.max(e)
    
#   pick K random co-ordinates in space for the nodes
    x = np.random.uniform(0,1, K)
    y = np.random.uniform(0,1, K)
    
#   run down the edge list
    for n in range(N):
#   take edges between i<->j in e
        i,j = e[n,:]
#       link the random nodes to co-ordinates in e and draw lines between them
        plt.plot([x[i-1], x[j-1]], [y[i-1], y[j-1]], 
		marker = 'o', lw = '0.2', color = 'k')
        

def degree(N0,L,Nt,display=False):
    """Compute and analyze degree distribution based on degree list, q,
    corresponding to a recursive network (with model parameters specified
    as input). The functional form of the the plot follows a negative
    y=a+1/x trend.
    """
#   call generate and extract qmax
    qmax = net.generate(N0,L,Nt)
    
#   create d, the array of degrees upto qmax
    d = np.array(range(qmax))
    
#   run over d and remove values that have degree 0
#   at the end, put d in order
    for n in d:
            if (n not in net.qnet):
                d = d[d != n ]
    d = np.sort(d)

#   initialise P as zeros with the dimension of d
    P = np.zeros(np.size(d))

#   count repititions of node degrees
    for j in net.qnet:
        P[d == j] = P[d == j] + 1

#   normalise P
    P = P/np.sum(P)

#   create plot
    if display:
        
        trunc = int(np.floor(np.size(P)/2))
        Ptrunc = P[:trunc]
        dtrunc = d[:trunc]
        
#       polyfit a polynomial of deg=1 approximating a negative exp function
        mu,rem = np.polyfit(dtrunc, np.log(Ptrunc),1)

#       plot bar chart and overlay the approximation
        plt.figure()
        plt.grid()
        plt.plot(d,np.exp(mu*d+rem), 'r')
        plt.bar(d,P, label='P(d)')
        plt.title('CHRIS MCLEOD, via degree(5,2,4000)')
        plt.xlabel('d')
        plt.ylabel('P')
        plt.legend(loc='best')
        plt.show()


    return d, P
            

    
#if __name__ == "__main__":
#    degree(5,2,4000,True)
    
