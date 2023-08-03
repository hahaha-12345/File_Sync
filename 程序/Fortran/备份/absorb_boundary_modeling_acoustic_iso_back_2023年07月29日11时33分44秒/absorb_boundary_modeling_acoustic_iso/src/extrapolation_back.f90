    !The basic version of extrapolation function
    !   and much modification need to be applied to it

    subroutine extrapolation_back(vz, nsx, nsz0, nrz0, nx_v, nz_v, nx, nz, dx, dz,                &
                                  nt, dt, f0, nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d,     &
                                  order_2nd, order_1st, u1, u2,                                   &
							      coe_2nd_10, coe_2nd_8, coe_2nd_6, coe_2nd_4, coe_2nd_2, coe_1st &
                                 )

        use constant
        implicit none

        !Dummy variables
        real::vz(-4:nx+5, -4:nz+5)
        integer::nsx, nsz0, nrz0
        integer::nx_v, nz_v, nx, nz, nt
        integer::nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d
        integer::order_2nd, order_1st
        real::dx, dz, dt, f0
        real::u1(-4:nx+5, -4:nz+5), u2(-4:nx+5, -4:nz+5)
        real::coe_2nd_10(order_2nd / 2)
        real::coe_2nd_8(4)
        real::coe_2nd_6(3)
        real::coe_2nd_4(2)
        real::coe_2nd_2(1)
        real::coe_1st((order_1st+1) / 2)

        real::sum_x_u_d2, sum_z_u_d2

        !Local variables
        integer::ix, iz, k, ierr

        !$OMP PARALLEL PRIVATE(sum_x_u_d2, sum_z_u_d2)
        !$OMP DO
        do iz = nz_bound_u+1, nz-nz_bound_d
            do ix = nx_bound_l+1, nx-nx_bound_r

                sum_x_u_d2 = (coe_2nd_10(1) *                         &
                              (u2(ix+1,iz)+u2(ix-1,iz)-2*u2(ix,iz)) + &
                              coe_2nd_10(2) *                         &
                              (u2(ix+2,iz)+u2(ix-2,iz)-2*u2(ix,iz)) + &
                              coe_2nd_10(3) *                         &
                              (u2(ix+3,iz)+u2(ix-3,iz)-2*u2(ix,iz)) + &
                              coe_2nd_10(4) *                         &
                              (u2(ix+4,iz)+u2(ix-4,iz)-2*u2(ix,iz)) + &
                              coe_2nd_10(5) *                         &
                              (u2(ix+5,iz)+u2(ix-5,iz)-2*u2(ix,iz))   &
                             )                                        &
                              / dx**2


                sum_z_u_d2 = (coe_2nd_10(1) *                         &
                              (u2(ix,iz+1)+u2(ix,iz-1)-2*u2(ix,iz)) + &
                              coe_2nd_10(2) *                         &
                              (u2(ix,iz+2)+u2(ix,iz-2)-2*u2(ix,iz)) + &
                              coe_2nd_10(3) *                         &
                              (u2(ix,iz+3)+u2(ix,iz-3)-2*u2(ix,iz)) + &
                              coe_2nd_10(4) *                         &
                              (u2(ix,iz+4)+u2(ix,iz-4)-2*u2(ix,iz)) + &
                              coe_2nd_10(5) *                         &
                              (u2(ix,iz+5)+u2(ix,iz-5)-2*u2(ix,iz))   &
                             )                                        &
                              / dz**2


                u1(ix, iz) = 2 * u2(ix,iz) - u1(ix,iz) + &
                             dt**2 * vz(ix,iz)**2 * (sum_x_u_d2+sum_z_u_d2)

            enddo
        enddo

        !$OMP END DO
        !$OMP END PARALLEL

    end subroutine extrapolation_back
