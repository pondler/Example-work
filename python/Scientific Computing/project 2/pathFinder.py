import numpy as np
import sys
import BellmanFord as bf
import copy as cp 
import matplotlib.pyplot as plt


# create nominal '0' for connectivity without weight
zer0 = sys.float_info.min 

# create an ordered list of durations
duration = [41,51,50,36,38,45,21,32,32,49,30,19,26]

# initialise the connectivity/weight matrix for the start/finish job system
adj = np.zeros((28,28))

# initialise the off-kilter diagonal for the s/f connections [1,2],[3,4],...
amm = np.zeros(27)
# load the values into this dummy vector
amm[1::2] = duration
# insert this vector into the diagonal above the main
adj = np.diag(amm,1)

# connect the end of all jobs to the virtual end node.
# j a job => start nodes have form 2j+1, ends have form 2j except for j=0
# adj[0,:] the virtual start arcs, adj[:,27] the virtual end arcs
adj[0,1::2] = zer0 
adj[::2,27] = zer0 

# vectorise the componentwise arcs given by order dependency 
conx = [2,2,2,4,4,6,12,14,14,20,22]
cony = [3,15,21,9,25,7,15,11,19,23,25]

# assign nominal connectivity value for these dependencies
adj[conx,cony] = zer0

# make the adj matrix negative (for Bellman-Ford)                  
Wei = -cp.copy(adj)

# initialize T, the optimal array detailing Job|Start|End
T = np.zeros((13,3))

#create a list of 'unseen' nodes - this is all of them before anythign happens
unseen = np.arange(13)

#assign values of the jobs
T[:,0] = unseen

# create a mothere list for paths through the network
SHPATH =[]

# run through the jobs
for i in range(13):
    
    #find the shortest path on the neg. conn/wei matrix with Bellman-Ford
    shpath = bf.BellmanFord(0,27,Wei)
    # delete the connection of the last done job to the virtual finish node
    penult = shpath[-2]
    Wei[penult,27] = 0
    SHPATH.append(shpath)
    print 'path:', shpath
    
    # one uses a filter to regain the jobs from the 'double' node system
    one = (np.array(filter(lambda x: x%2==1 and x<27,shpath)) - 1)/2
    # two uses a list comp. to list the durations 
    two = [duration[x] for x in one] 
    # pathTime sums the durations/weights traversed, giving path length
    pathTime = sum(two)
    print 'path time:', pathTime
    
    
    # fill the optimal start/end times for jobs in T 
    # cut shpath to give the jobs done
    for n in shpath[1:-1:2]: 
        # check this job has not been done already
        if (n-1)/2 in unseen:
            # if it's not the first job in the path
            if shpath[1:-1:2].index(n)>0:
                # assign its start value to the duration of previous jobs in
                # the path 
                T[(n-1)/2,1] = sum(two[:shpath[1:-1:2].index(n)])
                
            # if it's the first job in the path
            else:
                #the optimatal start time must be zero
                T[(n-1)/2,1] = 0
                
        # the optimal end time is nothing more than the optimal start plus
        # the duration of the job being undertaken
        T[(n-1)/2,2] = T[(n-1)/2,1] + duration[(n-1)/2]
        
        # make this node 'seen' so it will not be evaluated again
        np.delete(unseen,(n-1)/2)
        


print 'paths in descending length:', SHPATH
print '   Job |Start| End'
print T
    

# Immediate Workflow diagram
# plot for jobs in order the optimal start and end against time
plt.hlines(T[:,0],T[:,1],T[:,2],linewidth=30, color='red')
plt.xticks([0]+list(T[:,2]))
plt.yticks(T[:,0])
plt.grid()
plt.ylim([min(T[:,0])-1,max(T[:,0])+1])
plt.show()


#---------------------------------------------------------------------
#-----Optimising-the-work-flow----------------------------------------
#---------------------------------------------------------------------

# initialize the work-flow for each worker (nested list)
workers = []

# assign jobs and optimally start/end normally from T
jobs=T[:,0]; start = np.array(T[:,1]); finish = np.array(T[:,2])

# make 'todo' the list of jobs left to do 
todo = map(int, jobs)
#initialise a list for the cumulative time each worker has spent
cumtime=[]

