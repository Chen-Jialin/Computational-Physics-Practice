program main
    implicit none
    integer, parameter :: li = selected_int_kind(10)
    integer, parameter :: dp = selected_real_kind(8)

    integer(li) :: a, b, m! 乘子, 增量, 模数
    common /group1/ a, b, m
    real(dp) :: x, y, z
    integer :: i

    interface
        function Lehmer_linear_congruential(seed_)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, intent(in), optional :: seed_
            real(dp) :: Lehmer_linear_congruential
        end function Lehmer_linear_congruential
    end interface

    m = 2**31
    a = 2**16 + 3
    b = 0
    open(unit=11, file='1.1.1.2-IBM-RANDU.txt', status='replace')
    do i = 1,10000
        x = Lehmer_linear_congruential()
        y = Lehmer_linear_congruential()
        z = Lehmer_linear_congruential()
        write(11, '(3f16.8)') x, y, z
    end do
    close(11)
end program main

function Lehmer_linear_congruential(seed_)
    ! Lehmer 线性同余法产生 [0,1) 区间上的均匀随机数
    implicit none
    integer, parameter :: li = selected_int_kind(10)
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in), optional :: seed_
    real(dp) :: Lehmer_linear_congruential

    integer(li) :: a, b, m! 乘子, 增量, 模数
    common /group1/ a, b, m
    integer(li), save :: I_n = -1
    if (present(seed_)) then
        I_n = seed_
    else if (I_n == -1) then
        I_n = 1
    end if
    I_n = mod((a * I_n + b), m)
    Lehmer_Linear_Congruential = I_n / dble(m)
end function Lehmer_Linear_Congruential