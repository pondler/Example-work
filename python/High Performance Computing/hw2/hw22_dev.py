"""Homework 2, part 2, Christopher McLeod, 0947553"""

import numpy as np
from scipy import integrate
import matplotlib.pyplot as plt

def solveFlu(T,Nt,a,b0,b1,g,k,y0):
    """Obtains solution to Flu model from t=0 to t=T with
initial conditions, y0, and model parameters, a,b0,b1,g,k.
    """
#   create time vector and define time dependent disease transmission rate
    t = np.linspace(0,T,Nt)
    
#   define disease system as a function over an array
    def Flu(F,t):
        b = b0 + b1*(1 + np.cos(2*(np.pi)*t))

        Si = F[0]
        Ei = F[1]
        Ci = F[2]
        Ri = F[3]

        F0 = k*(1-Si) - b*Ci*Si
        F1 = b*Ci*Si - (k+a)*Ei
        F2 = a*Ei - (g+k)*Ci
        F3 = g*Ci - k*Ri
        
        return [F0,F1,F2,F3]

#   use odeint to solve this system
    soln = integrate.odeint(Flu,y0,t)
    
    return t, soln[:,0],soln[:,1],soln[:,2],soln[:,3]
    
    
def displaySolutions(t,y):
    """Plot time series and phase plane for the numerical solution;
    input variable y contains S(t),E(t),C(t),R(t)
    """     
#   y = soln
#   slice individual solutions from solution array   
#   S = y[:,0]
    E = y[:,1]
    C = y[:,2]
 #  R = y[:,3]

#   plot C against t
    plt.figure()
    plt.grid()
    plt.plot(t,C, label='Contagious')
    plt.xlabel('time after outbreak')
    plt.ylabel('Fraction of population')
    plt.title('Christopher McLeod via displaySolutions: Fraction of Contagious population against time')
    plt.legend(loc='best')

#   plot phase plane of E and C
    plt.figure()
    plt.grid()
    plt.plot(C,E,)
    plt.xlabel('Fraction of Contagious population')
    plt.ylabel('Fraction of Exposed population')
    plt.title('Christopher McLeod via displaySolutions: Phase plane of Exposed against Contagious')
#   plt.legend(loc='best')

    
def linearFit(b0=5):
    """Estimate initial exponential growth rate for C(t) and 
    display actual and estimated growth vs. time
    """
#   set assigned values
    T, Nt, a , b1, k, g, y0 = 10, 1000, 1.0, 0.2, 0.1, 0.2, [0.997,0.001,0.001,0.001]

#   solve system and grab soln to C
    t,y = solveFlu(T,Nt,a,b0,b1,g,k,y0)
    C = y[:,2]

#   extract the initial part of the solution, C1, where C<= 0.1
    C1 = C[C<=0.1]
    
#   use polyfit with degree 1 to find the coefficients of the expected contagious C1(t)~exp(mu*t+rem) 
    mu,rem = np.polyfit(t[:len(C1)],np.log(C1),1)

#   take the log of C and plot the semilog graps of C,exp(mu*t+rem) against t
    logC = np.log(C)
    
    plt.figure()
    plt.grid()
    plt.plot(t,logC,label='actually contagious')
    plt.plot(t,mu*t+rem,label='expected contagious')
    plt.xlabel('time')
    plt.ylabel('log of fraction of population')
    plt.title('semilog plot of expected contagious population and actually contagious against time')
    plt.legend(loc='best')

#   lastly, return mu
    return mu

def fluStats(t,y,i1,i2):
    """Compute mean and variance for data within the range, t[i1]<=t<=t[i2]
    provided the size Nt array, t and size Nt x 4 array y which contains 
    S(t),E(t),C(t),R(t)
    """
#   Require sensible assertions about i1,i2
    assert (i1<=i2), 'Error: i2 must be larger than i1'
    assert (i1>=0), 'Error: i1 must not be negative'
    assert (i2<=Nt), 'Error i2 must be in range of time sample'

#   Slice the solution between i1 and i2 
    yi = y[(int(t[i1-1]) <= t) & (t <= int(t[i2-1]))]
           
#   Compute mean for each solution
    yMean = np.zeros(4)
    for i in range(4):
        yMean[i] = np.mean(yi[:,i])
        
#   Do the same for the variation
    yVar = np.zeros(4)
    for i in range (4):
        yVar[i] = np.var(yi[:,i])
    
    return yMean, yVar

        
if __name__== '__main__':
    T,Nt,a,b0,b1,g,k = 5.0,1000,45.6,750.0,1000.0,73.0,1.0
    y0 = [0.1,0.05,0.05,0.8]
    y = np.zeros((Nt,4))
    t, y[:,0],y[:,1],y[:,2],y[:,3] = solveFlu(T,Nt,a,b0,b1,g,k,y0)
    displaySolutions(t[t>1.0],y[t>1.0])
    
    i1,i2 = Nt/2, Nt
    print(fluStats(t,y,i1,i2))
