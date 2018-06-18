!CHRISTOPHER MCLEOD, CID: 00947553
module network

implicit none
integer, allocatable, dimension(:,:) :: anet
integer, allocatable, dimension(:) :: qnet
integer, allocatable, dimension(:,:) :: enet

contains

subroutine generate(N0,L,Nt,qmax)
!Generate recursive matrix corresponding
!to model parameters provided as input
implicit none
integer, intent(in) :: N0,L,Nt
integer, intent(out) :: qmax
real (kind = 8) , dimension(L) :: sample
real (kind = 8) , dimension(N0+Nt) :: p,G
integer :: i, j, k, r
real (kind = 8) :: qsum, 

!allocate enet and qnet
allocate(enet(2,N0+Nt*L))
allocate(qnet(N0+Nt))

!set initial values of qnet
do i = 1,N0
qnet(i) = 2
end do

do i = N0+1,N0+Nt
qnet(i) = 0
end do

!initialize enet as well
do i = 1,2
do j = 1,N0
enet(i,j) = j+i-1
end do
end do
enet(2,N0) = 1

do i = 1,2
do j = N0+1, N0+Nt*L
enet(i,j) = 0
end do
end do

intialdegree = sum(qnet(1:N0))
!sample = 0.0d0

!main chunk of the subroutine
!fix time and take a sample, assign qnet for new node.
do j = 1,Nt

    !do i = 1,(N0+j-1)
      !  prob(i+1) = qnet(i1)/initialdegree + prob(i)
    !end do

qnet(N0+j) = L
!create probability array for this new node, qsum real, mixed mode for p(i)
    do i = 1,N0+j -1
        qsum = sum(qnet) - L
        p(i+1) = qnet(i)/qsum + p(i)
    end do
! over the sample, assign L elements from N0+1 to N0+j-1+k in enet(1,:)
    do k = 1,L
        enet(1,N0+j+k-1) = N0+j
        call random_number(sample)
!test where the point is, assign values in qnet and enet(2,:) accordingly for 0<=sample(k)<=p(1)
        do r = 1, N0+j
            if (k<= p(r)) then
                enet(2, N0+j+k-1) = r+1
                qnet(r+1) = qnet(r+1) + 1
                exit
            end if
        end do
    end do
end do


qmax = maxval(qnet)

end subroutine generate


!subroutine adjacency_matrix()
!Create adjacency matrix corresponding
!to pre-existing edge list
!    implicit none
!    integer :: deg
!    deg = maxval(enet(1,:))

!end subroutine adjacency_matrix


!subroutine connectivity(c)
!Compute connectivity of pre-computed network
!	implicit none
!	real(kind=8), intent(out) :: c

!end subroutine connectivity


!subroutine vary_connectivity(N0,Lmax,Nt,carray)
!Compute connectivity for networks with L varying
!between 1 and Lmax
!	implicit none
!	integer, intent(in) :: N0,Lmax,Nt
!	real(kind=8), dimension(Lmax),intent(out) :: carray


!end subroutine vary_connectivity



end module network
