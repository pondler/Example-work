def short_udlr(matrix):
	inf = 1 << 30
	distance = [[inf] * len(matrix) for i in range(len(matrix))]
	
	def get_dist(a, b):
		if a < 0 or a >= len(matrix) or b < 0 or b >= len(matrix):
			return inf
		else:
			return distance[b][a]
	
	distance[0][0] = matrix[0][0]
	changed = True
	while changed: 
		changed = False
		for b in range(len(matrix)):
			for a in range(len(matrix)):
				temp = matrix[b][a] + min(
					get_dist(a-1, b),
					get_dist(a+1, b),
					get_dist(a, b-1),
					get_dist(a, b+1))
				if temp < distance[b][a]:
					distance[b][a] = temp
					changed = True
	return str(distance[-1][-1])
	
def matr(txt):
    f = open ( txt , 'r')
    l = [ map(int,line.split(',')) for line in f ]
    f.close
    return l 
	
if __name__ == '__main__': 
### PATH TO matrix.txt MAY BE DIFFERENT FOR YOU 
    print 'RES 3:', short_udlr(matr('./matrix'))