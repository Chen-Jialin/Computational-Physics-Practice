program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer :: i
    interface
        function Discrete_varible()
            ! 离散随机变量产生器
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp) :: Discrete_varible
        end function Discrete_varible

        function Poisson(lambda)
            ! Poisson 分布
            implicit none
            integer, parameter :: dp = selected_real_kind(8)
        
            integer, intent(in) :: lambda
            real(dp) :: Poisson
        end function Poisson
    end interface

    do i = 1, 100
        write(*,*) Discrete_varible()
    end do

    do i = 1, 100
        write(*,*) Poisson(1)
    end do
end program main

function Discrete_varible()
    ! 离散随机变量产生器
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp) :: Discrete_varible

    real(dp) :: xi
    integer :: i
    real(dp), parameter :: p(3) = [1 / 4.d0, 5 / 8.d0, 1 / 8.d0]
    real(dp), parameter :: x(3) = [1.d0, 2.d0, 3.d0]

    call random_number(xi)
    i = 1
    do while (xi >= sum(p(:i)))
        i = i + 1
    end do
    Discrete_varible = x(i)
end function Discrete_varible

function Poisson(lambda)
    ! Poisson 分布
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in) :: lambda
    real(dp) :: Poisson

    real(dp) :: xi
    integer :: i
    real(dp) :: sum_of_p_n

    call random_number(xi)
    xi = xi * exp(dble(lambda))
    i = 0
    sum_of_p_n = lambda**i / dble(factorial(i))
    do while (xi >= sum_of_p_n)
        i = i + 1
        sum_of_p_n = sum_of_p_n + lambda**i / dble(factorial(i))
    end do
    Poisson = i

    contains
        function factorial(n)
            implicit none

            integer, intent(in) :: n
            integer :: factorial

            integer :: i

            factorial = 1
            do i = 1, n
                factorial = factorial * i
            end do
        end function factorial
end function Poisson