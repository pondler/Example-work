program test

    use netstats
    implicit none
    integer, dimension(8,3) :: qnetm
    real(kind=8) ::qvarm, walltime
    integer :: qmaxm

    call test_stats_omp(5,2,400,100,1,walltime)
    call test_stats_omp(5,2,400,100,2,walltime)
    call test_stats_omp(5,2,400,100,3,walltime)
    call test_stats_omp(5,2,400,100,4,walltime)


end program test