!CHRISTOPHER MCLEOD, CID: 00947553
module network

    implicit none
    integer, allocatable, dimension(:,:) :: anet
    integer, allocatable, dimension(:) :: qnet
    integer, allocatable, dimension(:,:) :: enet
    save
contains

subroutine generate(N0,L,Nt,qmax)
	!Generate recursive matrix corresponding
	!to model parameters provided as input
	implicit none
	integer, intent(in) :: N0,L,Nt
	integer, intent(out) :: qmax
    real (kind = 8) , dimension(N0+Nt+1) :: p
    integer :: i, j, k, r1
    real (kind = 8) :: qsum, sample

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

    !main chunk of the subroutine
    !initialise cumulative probability at 0.0
    p(1) = 0.0d0
    !fix time and take a sample, assign qnet for new node.
    do j = 1,Nt
        qnet(N0+j) = L
        !create cumulative probability array for this new node, making sure qsum real and remove qnet(N0+j)
        do i = 1,N0+j
            qsum = real(sum(qnet)) - real(L)
            p(i+1) = real(qnet(i))/qsum + p(i)
        end do
        ! sample U[0,1], assign enet(1,:) for the new L edges
        do k = 1,L
            call random_number(sample)
            enet(1,N0+(j-1)*L+k) = N0+j
            !test where the sample is, by cumulating weighted probabilities until it overcomes the sample
            !update values in qnet and assign values in enet(2,:) accordingly for sample(k)<=p(r1+1)
            do r1 = 1,N0+j
                if (sample <= p(r1+1)) then
                    enet(2,N0+(j-1)*L+k) = r1
                    qnet(r1) = qnet(r1) + 1
                exit
                end if
            end do
        end do
    end do

    !assign output value
    qmax = maxval(qnet)

end subroutine generate


subroutine adjacency_matrix()
    !Create adjacency matrix corresponding
    !to pre-existing edge list
    implicit none
    integer :: deg, len
    integer :: j1,i1, count

    !take measurements of enet for later
    len = size(enet(1,:))
    deg = maxval(enet(1,:))

    !create anet skeleton
    allocate(anet(deg,deg))

    !assign all values to 0 so we can just update the entries which aren't
    anet = 0

    !use values in enet(:,j1) to create anet(i,j) values
    !assign the values of anet symmetrically
    do j1 = 1,len
        anet(enet(1,j1),enet(2,j1)) = anet(enet(1,j1),enet(2,j1)) +1
        anet(enet(2,j1),enet(1,j1)) = anet(enet(2,j1),enet(1,j1)) +1
    end do

end subroutine adjacency_matrix


subroutine connectivity(c)
	!Compute connectivity of pre-computed network
	implicit none
	real(kind=8), intent(out) :: c
    real(kind=8), dimension(:,:), allocatable :: D, M, A
    real(kind=8), dimension(:), allocatable :: work, w
    integer :: info, lwork, i

    !allocate dsyev parameters
    allocate(work(1))
    allocate(w(size(qnet)))
    allocate(A(size(qnet),size(qnet)))
    allocate(D(size(qnet),size(qnet)))

    !initialise D
    !Perform a do loop to put the values of qnet on the diag of D
    D = 0
    do i = 1,size(qnet)
        D(i,i) = qnet(i)
    end do

    !calculate M
    M = D - anet
    !Assign a temp variable so dsyev won't destroy M
    A = M

    !call the function to test using appropriate instances of parameters
    call dsyev('N','U', size(qnet),A,size(qnet), w, work,-1,info)

    !reallocate work
    lwork = int(work(1))
    deallocate(work)
    allocate(work(lwork))

    !call function to get the eigenvalues of A
    call dsyev('N', 'U', size(qnet), A, size(qnet), w, work, lwork, info )

    !print *, w

    !w the eigenvalue array ordered from smallest to largest by dsyev
    c = w(2)


end subroutine connectivity


subroutine vary_connectivity(N0,Lmax,Nt,carray)
	!Compute connectivity for networks with L varying
	!between 1 and Lmax
    !trend: connectivity increases with L
	implicit none
	integer, intent(in) :: N0,Lmax,Nt
	real(kind=8), dimension(Lmax),intent(out) :: carray
    integer :: i1, qmax
    real(kind=8) :: c

    !Run L from 1 to Lmax
    do i1 = 1, Lmax
        !deallocate enet,qnet,anet associated to old values of L
        deallocate(enet)
        deallocate(qnet)
        deallocate(anet)

        !now call these functions again
        call generate(N0, i1, Nt,qmax)
        call adjacency_matrix()
        call connectivity(c)

        !for this value of L=i1, assign c from conectivity(c) to carray(i1)
        carray(i1) = c
    end do

    !print *, carray

end subroutine vary_connectivity



end module network
