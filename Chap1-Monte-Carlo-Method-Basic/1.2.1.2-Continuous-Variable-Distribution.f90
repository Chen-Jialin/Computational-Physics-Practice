program main
    implicit none

    integer, allocatable :: seed(:)
    integer :: n
    integer :: i

    interface
        function Free_path(lambda)
            ! 利用变换抽样法产生粒子随机运动的自由程分布
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in) :: lambda
            real(dp) :: Free_path
        end function Free_path

        function Scattering_azimuth_angle()
            ! 利用变换抽样法产生粒子输运问题中散射方位角余弦分布
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp) :: Scattering_azimuth_angle
        end function Scattering_azimuth_angle

        function Random_pt_on_sphere(rho_)
            ! 利用变换抽样法产生球面上均匀分布的随机坐标点的 (rho,theta,phi) 坐标
            implicit none
            integer, parameter :: dp = selected_real_kind(8)

            real(dp), intent(in), optional :: rho_
            real(dp) :: Random_pt_on_sphere(3) ! rho, theta, phi
        end function Random_pt_on_sphere
    end interface

    call random_seed(size=n)
    allocate(seed(n))
    seed = 1
    call random_seed(put=seed)
    do i = 1, 100
        write(*,*) Free_path(1.d0)
    end do

    do i = 1, 100
        write(*,*) Scattering_azimuth_angle()
    end do

    open(unit=11, file='1.2.1.2-Random-Points-on-Sphere.txt', status='replace')
    do i = 1, 1000
        write(11,'(3f16.8)') Random_pt_on_sphere()
    end do
    close(11)
end program main

function Free_path(lambda)
    ! 利用变换抽样法产生粒子随机运动的自由程分布
    implicit none
    integer, parameter :: dp = selected_real_kind(8)

    real(dp), intent(in) :: lambda
    real(dp) :: Free_path

    real :: xi

    call random_number(xi)
    Free_path = -lambda * log(xi)
end function Free_path

function Scattering_azimuth_angle()
    ! 利用变换抽样法产生粒子输运问题中散射方位角余弦分布
    implicit none
    integer, parameter :: dp = selected_real_kind(8)
    real(dp), parameter :: pi = acos(-1.d0)

    real(dp) :: Scattering_azimuth_angle

    real(dp) :: xi

    call random_number(xi)
    Scattering_azimuth_angle = sin(2 * pi * xi)
end function Scattering_azimuth_angle

function Random_pt_on_sphere(rho_)
    ! 利用变换抽样法产生球面上均匀分布的随机坐标点的 (rho,theta,phi) 坐标
    implicit none
    integer, parameter :: dp = selected_real_kind(8)
    real(dp), parameter ::pi = acos(-1.d0)

    real(dp), intent(in), optional :: rho_
    real(dp) :: Random_pt_on_sphere(3) ! rho, theta, phi

    real(dp) :: xi

    if (present(rho_)) then
        Random_pt_on_sphere(1) = rho_
    else
        Random_pt_on_sphere(1) = 1.d0
    end if

    call random_number(xi)
    Random_pt_on_sphere(2) = acos(2.d0 * xi - 1.d0)
    call random_number(xi)
    Random_pt_on_sphere(3) = 2 * pi * xi
end function Random_pt_on_sphere