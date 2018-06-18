import numpy as np
import matplotlib.pyplot as plt
def linearFit(b0=5):
    """Estimate initial exponential growth rate for C(t) and 
    display actual and estimated growth vs. time
    """
#   Set assigned values
    T, Nt, a , b1, k, g, y0 = 10, 1000, 1.0, 0.2, 0.1, 0.2, [0.997,0.001,0.001,0.001]

#   Solve system and grab soln to C
    t,y = solveFlu(T,Nt,a,b0,b1,g,k,y0)
    C = y[2]

#   Extract the initial part of the solution, C1, where C<= 0.1
    C1 = C[C<=0.1]
    
#   Use polyfit with degree 1 to find the coefficients of the expected contagious C1(t)~exp(mu*t+rem) 
    mu,rem = np.polyfit(t[:len(C1)],np.log(C1),1)

#   Take the log of C and plot the semilog graps of C,exp(mu*t+rem) against t
    logC = np.log(C)
    
    plt.figure()
    plt.plot(t,logC,label='actually contagious')
    plt.plot(t,mu*t+rem,label='expected contagious')
    plt.xlabel('time')
    plt.ylabel('log of population')
    plt.title('semilog plot of expected contagious population and actually contagious against time')
    plt.legend(loc=0)

#   lastly, return mu
    return mu