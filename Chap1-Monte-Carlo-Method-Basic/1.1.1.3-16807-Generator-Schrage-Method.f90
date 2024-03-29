program main
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer :: a, b, m
    common /group1/ a, b, m
    integer :: i
    integer, parameter :: num_pt = 20000000
    real(dp) :: x(num_pt), y(num_pt)
    real(dp) :: chi, chi_alpha

    interface
        function Schrage_16807(seed_)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, intent(in), optional :: seed_
            real(dp) :: Schrage_16807
        end function Schrage_16807

        function Chi_square(x, y, num_split_)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in) :: x(:), y(:) ! x, y 坐标
            integer, intent(in), optional :: num_split_
            real(dp) :: Chi_square
        end function Chi_square

        function Chi_alpha_square(nu_, alpha_)
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            integer, optional :: nu_ ! 自由度
            real(dp), intent(in), optional :: alpha_ ! 显著水平
            real(dp) :: Chi_alpha_square
        end function Chi_alpha_square
    end interface

    a = 7**5
    b = 0
    m = 2**31 - 1
    do  i = 1, num_pt
        x(i) = Schrage_16807()
        y(i) = Schrage_16807()
    end do
    open(unit=11, file='1.1.1.3-Schrage-Method-1.txt', status='replace')
    do i = 1, 10000
        write(11, '(2f16.8)') x(i), y(i)
    end do
    close(11)

    chi = sqrt(Chi_square(x, y))
    chi_alpha = sqrt(Chi_alpha_square())

    write(*,*) 'chi = ', chi
    write(*,*) 'chi_alpha = ', chi_alpha
    if (chi < chi_alpha) then
        write(*,*) 'The random number series are uniformly distributed over [0,1).'
    else
        write(*,*) 'The random number series are not uniformly distributed over [0,1).'
    end if

    a = 106
    b = 1288
    m = 6075
    x(1) = Schrage_16807(1)
    y(1) = Schrage_16807()
    do  i = 2, num_pt
        x(i) = Schrage_16807()
        y(i) = Schrage_16807()
    end do
    open(unit=11, file='1.1.1.3-Schrage-Method-2.txt', status='replace')
    do i = 1, 10000
        write(11, '(2f16.8)') x(i), y(i)
    end do
    close(11)

    chi = sqrt(Chi_square(x, y))
    chi_alpha = sqrt(Chi_alpha_square())

    write(*,*) 'chi = ', chi
    write(*,*) 'chi_alpha = ', chi_alpha
    if (chi < chi_alpha) then
        write(*,*) 'The random number series are uniformly distributed over [0,1).'
    else
        write(*,*) 'The random number series are not uniformly distributed over [0,1).'
    end if
end program main

function Schrage_16807(seed_)
    ! Schrage 方法实现 16807 产生器
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, intent(in), optional :: seed_
    real(dp) :: Schrage_16807

    integer :: a, b, m
    common /group1/ a, b, m
    integer :: q, r
    integer, save :: z = -1

    q = m / a
    r = mod(m, a)
    if (present(seed_)) then
        z = seed_
    else if (z == -1) then
        z = 1
    end if
    z = a * mod(z, q) - r * (z / q)
    if (z < 0) then
        z = z + m
    end if
    z = z + b
    if (z >= m) then
        z = z - m
    end if
    Schrage_16807 = z / dble(m)
end function Schrage_16807

function Chi_square(x, y, num_split_)
    ! 统计量 chi^2
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp), intent(in) :: x(:), y(:) ! x, y 坐标
    integer, intent(in), optional :: num_split_ ! x, y 方向上各分割成 num_split 个区间
    real(dp) :: Chi_square

    integer :: i, j
    integer :: num_split
    integer, allocatable :: n(:) ! 实际频数
    real(dp) :: m ! 理论频数

    num_split = 10
    if (present(num_split_)) then
        num_split = num_split_
    end if
    allocate(n(num_split**2))

    m = size(x) / dble(num_split**2)

    do i = 1, num_split
        do j = 1, num_split
            n((i - 1) * num_split + j) = count((((i-1) / dble(num_split)) <= x) .and. (x < (i / dble(num_split))) .and.&
            (((j - 1) / dble(num_split)) <= y) .and. (y < (j / dble(num_split))))
        end do
    end do

    Chi_square = sum((n - m)**2 / dble(m))
end function Chi_square

function Chi_alpha_square(nu_, alpha_)
    ! chi_alpha^2
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    integer, optional :: nu_ ! 自由度
    real(dp), intent(in), optional :: alpha_ ! 显著水平
    real(dp) :: Chi_alpha_square

    integer :: nu
    real(dp) :: P_fiducial ! 置信概率
    integer :: i
    real(dp) :: x_lower_bound = 0.d0, x_upper_bound = 1.d0

    nu = 99
    if (present(nu_)) then
        nu = nu_
    end if
    P_fiducial = 0.95
    if (present(alpha_)) then
        P_fiducial = 1.d0 - alpha_
    end if

    do while (.not. ((P_chi_square(x_lower_bound, nu) <= P_fiducial) .and. (P_chi_square(x_upper_bound, nu) > P_fiducial)))
        x_lower_bound = x_upper_bound
        x_upper_bound = 2.d0 * x_upper_bound
    end do
    do i = 1, 10
        if ((P_chi_square((x_lower_bound + x_upper_bound) / 2.d0, nu) <= P_fiducial)) then
            x_lower_bound = (x_lower_bound + x_upper_bound) / 2.d0
        else
            x_upper_bound = (x_lower_bound + x_upper_bound) / 2.d0
        end if
    end do
    Chi_alpha_square = (x_lower_bound + x_upper_bound) / 2.d0

    contains
        function P_chi_square(x, nu, num_pt_)
            ! chi^2 分布的累计分布函数，其中积分项利用 Simpson 法计算
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in) :: x
            integer, intent(in) :: nu
            integer, optional :: num_pt_ ! 必须为奇数
            real(dp) :: P_chi_square

            integer :: num_pt, num_sect
            real(dp) :: dx
            real(dp), allocatable :: integrand(:)
            integer :: i

            if (x == 0.d0) then
                P_chi_square = 0.0
                return
            end if
            if (.not. (present(num_pt_))) then
                num_pt = 101
            else if (mod(num_pt_, 2) == 0) then
                write(*,*) 'Even elements, Simpson does not know how to work!'
                P_chi_square = 0.0
                return
            end if
            num_sect = num_pt - 1
            dx = x / dble(num_sect)
            allocate(integrand(0:num_sect))

            integrand = [((i * dx)**((nu - 2) / 2.d0) * exp(-i * dx / 2.d0),&
                i=0, num_sect)]

            P_chi_square = P_chi_square + integrand(0) + integrand(num_sect)
            P_chi_square = P_chi_square + 4.d0 * sum(integrand(1:num_sect - 1:2))
            P_chi_square = P_chi_square + 2.d0 * sum(integrand(2:num_sect - 2:2))
            P_chi_square = P_chi_square * dx / 3.d0
            P_chi_square = P_chi_square / 2**(nu / 2.d0) / Gamma(nu / 2.d0)
        end function P_chi_square
end function Chi_alpha_square