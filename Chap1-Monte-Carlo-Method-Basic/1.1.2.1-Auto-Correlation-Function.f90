program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer :: a, b, m
    common /group1/ a, b, m
    integer, allocatable :: seed(:)
    integer :: n
    integer :: i, l = 1
    real(dp) :: x(1000) ! 随机数列
    real(dp) :: C_l ! 自相关函数

    interface
        function Auto_correlaion(x, l)
            ! 间距为 l 的自相关函数
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in) :: x(:)
            integer, intent(in) :: l
            real(dp) :: Auto_correlaion
        end function Auto_correlaion
    end interface

    call random_seed(size=n)
    allocate(seed(n))
    seed = 1
    call random_seed(put=seed)
    do i = 1, size(x)
        call random_number(x(i))
    end do
    C_l = Auto_correlaion(x, l)
    write(*,*) 'Auto-correlation function C_l(x) = ', C_l
end program main

function Auto_correlaion(x, l)
    ! 间距为 l 的自相关函数
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp), intent(in) :: x(:)
    integer, intent(in) :: l
    real(dp) :: Auto_correlaion

    if (size(x) < l + 1) then
        write(*,*) 'Interval l too large, correlation coeffiecient undefined.'
        return
    end if

    Auto_correlaion = (sum(x(:size(x) - l) * x(l + 1:)) / (size(x) - l) - (sum(x) / size(x))**2) /&
    ((sum(x**2) / size(x)) - (sum(x) / size(x))**2)
end function Auto_correlaion