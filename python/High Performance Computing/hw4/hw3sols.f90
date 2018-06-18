!solutions copy of hw3 network module

module network
implicit none
integer, allocatable, dimension(:) :: qnet !degree list
integer, allocatable, dimension(:,:) :: enet,anet !edge list, adjacency matrix
integer :: Ntotal, Ltotal !Total number of nodes and links
save
contains


subroutine generate(N0,L,Nt,qmax)
!Generate recursive network corresponding
!to model parameters provided as input
implicit none
integer, intent(in) :: N0,L,Nt
integer, intent(out) :: qmax
integer :: i1,j1,k1,N,M,i_add
real(kind=8), allocatable, dimension(:) :: CP,P
real(kind=8), allocatable, dimension(:,:) :: R


!Initialize network, allocate variables
ntotal = N0 + Nt
ltotal = N0 + L*Nt

if (allocated(qnet)) deallocate(qnet)
if (allocated(enet)) deallocate(enet)

allocate(qnet(ntotal))
allocate(enet(ltotal,2))

qnet(1:N0) = 2
do i1 = 1,N0-1
enet(i1,:) = (/i1,i1+1/)
end do
enet(N0,:) = (/N0,1/)


!generate random numbers
allocate(R(Nt,L))

call random_number(R)
allocate(CP(ntotal),P(ntotal))

N = N0 !total (initial) nodes
M = N0 !total (initial) links
!Iterate over Nt steps
do i1=1,Nt

!convert degrees into probabilities
P(1:N) = dble(qnet(1:N))/sum(qnet(1:N))
!Convert P into cumulative probability
CP(1) = P(1)
CP(N) = 1.d0
do j1=2,N-1
CP(j1) = CP(j1-1) + P(j1)
end do

!assign links
do j1=1,L
i_add = minloc(abs(CP(1:N)-R(i1,j1)),1)
if (R(i1,j1)>CP(i_add)) i_add = i_add + 1

qnet(i_add) = qnet(i_add)+1
enet(M+j1,:) = (/N+1,i_add/)
end do
qnet(N+1) = L
N = N+1
M = M + L

end do
!set qmax
qmax = maxval(qnet)


deallocate(R,CP,P)
end subroutine generate


subroutine adjacency_matrix()
!Create adjacency matrix corresponding
!to pre-existing edge list
implicit none
integer :: i1,j1

if (allocated(anet)) deallocate(anet)
allocate(anet(ntotal,ntotal))
anet = 0
do i1=1,ltotal
anet(enet(i1,1),enet(i1,2)) = anet(enet(i1,1),enet(i1,2)) + 1
end do

anet = anet + transpose(anet)

end subroutine adjacency_matrix

subroutine connectivity(c)
!Compute connectivity of pre-computed network
implicit none
real(kind=8), intent(out) :: c
integer :: i1,j1
real(kind=8), dimension(size(anet,1),size(anet,2)) :: M !Laplacian matrix
integer :: LWORK,INFO !variables for DSYEV
real(kind=8) :: lmin
real(kind=8), allocatable, dimension(:) :: W,WORK

!generate Laplacian matrix, M
M = 0.d0
do i1=1,size(anet,1)
M(i1,i1) = qnet(i1)
end do
M = M-anet

!compute eigenvalues of M, select connectivity
LWORK = 6*size(anet,1)
allocate(W(size(anet,1)),WORK(LWORK))
call DSYEV('N','U',size(M,1),M,size(M,1),W,WORK,LWORK,INFO)
c = W(2)
if (INFO .ne. 0) print *, 'INFO=',INFO
deallocate(W,WORK)

end subroutine connectivity


subroutine vary_connectivity(N0,Lmax,Nt,carray)
!Compute connectivity for networks with L varying
!between 1 and Lmax
implicit none
integer, intent(in) :: N0,Lmax,Nt
real(kind=8), dimension(Lmax),intent(out) :: carray
integer :: L,qmax

print *, 'vary connectivity, N0,Nt=',N0,Nt
do L = 1,Lmax
call generate(N0,L,Nt,qmax)
call adjacency_matrix()
call connectivity(carray(L))
print *, 'L,c=',L,carray(L)
end do


end subroutine vary_connectivity


end module network
