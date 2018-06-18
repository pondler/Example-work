# -*- coding: utf-8 -*-
import numpy as np
import csv
import copy as cp
import Dijkstra

# create a function to create a weight matrix from two cvs. 
# cvs expected to give the position of the vertices (vertPos)
# and edge weights(edgeWei) of the network
def weiMaker(vertPos, edgeWei):
    
    X = np.empty(0,dtype=float)
    Y = np.empty(0,dtype=float)
    with open(vertPos,'r') as file:
        AAA = csv.reader(file) 
        for row in AAA:
            X = np.concatenate((X,[float(row[1])]))
            Y = np.concatenate((Y,[float(row[2])])) 
    file.close()
    
    A = np.empty(0,dtype=int)
    B = np.empty(0,dtype=int)
    V = np.empty(0,dtype=float) 
    with open(edgeWei,'r') as file:
        AAA = csv.reader(file) 
        for row in AAA:
            A = np.concatenate((A,[int(row[0])])) 
            B = np.concatenate((B,[int(row[1])])) 
            V = np.concatenate((V,[float(row[2])]))
    file.close()
    
    wei = Dijkstra.calcWei(X,Y,A,B,V)
    
    return wei
    
# main flow simulating code
# takes csvs to make initial weight matrix, has additional parameter xi
# the coefficient in updating the weight matrix, and ex, the exit node (51 here)
def romeFlow(vertPos, edgeWei, xi, inj , ext ):
    
    # initialise params; init. weight matrix and make a copy to be updated 
    w = weiMaker(vertPos, edgeWei)
    wei = cp.copy(w)
    C = np.zeros((58,201))
    moving = np.zeros(58)
    # create Uu to count which edges get used
    Uu = cp.copy(w)
    
    # set the non-zero values in the weight matrix to 0 in Uu
    for y,i in np.ndenumerate(Uu):
        if i>0: 
            Uu[y] =1 
    
    # initialise the system, before any iterations
    C[inj,0] = 20
    
    # begin the time loop of 200 iterations
    for t in range(200):
        #predetermine the amount of cars to move
        for i in range(len(moving)):
            moving[i] = round(0.7*C[i,t])
        
        #loop through nodes and move them to next best 
        for n in range(58):
            if (C[n,t] > 0 and n != ext): 
                # find next move: next node on shortest path to exit node
                shpath = Dijkstra.Dijkst(n, ext, wei)
                nm = shpath[1]
                # set used edges to zero
                Uu[n,nm] = 0 
                # update n by removing from it the cars that are moving
                C[n,t+1] += (C[n,t] - moving[n])
                # update the next move node with the cars moving from n 
                C[nm,t+1] += moving[n]
            elif n== ext :
                # let 40% of the cars exit          
                C[n,t+1] += np.round(0.6*C[n,t])
                
        
        
        # inject 20 cars into the injection node for the first 180 iterations
        if t<179 : 
            C[inj,t+1] += 20
        
        # update the weight matrix co-ordinate wise, making sure node i and j 
        # are truly connected, first
        for i in range(58):
            for j in range(58):
                if w[i,j] > 0 :
                    wei[i,j] = w[i,j] + xi*0.5*(C[i,t+1] + C[j, t+1])
    
    # count edges as utilised if they are not one way and
    # have been used in either direction    
    # delete double entries            
    for i in range(58):
        for j in range(58):
            if (w[i,j] == w[j,i] and Uu[i,j] != Uu[j,i]):
                Uu[i,j] = 0
            if Uu[i,j] == Uu[j,i] == 1:
                Uu[i,j] = 0 
                    
    # return C, the 'flow matrix' 
    # return matrix of unused edges    
    return C, Uu
    
    
if __name__ == '__main__': 
    # for maxload 2.1
    print 'array of max number of cars at node n=1->58:',  np.max(romeFlow('RomeVertices', 'RomeEdges(2)', 0.01,12,51), axis = 1)
    
    # for congestion 2.2
    #cong = np.sum(romeFlow('RomeVertices', 'RomeEdges(2)', 0.01,12,51), axis=1)
    #print  'greatest congestion occurs at nodes:', cong.argsort()[-5:][::-1]    
   
    # for edge utilisation 2.3
    #_,Uu = romeFlow('RomeVertices', 'RomeEdges(2)', 0.01,12,51)
    #print 'number of unused edges:', np.sum(Uu)
    #print 'on edges:', [y for y, i in np.ndenumerate(Uu) if i == 1]
    

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        