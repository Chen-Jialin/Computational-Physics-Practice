program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, allocatable :: seed(:)
    integer :: n
    integer :: i
    real(dp) :: x_bar = 1.d0, sigma_square = 1.d0

    interface
        function Gaussian_Box_Muller_method(x_bar_, sigma_square_)
            ! Box-Muller 法产生服从正态分布随机数
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in), optional :: x_bar_, sigma_square_ ! 均值和方差
            real(dp) :: Gaussian_Box_Muller_method
        end function Gaussian_Box_Muller_method
    end interface

    call random_seed(size=n)
    allocate(seed(n))
    seed = 1
    call random_seed(put=seed)
    open(unit=11, file='1.2.2.2-Gaussian-Random-Variable.txt', status='replace')
    do i = 1,10000
        write(11, '(f16.8)') Gaussian_Box_Muller_method(x_bar, sigma_square)
    end do
    close(11)
end program main

function Gaussian_Box_Muller_method(x_bar_, sigma_square_)
    ! Box-Muller 法产生服从正态分布随机数
    implicit none
    integer, parameter :: dp = selected_real_kind(8)
    real(dp), parameter :: pi = acos(-1.d0)

    real(dp), intent(in), optional :: x_bar_, sigma_square_ ! 均值和方差
    real(dp) :: Gaussian_Box_Muller_method

    real(dp) :: x_bar, sigma_square
    real(dp) :: u, v

    if (present(x_bar_)) then
        x_bar = x_bar_
    else
        x_bar = 0.d0
    end if
    if (present(sigma_square_)) then
        sigma_square = sigma_square_
    else
        sigma_square = 1.d0
    end if

    call random_number(u)
    call random_number(v)
    Gaussian_Box_Muller_method = sqrt(-2.d0 * log(u)) * cos(2.d0 * pi * v)
    ! Gaussian_Box_Muller_method = sqrt(-2.d0 * log(u)) * sin(2.d0 * pi * v)
    Gaussian_Box_Muller_method = Gaussian_Box_Muller_method * sigma_square**2 + x_bar
end function Gaussian_Box_Muller_method