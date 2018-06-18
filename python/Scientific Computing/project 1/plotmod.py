import numpy as np
import csv
import matplotlib.pyplot as plt
import RomeFlowCalc as RFC

def plotWei(vertPos, edgeWei):

        
    X = np.empty(0,dtype=float)
    Y = np.empty(0,dtype=float)
    with open(vertPos,'r') as file:
        AAA = csv.reader(file) 
        for row in AAA:
            X = np.concatenate((X,[float(row[1])]))
            Y = np.concatenate((Y,[float(row[2])])) 
    file.close()
        
    w = RFC.weiMaker(vertPos, edgeWei)
    
    x=[]
    y=[]
    for i in range(58):
        for j in range(58): 
            if w[i,j]>0: 
                x[i] = x.append([X[i],X[i]])
                y[j] = y.append([Y[j],Y[j]])
    
    plt.figure()
    plt.plot(X,Y,'ro')
    plt.plot(x,y)
    plt.show() 
    
if __name__=='__main__':
    plotWei('RomeVertices', 'RomeEdges(2)')