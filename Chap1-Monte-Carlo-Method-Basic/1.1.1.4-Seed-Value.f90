program main
    implicit none

    integer :: seed

    interface
        function get_seed(year_, mon_, day_, hour_, min_, sec_)
            implicit none

            integer, intent(in), optional :: year_, mon_, day_, hour_, min_, sec_
            integer :: get_seed
        end function get_seed
    end interface

    seed = get_seed()
    write(*,*) "Current seed value = ", seed
end program main

function get_seed(year_, mon_, day_, hour_, min_, sec_)
    implicit none

    integer, intent(in), optional :: year_, mon_, day_, hour_, min_, sec_
    integer :: get_seed

    character(10) :: b(3)
    integer :: date_time(8)
    integer :: i_y, i_m, i_d, i_h, i_n, i_s

    if ((present(year_)) .and. (present(mon_)) .and. (present(day_)) .and.&
        (present(hour_)) .and. (present(min_)) .and. (present(sec_))) then
        i_y = mod(year_, 100)
        i_m = mon_
        i_d = day_
        i_h = hour_
        i_n = min_
        i_s = sec_
    else
        call date_and_time(b(1), b(2), b(3), date_time)
        i_y = mod(date_time(1), 100)
        i_m = date_time(2)
        i_d = date_time(3)
        i_h = date_time(5)
        i_n = date_time(6)
        i_s = date_time(7)
    end if

    get_seed = i_y + 70 * (i_m + 12 * (i_d + 31 * (i_h + 23 * (i_n + 59 * i_s))))
    if (get_seed < 0) then
        get_seed = get_seed + 2**31
    end if
end function get_seed