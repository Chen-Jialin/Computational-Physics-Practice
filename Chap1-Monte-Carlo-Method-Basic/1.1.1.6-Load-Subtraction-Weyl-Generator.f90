program main
    implicit none

    integer :: i
    interface
        function Load_subtraction_Weyl_generator(seed_1_, seed_2_)
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)

            integer(li), intent(in), optional :: seed_1_, seed_2_
            real(dp) :: Load_subtraction_Weyl_generator
        end function Load_subtraction_Weyl_generator
    end interface

    do i = 1, 100
        write(*,*) Load_subtraction_Weyl_generator()
    end do
end program main

function Load_subtraction_Weyl_generator(seed_1_, seed_2_)
    ! 带载减法 Weyl 产生器
    implicit none
    integer, parameter :: li = selected_int_kind(10)
    integer, parameter :: dp = selected_real_kind(8)

    integer(li), intent(in), optional :: seed_1_, seed_2_
    real(dp) :: Load_subtraction_Weyl_generator

    integer :: i
    integer(li), save :: J_list(44) =[(-1, i = 1, 44)]
    integer(li), save :: K_n = -1, I_n
    logical :: initialized = .false.
    integer(li), parameter :: m = 16807
    integer :: C = 0

    if (present(seed_1_)) then
        J_list(1) = seed_1_
        if (present(seed_2_)) then
            K_n = seed_2_
        else if (K_n == -1) then
            K_n = 1
        end if
        initialized = .false.
    else if (J_list(1) == -1) then
        J_list(1) = 1
        if (present(seed_2_)) then
            K_n = seed_2_
        else if (K_n == -1) then
            K_n = 1
        end if
        initialized = .false.
    end if

    if (initialized) then
        J_list(1:43) = J_list(2:44)
    else
        J_list(2) = Congruential_16807(J_list(1))
        do i = 2, 43
            J_list(i + 1) = Congruential_16807()
        end do
        initialized = .true.
    end if
    J_list(44) = J_list(22) - J_list(1) - C
    if (J_list(44) >= 0) then
        C = 0
    else
        C = 1
        J_list(44) = J_list(44) + (2**32 - 5)
    end if
    K_n = mod(K_n - 362436069, 2**32_li)
    I_n = mod(J_list(44) - K_n, 2**32_li)
    Load_subtraction_Weyl_generator = mod(I_n, m) / dble(m)

    contains
        function Congruential_16807(seed_)
            ! Schrage 方法产生 16807 产生器中的随机整数
            implicit none
            integer, parameter :: li = selected_int_kind(10)

            integer(li), intent(in), optional :: seed_
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
end function Load_subtraction_Weyl_generator
