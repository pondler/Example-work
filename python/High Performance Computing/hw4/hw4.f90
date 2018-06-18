!CHRISTOPHER MCLEOD 00947553
!Should be compiled with network.f90
module netstats
    use network
    use omp_lib
    
    contains

subroutine stats(n0,l,nt,m,qnetm,qmaxm,qvarm)
    !Input: 
    !n0,nl,nt: recursive network model parameters
    !m: number of network realizations to compute
    !Output:
    !qnetm: node lists for all m networks
    !qmaxm,qvarm: ensemble averages of max(q) and var(q)
    implicit none
    integer, intent(in) :: n0,l,nt,m
    integer, dimension(n0+nt,m), intent(out) :: qnetm
    integer, dimension(n0+nt) :: qnet
    integer, dimension(n0+l*nt,2) :: enet
    real(kind=8), dimension(m) :: qvarv
    integer, dimension(m) :: qmaxv
    integer, intent(out) :: qmaxm
    real(kind=8), intent(out) :: qvarm
    integer :: qmax, j1
    real(kind=8) :: qnetav

!   call generate for j1=1->m realizations 
!   create qmaxv vector of qmax for each j1
!   create qvarv vector of variance of qnet for each j1 using the averave of qnet, qnetav

    do j1 = 1, m
        call generate(n0,l,nt,qmax,qnet,enet)
        qnetm(:,j1) = qnet
        qmaxv(j1) = qmax
        qnetav = dble(sum(qnet))/dble(size(qnet))
        qvarv(j1) = dble(sum((qnet-qnetav)**2))/dble(size(qnet))
    end do

!   average out qnetvarv over m realizations, giving qvarm
!   take the maximum of the qmaxv, giving qmaxm

    qvarm = dble(sum(qvarv))/dble(m)
    qmaxm = maxval(qmaxv)

    !print *, 'qvarm = ', qvarm
    !print *, 'qmaxm =', qmaxm

end subroutine stats


subroutine stats_omp(n0,l,nt,m,numThreads,qnetm,qmaxm,qvarm)
    !Input: 
    !n0,nl,nt: recursive network model parameters
    !m: number of network realizations to compute
    !numThreads: number of threads for parallel computation
    !Output:
    !qnetm: node lists for all m networks
    !qmaxm,qvarm: ensemble averages of max(q) and var(q)
    use omp_lib
    implicit none
    integer, intent(in) :: n0,l,nt,m,numThreads
    integer, dimension(n0+nt,m), intent(out) :: qnetm
    integer, dimension(n0+nt) :: qnet
    integer, dimension(n0+l*nt,2) :: enet
    real(kind=8), dimension(m) :: qvarv
    integer, dimension(m) :: qmaxv
    integer, intent(out) :: qmaxm
    real(kind=8), intent(out) :: qvarm
    integer :: qmax, j1
    real(kind=8) :: qnetav

!   assign number of threads in parellelization 

    !$ call omp_set_num_threads(numThreads)

!   Parallelize loop using omp

    !$OMP parallel do private(j1)
    do j1 = 1, m
        call generate(n0,l,nt,qmax,qnet,enet)
        qnetm(:,j1) = qnet
        qmaxv(j1) = qmax
        qnetav = dble(sum(qnet))/dble(size(qnet))
        qvarv(j1) = dble(sum((qnet-qnetav)**2))/dble(size(qnet))
    end do
    !$OMP end parallel do  

    qvarm = dble(sum(qvarv))/dble(m)
    qmaxm = maxval(qmaxv)

    !print *, 'qvarm = ', qvarm
    !print *, 'qmaxm =', qmaxm


end subroutine stats_omp


subroutine test_stats_omp(n0,l,nt,m,numThreads,walltime)

    !Input: same as stats_omp
    !Output: walltime: time for 100 cals to stats_par
    implicit none
    integer, intent(in) :: n0,l,nt,m,numThreads
    real(kind=8), intent(out) :: walltime
    integer(kind=8) :: clock_t1, clock_t2, clock_rate, i1, i2
    integer, dimension(n0+nt,m) :: qnetm
    integer :: qmaxm
    real(kind=8) :: qvarm
    
!   create if loop to see if parallelization is occuring (i.e. numthreads>1)
!   call system clock before and after running stats/stats_omp 100 times

    if (numThreads == 1) then
        call system_clock(clock_t1)
        do i1 = 1,100
            call stats(n0,l,nt,m,qnetm,qmaxm,qvarm)
        end do 
        call system_clock(clock_t2, clock_rate)
    else if (numThreads > 1) then
        call system_clock(clock_t1)
        do i2 = 1,100
            call stats_omp(n0,l,nt,m,numThreads,qnetm,qmaxm,qvarm)
        end do 
        call system_clock(clock_t2, clock_rate)
    end if
    
!   create walltime, the average time taken to run the loop 100 times as measured by the system clock

    walltime = 0.01d0*(dble((clock_t2 - clock_t1)))/(dble(clock_rate))
    
    !print *, 'walltime for process with',numThreads,'thread(s) =', walltime 
    

end subroutine test_stats_omp


end module netstats