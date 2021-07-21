program main
    implicit none

    integer :: i

    interface
        function Marsaglia_generator(seed_1_, seed_2_)
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)
        
            integer(li), intent(in), optional :: seed_1_, seed_2_
            real(dp) :: Marsaglia_generator
        end function Marsaglia_generator
    end interface

    do i = 1, 100
        write(*,*) Marsaglia_generator()
    end do
end program main

function Marsaglia_generator(seed_1_, seed_2_)
    implicit none
    integer, parameter :: li = selected_int_kind(10)
    integer, parameter :: dp = selected_real_kind(8)

    integer(li), intent(in), optional :: seed_1_, seed_2_
    real(dp) :: Marsaglia_generator

    if (present(seed_1_)) then
        if (present(seed_2_)) then
            Marsaglia_generator = Lagged_Fibonacci_generator(seed_1_) - random_generator_2(seed_2_)
        else
            Marsaglia_generator = Lagged_Fibonacci_generator(seed_1_) - random_generator_2()
        end if
    else
        if (present(seed_2_)) then
            Marsaglia_generator = Lagged_Fibonacci_generator() - random_generator_2(seed_2_)
        else
            Marsaglia_generator = Lagged_Fibonacci_generator() - random_generator_2()
        end if
    end if
    if (Marsaglia_generator < 0) then
        Marsaglia_generator = Marsaglia_generator + 16777213 / dble(16777216)
    end if

    contains
        function Lagged_Fibonacci_generator(seed_)
            ! 第一个随机数产生器 - Fibonacci 延迟产生器
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)

            integer(li), intent(in), optional :: seed_
            real(dp) :: Lagged_Fibonacci_generator

            integer :: i
            real(dp), save :: x(98) = [(-1, i = 1, 98)]
            logical :: initialized = .false.

            if (present(seed_)) then
                x(1) = Congruential_16807(seed_)
                initialized = .false.
            else if (x(1) == -1.0d0) then
                do i = 1, 97
                    x(1) = Congruential_16807(1_li)
                end do
                initialized = .false.
            end if

            if (initialized) then
                x(1:97) = x(2:98)
            else
                do i = 2, 97
                    x(i) = Congruential_16807()
                end do
            end if
            x(98) = x(1) - x(65)
            if (x(98) < 0) then
                x(98) = x(98) + 1.d0
            end if
            Lagged_Fibonacci_generator = x(98)
        end function Lagged_Fibonacci_generator

        function random_generator_2(seed_)
            ! 第二个随机数发生器
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)

            integer(li), intent(in), optional :: seed_
            real(dp) :: random_generator_2

            real(dp), save :: last_random_number

            if (present(seed_)) then
                last_random_number = seed_
            end if
            random_generator_2 = last_random_number - 7654321 / dble(16777216)
            if (random_generator_2 < 0) then
                random_generator_2 = random_generator_2 + 16777213 / dble(16777216)
            end if
            last_random_number = random_generator_2
        end function random_generator_2

        function Congruential_16807(seed_)
            ! Schrage 方法 16807 产生器
            implicit none
            integer, parameter :: li = selected_int_kind(10)
            integer, parameter :: dp = selected_real_kind(8)

            integer(li), intent(in), optional :: seed_
            real(dp) :: Congruential_16807

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
            Congruential_16807 = mod(z, m) / dble(m)
        end function Congruential_16807
end function Marsaglia_generator