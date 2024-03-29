program main
    implicit none

    integer :: i
    interface
        function Tausworthe_shift_counter_R250(seed_)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, intent(in), optional :: seed_
            real(dp) :: Tausworthe_shift_counter_R250
        end function Tausworthe_shift_counter_R250
    end interface

    do i = 1, 100
        write(*,*) Tausworthe_shift_counter_R250()
    end do
end program main

function Tausworthe_shift_counter_R250(seed_)
    ! Tausworthe 位移计数器法消除同余法产生的随机数的关联性
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in), optional :: seed_
    real(dp) :: Tausworthe_shift_counter_R250

    integer :: i
    integer, save :: I_list(251) = [(-1, i = 1,251)]
    logical :: initialized = .false.
    integer, parameter :: m = 16807

    if (present(seed_)) then
        I_list(1) = seed_
        initialized = .false.
    else if (I_list(1) == -1) then
        I_list(1) = 1
        initialized = .false.
    end if

    if (initialized) then
        I_list(1:250) = I_list(2:251)
    else
        I_list(2) = Congruential_16807(I_list(1))
        do i = 2,250
            I_list(i + 1) = Congruential_16807()
        end do
        initialized = .true.
    end if
    I_list(251) = ieor(I_list(1), I_list(148))
    Tausworthe_shift_counter_R250 = mod(I_list(251), m) / dble(m)

    contains
        function Congruential_16807(seed_)
            ! Schrage 方法产生 16807 产生器中的随机整数
            implicit none

            integer, intent(in), optional :: seed_
            integer :: Congruential_16807

            integer, parameter :: a = 7**5, m = 2**31 - 1
            integer, parameter :: q = 12773, r = 2836
            integer, save :: z

            if (present(seed_)) then
                z = seed_
            else if (z == -1) then
                z = 1
            end if
            z = a * mod(z, q) - r * (z / q)
            if (z < 0) then
                z = z + m
            end if
            Congruential_16807 = z
        end function Congruential_16807
end function Tausworthe_shift_counter_R250