import numpy as np
from scipy import integrate
def solveFlu(T,Nt,a,b0,b1,g,k,y0):
    """Obtains solution to Flu model from t=0 to t=T with
    initial conditions, y0, and model parameters, a,b0,b1,g,k.
    """
#   create time vector and define time dependent disease transmission rate
    t = np.linspace(0,T,Nt)

#   deine disease system as a function over an array
    def Flu(F,t):
        b = b0 + b1*(1+np.cos(2*(np.pi)*t))

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
    
    S = soln[:,0]
    E = soln[:,1]
    C = soln[:,2]
    R = soln[:,3]

    y = [S, E, C, R]

    return t, y