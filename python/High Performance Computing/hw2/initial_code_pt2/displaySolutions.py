import matplotlib.pyplot as plt
def displaySolutions(t,y):
    """Plot time series and phase plane for the numerical solution;
    input variable y contains S(t),E(t),C(t),R(t)
    """     

#   assign solutions to correct arrays    
#   S = y[0]
    E = y[1]
    C = y[2]
 #  R = y[3]

#   plot C against t
    plt.figure()
    plt.plot(t,C, label='Contagious but not infected')
    plt.xlabel('time after outbreak')
    plt.ylabel('population')
    plt.title('Christopher McLeod, displaySolutions: Amount of Contagious population against time')
    plt.legend(loc=0)

#   plot phase plane of E and C
    plt.figure()
    plt.plot(C,E, 'r', label='Exposed')
    plt.xlabel('Contagious population')
    plt.ylabel('Exposed population')
    plt.title('Christopher McLeod, displaySolutions: Phase plane of Exposed against Contagious')
    plt.legend(loc=0)
