program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer :: a, b, m
    common /group1/ a, b, m
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

        function Schrage_16807(seed_)
            ! Schrage 方法实现 16807 产生器
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, intent(in), optional :: seed_
            real(dp) :: Schrage_16807
        end function Schrage_16807
    end interface

    a = 7**5
    b = 0
    m = 2**31 - 1
    do i = 1, size(x)
        x(i) = Schrage_16807()
    end do
    C_l = Auto_correlaion(x, l)
    write(*,*) 'Auto-correlation function C_l(x) = ', C_l

    a = 106
    b = 1288
    m = 6075
    x(i) = Schrage_16807(1)
    do i = 2, size(x)
        x(i) = Schrage_16807()
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

function Schrage_16807(seed_)
    ! Schrage 方法实现 16807 产生器
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in), optional :: seed_
    real(dp) :: Schrage_16807

    integer :: a, b, m
    common /group1/ a, b, m
    integer :: q, r
    integer, save :: z = -1

    q = m / a
    r = mod(m, a)
    if (present(seed_)) then
        z = seed_
    else if (z == -1) then
        z = 1
    end if
    z = a * mod(z, q) - r * (z / q)
    if (z < 0) then
        z = z + m
    end if
    z = z + b
    if (z >= m) then
        z = z - m
    end if
    Schrage_16807 = z / dble(m)
end function Schrage_16807