def short_rd(matrix):
    
    for j in range(1, len(matrix)):
	matrix[0][j] += matrix[0][j-1]
   
    for i in range(1, len(matrix)):
	matrix[i][0] += matrix[i-1][0]

    for i in range(1, len(matrix)):
	for j in range(1, len(matrix[1])):
	    matrix[i][j] += min(matrix[i-1][j], matrix[i][j-1])

    return matrix[-1][-1]
    
def matr(txt):
    f = open ( txt , 'r')
    l = [ map(int,line.split(',')) for line in f ]
    f.close
    return l 
    
if __name__ == '__main__':
### PATH TO matrix.txt MAY BE DIFFERENT FOR YOU 
    print 'RES1:', short_rd(matr('./matrix'))
    