# assign the jobs with no prerequisites to new workers
for j in np.where(start==0)[0]: 
    workers.append([j])
    cumtime.append(duration[j])

# these jobs have been done, so remove them from todo     
todo=np.delete(todo,np.where(start==0)[0])

# if there is a wait before a worker can do their next job, restloc will
# record for which job the 'rest' occured and for how long
restloc=np.zeros(13)

# flag is true as there are jobs to do
flag=True

while flag is True:
    # cumloc looks for the worker that will finish first using argmin
    cumloc = np.argmin(cumtime)
    # w is the worker to next to do something as they will finish first
    w = workers[cumloc]
    # find the difference in the start times of the jobs left to do
    # and the ending of the 'current' job the worker's doing 
    diff = start[list(todo)] - finish[w[-1]] 
    
    # find where (if anywhere) the difference is zero
    zeroWhere = list(np.where(diff==0)[0]); zeroWhere = map(int, zeroWhere)
    if not set(zeroWhere):
        # failing this, look for where the diff is negative
        negWhere = np.where(diff<0)[0] 
        # create the 'class' of these negatives
        negClass = diff[negWhere]   
        # for convinience, make them integer values
        negClass = map(int, negClass)
        if not set(negWhere):
            # do same for pos diff
            posWhere = np.where(diff>0)[0] 
            posClass = diff[posWhere] #list(filter(lambda y: y>0, x)); 
            posClass = map(int, posClass)
    
    # test in order of preference
    if set(zeroWhere):
        # of this group, find the job that takes the longest
        nextjob = list(duration).index(max([duration[t] for t in todo[zeroWhere]]))
        # diff = 0, no rest necessary
        rest = 0
        
    elif set(negWhere):
        # shortlist the location in the class of jobs with least neg. diffs
        shortlist = np.where(np.array(negClass)==max(negClass))[0]
        # find the job in todo with the greatest duration
        nextjob = todo[list(negWhere[list(shortlist)])][0]
        # optimum time is less, so no need to rest before doing it
        rest = 0 
    elif set(posWhere):
        # shortlist the location in the class of jobs with least pos. diffs
        shortlist = np.where(np.array(posClass)==min(posClass))[0] 
        # find the job which has minimum duration
        nextjob = todo[list(posWhere[list(shortlist)])][-1]
        # diff positive so must wait until it becomes possible to do the job
        rest = start[nextjob]-finish[w[-1]]
    
    # assign the rest to the locator at the position of the next node (pre-emptive)
    if rest>0:
        restloc[nextjob] = rest
    
    # remove from todo the job that's now done/planned
    todo=np.delete(todo,np.where(todo==nextjob)[0])   
    # give the worker the 'next job' 
    w.append(nextjob)
    
    # update cumtime
    cumtime[cumloc] += duration[nextjob] + rest
    
    # check we still have jobs to do, if not, leave the process: done
    if not set(todo):
        flag = False
        break
        
print 'workers:', workers


# plot the compressed gantt chart
# pick colors for the job blocks
colorcycle=['cyan','magenta']

plt.figure()

# assign dummy variables and initialize 'ends' 
ends=np.arange(14); m = 1; j=1

#run through the workers
for i in range(len(workers)):
    #reset the cumulative durations
    addon = 0
    
    #plot block for each worker
    for w in workers[i]:
        
        # re-order workers
        offset = len(workers)-i
        # plot the worker's jobs. start is sum of the duration of previous jobs and 
        # potential rest times. end time is the same plus the duration of the job
        plt.hlines(offset, addon+restloc[w], restloc[w]+addon+duration[w],colors=colorcycle[m] ,lw=25)
        
        # simply label blocks
        plt.annotate('job %i' %w,(addon+restloc[w]+0.5*duration[w]-4, offset-0.03))
        # record the end of the block for future visualization
        ends[j]=restloc[w]+addon+duration[w]
        addon += duration[w]
        # change color of next block
        m=(m+1)%2
        j+=1
        

plt.ylim(-0.5,len(workers)+0.5)
plt.ylabel=workers
plt.grid(which='both')
plt.xticks(ends)

plt.show()