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
    end interface
    do i = 1, 100
        write(*,*) Discrete_varible()
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
    do while (.not. ((sum(p(:i - 1)) <= xi) .and. (xi < sum(p(:i)))))
        i = i + 1
    end do
    Discrete_varible = x(i)
end function Discrete_varible