program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, allocatable :: seed(:)
    integer :: n
    real(dp) :: t_begin, t_end
    integer :: i, num_pt = 1000

    interface
        function Random_pt_annulus_general(r_1_, r_2_)
            ! 变换抽样一般方法产生圆环上均匀分布的随机点
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in), optional :: r_1_, r_2_
            real(dp) :: Random_pt_annulus_general(2) ! (r, theta)
        end function Random_pt_annulus_general

        function Random_pt_annulus(r_1_, r_2_)
            ! 抽样法产生圆环上均匀分布的随机点
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in), optional :: r_1_, r_2_
            real(dp) :: Random_pt_annulus(2)
        end function Random_pt_annulus

        function Gaussian_Box_Muller_improved(x_bar_, sigma_square_)
            ! Box-Muller 法产生服从正态分布的随机数，其中随机数的三角函数通过抽样得到
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in), optional :: x_bar_, sigma_square_ ! 均值和方差
            real(dp) :: Gaussian_Box_Muller_improved
        end function Gaussian_Box_Muller_improved

        function Marsaglia_3d_sphere()
            ! 三维球面上的 Marsaglia 方法
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp) :: Marsaglia_3d_sphere(3) ! (x, y, z)
        end function Marsaglia_3d_sphere
    end interface

    call random_seed(size=n)
    allocate(seed(n))
    seed = 1
    call random_seed(put=seed)
    call cpu_time(t_begin)
    open(unit=11, file='1.2.2.3-Random-Points-on-Annulus-Transform-Sampling-General-Method.txt', status='replace')
    do i = 1, num_pt
        write(11, '(2f16.8)') Random_pt_annulus_general(1.d0, 2.d0)
    end do
    close(11)
    call cpu_time(t_end)
    write(*,*)&
    'Generate random points uniformly distributed on annulus by transform sampling general method. Time consumed = ',&
    t_end - t_begin

    call cpu_time(t_begin)
    open(unit=11, file='1.2.2.3-Random-Points-on-Annulus-Sampling.txt', status='replace')
    do i = 1, num_pt
        write(11, '(2f16.8)') Random_pt_annulus(1.d0, 2.d0)
    end do
    close(11)
    call cpu_time(t_end)
    write(*,*)&
    'Generate random points uniformly distributed on annulus by sampling. Time consumed = ',&
    t_end - t_begin

    open(unit=11, file='1.2.2.3-Gaussian-Random-Variable.txt', status='replace')
    do i = 1, num_pt
        write(11, '(f16.8)') Gaussian_Box_Muller_improved(1.d0, 1.d0)
    end do
    close(11)

    open(unit=11, file='1.2.2.3-Random-Points-on-3d-Sphere.txt')
    do i = 1, num_pt
        write(11, '(3f16.8)') Marsaglia_3d_sphere()
    end do
    close(11)
end program main

function Random_pt_annulus_general(r_1_, r_2_)
    ! 变换抽样一般方法产生圆环上均匀分布的随机点
    implicit none
    integer, parameter :: dp = selected_real_kind(8)
    real(dp), parameter :: pi = acos(-1.d0)

    real(dp), intent(in), optional :: r_1_, r_2_
    real(dp) :: Random_pt_annulus_general(2) ! (x, y)

    real(dp) :: r_inner, r_outer ! 内径和外径
    real(dp) :: xi
    real(dp) :: r, theta

    if ((present(r_1_)) .and. (present(r_2_))) then
        if (r_1_ < r_2_) then
            r_inner = r_1_
            r_outer = r_2_
        else if (r_1_ > r_2_) then
            r_inner = r_2_
            r_outer = r_1_
        else
            write(*,*) 'Inner radius equals outer radius, cannot generate random points.'
            Random_pt_annulus_general = 0.d0
            return
        end if
    else
        r_inner = 0.d0
        r_outer = 1.d0
    end if

    call random_number(xi)
    r = sqrt((r_outer**2.d0 - r_inner**2.d0) * xi + r_inner**2.d0)
    call random_number(xi)
    theta = 2.d0 * pi * xi
    Random_pt_annulus_general(1) = r * cos(theta)
    Random_pt_annulus_general(2) = r * sin(theta)
end function Random_pt_annulus_general

function Random_pt_annulus(r_1_, r_2_)
    ! hit-or-miss 法产生圆环上均匀分布的随机点
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp), intent(in), optional :: r_1_, r_2_
    real(dp) :: Random_pt_annulus(2) ! (x, y)

    real(dp) :: r_inner, r_outer ! 内径和外径

    if ((present(r_1_)) .and. (present(r_2_))) then
        if (r_1_ < r_2_) then
            r_inner = r_1_
            r_outer = r_2_
        else if (r_1_ > r_2_) then
            r_inner = r_2_
            r_outer = r_1_
        else
            write(*,*) 'Inner radius equals outer radius, cannot generate random points.'
            Random_pt_annulus = 0.d0
            return
        end if
    else
        r_inner = 0.d0
        r_outer = 1.d0
    end if

    do while (.true.)
        call random_number(Random_pt_annulus(1))
        call random_number(Random_pt_annulus(2))
        Random_pt_annulus = (2 * Random_pt_annulus - 1) * r_outer
        if ((r_inner**2 <= sum(Random_pt_annulus**2)) .and. (sum(Random_pt_annulus**2) < r_outer**2)) then
            return
        end if
    end do
end function

function Gaussian_Box_Muller_improved(x_bar_, sigma_square_)
    ! Box-Muller 法产生服从正态分布的随机数，其中随机数的三角函数通过 hit-or-miss 法得到
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp), intent(in), optional :: x_bar_, sigma_square_ ! 均值和方差
    real(dp) :: Gaussian_Box_Muller_improved

    real(dp) :: x_bar, sigma_square
    real(dp) :: u, v, xi

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

    do while (.true.)
        call random_number(u)
        call random_number(v)
        u = 2.d0 * u - 1.d0
        v = 2.d0 * v - 1.d0
        if (u**2.d0 + v**2.d0 < 1.d0) then
            exit
        end if
    end do
    call random_number(xi)
    Gaussian_Box_Muller_improved = u * sqrt(-2.d0 * log(xi))
    ! Gaussian_Box_Muller_improved = v * sqrt(-2.d0 * log(xi))
    Gaussian_Box_Muller_improved = Gaussian_Box_Muller_improved * sqrt(sigma_square) + x_bar
end function Gaussian_Box_Muller_improved

function Marsaglia_3d_sphere()
    ! 三维球面上的 Marsaglia 方法
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp) :: Marsaglia_3d_sphere(3) ! (x, y, z)

    real(dp) :: u, v, r_square

    do while (.true.)
        call random_number(u)
        call random_number(v)
        u = 2.d0 * u - 1.d0
        v = 2.d0 * v - 1.d0
        r_square = u**2.d0 + v**2.d0
        if (r_square <= 1) then
            exit
        end if
    end do

    Marsaglia_3d_sphere(1) = 2.d0 * u * sqrt(1 - r_square)
    Marsaglia_3d_sphere(2) = 2.d0 * v * sqrt(1 - r_square)
    Marsaglia_3d_sphere(3) = 1 - 2.d0 * r_square
end function Marsaglia_3d_sphere