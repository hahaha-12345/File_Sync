	subroutine get_acc_record(u, record_acc, order_1st, coe_1st, &
							  nx_v, nx, nz_v, nz, nx_bound_l,    &
                              nz_bound_u, nrz0, nt, it, dz,      &
                              order_2nd                          &
                             )

        implicit none

        !Dummy variables
        integer::currshot_range, currshot_range_all,  &
                 nx_v, nx, nz_v, nz, nx_bound_l,      &
                 nz_bound_u, nrz0, nt, it, order_1st, &
                 order_2nd
        real::dz
        real::u(-(order_2nd/2)+1:nx+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), record_acc(nt, nx_v)
        real::coe_1st((order_1st+1) / 2)

        !Local variables
        integer::i, j, ixu, izu, i_FD
        real::sum_z_u_d1

        izu = nrz0 + nz_bound_u

        do i = 1, nx_v

            sum_z_u_d1 = 0.0
            do i_FD = 1, order_2nd/2
                sum_z_u_d1 = sum_z_u_d1 +                                         &
                             (                                                    &
                              coe_1st(i_FD) *                                     &
                              (u(i+nx_bound_l,izu+i_FD)-u(i+nx_bound_l,izu-i_FD)) &
                             )
            enddo
            sum_z_u_d1 = sum_z_u_d1 / dz

            record_acc(it, i) = sum_z_u_d1

        enddo

        return

	end subroutine get_acc_record
