program main
    implicit none

    integer :: i
    interface
        function Tausworthe_shift_counter_R250(seed)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, intent(in), optional :: seed
            real(dp) :: Tausworthe_shift_counter_R250
        end function
    end interface

    do i = 1, 100
        write(*,*) Tausworthe_shift_counter_R250()
    end do
end program main

function Tausworthe_shift_counter_R250(seed)
    ! Tausworthe 位移计数器法消除同余法产生的随机数的关联性
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in), optional :: seed
    real(dp) :: Tausworthe_shift_counter_R250
    integer :: i
    integer, save :: congruential_list(251) = (/(-1, i = 1,251)/)
    logical :: initialized = .false.
    integer, parameter :: m = 16807

    if (present(seed)) then
        congruential_list(1) = seed
        initialized = .false.
    else if (congruential_list(1) == -1) then
        congruential_list(1) = 1
        initialized = .false.
    end if

    if (initialized) then
        do i = 1, 250
            congruential_list(i) = congruential_list(i + 1)
        end do
    else
        congruential_list(2) = Congruential_16807(congruential_list(1))
        do i = 2,250
            congruential_list(i + 1) = Congruential_16807()
        end do
        initialized = .true.
    end if
    congruential_list(251) = ieor(congruential_list(1), congruential_list(148))
    Tausworthe_shift_counter_R250 = mod(congruential_list(251), m) / dble(m)


    contains
        function Congruential_16807(seed)
            ! Schrage 方法产生 16807 产生器中的随机整数
            implicit none
        
            integer, intent(in), optional :: seed
            integer :: Congruential_16807
        
            integer, parameter :: a = 7**5, m = 2**31 - 1
            integer, parameter :: q = 12773, r = 2836
            integer, save :: z
        
            if (present(seed)) then
                z = seed
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