program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer :: i
    interface
        function Load_subtraction_generator(seed)
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)

            integer(li), intent(in), optional :: seed
            real(dp) :: Load_subtraction_generator
        end function Load_subtraction_generator
    end interface

    do i = 1, 100
        write(*,*) Load_subtraction_generator()
    end do
end program main

function Load_subtraction_generator(seed)
    ! 带载减法产生器
    implicit none
    integer, parameter :: li = selected_int_kind(10)
    integer, parameter :: dp = selected_real_kind(8)

    integer(li), intent(in), optional :: seed
    real(dp) :: Load_subtraction_generator
    integer :: i
    integer(li), save :: I_list(44) = (/(-1, i = 1, 44)/)
    logical :: initialized = .false.
    integer(li), parameter :: m = 16807
    integer :: C = 0

    if (present(seed)) then
        I_list(1) = seed
        initialized = .false.
    else if (I_list(1) == -1) then
        I_list(1) = 1
        initialized = .false.
    end if

    if (initialized) then
        do i = 1, 43
            I_list(i) = I_list(i + 1)
        end do
    else
        I_list(2) = Congruential_16807(I_list(1))
        do i = 2, 43
            I_list(i + 1) = Congruential_16807()
        end do
        initialized = .true.
    end if
    I_list(44) = I_list(22) - I_list(1) - C
    if (I_list(44) >= 0) then
        C = 0
    else
        C = 1
        I_list(44) = I_list(44) + (2**32 - 5)
    end if
    Load_subtraction_generator = mod(I_list(44), m) / dble(m)

    contains
        function Congruential_16807(seed)
            ! Schrage 方法产生 16807 产生器中的随机整数
            implicit none
            integer, parameter :: li = selected_int_kind(10)

            integer(li), intent(in), optional :: seed
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
end function Load_subtraction_generator
