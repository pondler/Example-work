"""CHRISTOPHER R MCLEOD 00947553
"""
import numpy as np
import matplotlib.pyplot as plt
from ns import netstats as ns 


def convergence(n0,l,nt,m,numthreads,display=False):
    """test convergence of qmaxm"""
#    call stats and initialise variables
    qnetm,qmaxm,qvarm = ns.stats(n0,l,nt,m)
    qmax_ave = np.zeros(m)
    qmax_vec = np.zeros(m)

#   assign qmax_vec the qmax of qnetn value for n=1->m realizations
#   assign qmax_ave the value of the avegerage over the n realizations of qmax  

    for n in range(1,m+1):
        qmax_vec[n-1] = float(np.amax(qnetm[:,n-1]))
        qmax_ave[n-1] = np.sum(qmax_vec)/(n)
    
    x = np.arange(1,m+1)

#   use polyfit to solve for k and a satisfying qmax_ave = a*m**(-k)
#   reduce problem to log(qmax_ave) = c - k*log(m) (c = log(a), and flip sgn(k) for now)

    k, c = np.polyfit(np.log(x),np.log(qmax_ave),1)

#   if display flag is true, create log-log plot of qmax_ave vs x=1->m 

    if display:
        #plt.figure()
        #plt.loglog(x,qmax_ave,'b')
        #plt.loglog(x,np.exp(b+k*x),'r')
        #plt.show()
        
        plt.figure()
        plt.plot(np.log(x),np.log(qmax_ave),'b')
        plt.plot(np.log(x),c + k*np.log(x),'r')
        plt.xlabel('log(x) x=1->m')
        plt.ylabel('log(qmax_ave)')
        plt.title('log-log plot of m against qmax_ave with rate of convergence fit')
        plt.legend(loc='best')
        plt.show()

    return -k
     
def speedup(n0,l,ntarray=np.arange(100),marray=np.arange(100)):
    """test speedup of stats_par. Results show speed up increasing with m and nt in a logarithmic fashion.
    Last graph is comparative, showing the speedup is greater for a high number of realizations than number of nodes added
    for large values. The converse is true for small values (say <50 in the default case)"""

#   initialise variables

    Sup_m2 = np.zeros(np.size(marray))
    Sup_m3 = np.zeros(np.size(marray))
    Sup_m4 = np.zeros(np.size(marray))
    Sup_nt2 = np.zeros(np.size(ntarray))
    Sup_nt3 = np.zeros(np.size(ntarray))
    Sup_nt4 = np.zeros(np.size(ntarray))

#   fix nt at the meadian value of ntarray
#   run test_stats_omp over the range of marray to collect the walltimes for one and two threads
#   calculate the speed up and store it in Sup_mi where i is the number of threads

    nt = int(np.around(np.mean(ntarray)))
    for m in np.arange(1,np.size(marray)+1):
        wall_1thread = ns.test_stats_omp(n0,l,nt,m,1)
        wall_2thread = ns.test_stats_omp(n0,l,nt,m,2)
        wall_3thread = ns.test_stats_omp(n0,l,nt,m,3)
        wall_4thread = ns.test_stats_omp(n0,l,nt,m,4)
        Sup_m2[m-1] = wall_1thread/wall_2thread
        Sup_m3[m-1] = wall_1thread/wall_3thread 
        Sup_m4[m-1] = wall_1thread/wall_4thread 
        
#   fix m at the median value of marray
#   run test_stats_omp over the range of ntarray to collect the walltimes for one and two threads
#   calculate the speed up and store it in Sup_nti where i is the number of threads

    m = int(np.around(np.median(marray)))
    for nt in np.arange(1,np.size(ntarray)+1):
        wall_1thread = ns.test_stats_omp(n0,l,nt,m,1)
        wall_2thread = ns.test_stats_omp(n0,l,nt,m,2)
        wall_3thread = ns.test_stats_omp(n0,l,nt,m,3)
        wall_4thread = ns.test_stats_omp(n0,l,nt,m,4)
        Sup_nt2[nt-1] = wall_1thread/wall_2thread
        Sup_nt3[nt-1] = wall_1thread/wall_3thread
        Sup_nt4[nt-1] = wall_1thread/wall_4thread

#   make sure marray and ntarray are suitable to create a plot

    m = np.arange(1,np.size(marray)+1)
    nt = np.arange(1,np.size(ntarray)+1)

#   plot Sup_nti against nt 

    plt.figure()
    plt.plot(m, Sup_nt2, 'b', label ='2 Threads')
    plt.plot(nt, Sup_nt3,'r', label ='3 Threads')
    plt.plot(nt, Sup_nt4, 'g', label ='4 Threads')
    plt.xlabel('number of realizations')
    plt.ylabel('speedup')
    plt.title('plot of speedup vs number of realizations')
    plt.legend(loc='best')
    plt.show()

#   plot Sup_mi against m

    plt.figure()
    plt.plot(m, Sup_m2, 'b', label ='2 Threads')
    plt.plot(nt, Sup_m3,'r', label ='3 Threads')
    plt.plot(nt, Sup_m4, 'g', label ='4 Threads')
    plt.xlabel('number of new nodes')
    plt.ylabel('speedup')
    plt.title('plot of speedup vs number of new nodes')
    plt.legend(loc='best')
    plt.show()
    
#   plot Sup_nt4 and Sup_m4 against nt and m to compare which has the greater effect
    
    plt.figure()
    plt.plot(nt, Sup_nt4, 'b', label='varying nt 4 threads')
    plt.plot(m, Sup_m4, 'r', label='varying m 4 threads')
    plt.xlabel('number of realizations/new nodes')
    plt.ylabel('speedup')
    plt.title('comparison of speedup when varying m to speed up when varying nt')
    plt.legend(loc='best')


def degree_average(n0,l,nt,m,display=False):
    """compute ensemble-averaged degree distribution"""	

#   initialise variables

    P = np.zeros((n0+nt,m))
    Pave = np.zeros((n0+nt,m))
    PD = np.zeros((n0+nt,m))
    
#   call stats to assing qnetm
        
    qnetm, _, _ = ns.stats(n0,l,nt,m)

#   create Pave 
#   extract the unique list of qnet values from n=1->m realizations 
#   take the average degree over the n realizations 

    for n in range(m):
        P,Q = np.unique(qnetm[:,n],return_counts=True)
        for k in range(len(P)):
            PD[P[k],n] = Q[k]

#   normalize Pave and remove zeros
                
    Pave = np.mean(PD, axis=1)/(n0+nt)
    Pave = Pave[Pave>0]
    
#   declare our domain of 1->Pave realizations

    x = np.arange(1,np.size(Pave)+1)

#   seek to solve for k and a satisfying Pave = a*x**(-b)
#   reduce problem to log(Pave) = c - k*log(x) (c = log(a), and flip sgn(b) for now)

    b,c = np.polyfit(np.log(x), np.log(Pave), 1)

#   create log-log plot for when display is true

    if display:
        plt.figure()
        plt.plot(np.log(x), np.log(Pave), 'b')
        plt.plot(np.log(x), c + b*np.log(x), 'r')
        plt.xlabel('log(x) x=1->size(Pave)')
        plt.ylabel('log(Pave)')
        plt.title('log-log plot of x against Pave with power law fit')
        plt.legend(loc='best')
        plt.show()

    return -b 
    
if __name__ == '__main__':
    
    convergence(5,2,400,1000,1,True)
#    speedup takes the longest to run (~30s)
    speedup(5,2)
