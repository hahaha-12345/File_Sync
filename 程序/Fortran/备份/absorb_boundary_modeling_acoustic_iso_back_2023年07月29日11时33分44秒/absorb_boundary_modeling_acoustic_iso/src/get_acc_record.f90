	subroutine get_acc_record(u, record_acc, order_1st, coe_1st, &
							  nx_v, nx, nz_v, nz, nx_bound_l,    &
                              nz_bound_u, nrz0, nt, it, dz       &
                             )

        implicit none

        !Dummy variables
        integer::currshot_range, currshot_range_all, &
                 nx_v, nx, nz_v, nz, nx_bound_l,     &
                 nz_bound_u, nrz0, nt, it, order_1st
        real::dz
        real::u(-4:nx+5, -4:nz+5), record_acc(nt, nx_v), &
              coe_1st((order_1st+1) / 2)

        !Local variables
        integer::i, j, ixu, izu
        real::sum_z_u_d1

        izu = nrz0 + nz_bound_u

        do i = 1, nx_v

            sum_z_u_d1 = (coe_1st(1) *                                    &
                          (u(i+nx_bound_l,izu+1)-u(i+nx_bound_l,izu-1)) + &
                          coe_1st(2) *                                    &
                          (u(i+nx_bound_l,izu+2)-u(i+nx_bound_l,izu-2)) + &
                          coe_1st(3) *                                    &
                          (u(i+nx_bound_l,izu+3)-u(i+nx_bound_l,izu-3)) + &
                          coe_1st(4) *                                    &
                          (u(i+nx_bound_l,izu+4)-u(i+nx_bound_l,izu-4)) + &
                          coe_1st(5) *                                    &
                          (u(i+nx_bound_l,izu+5)-u(i+nx_bound_l,izu-5))   &
                         )                                                &
                          / dz

                record_acc(it, i) = sum_z_u_d1

        enddo

        return

	end subroutine get_acc_record
