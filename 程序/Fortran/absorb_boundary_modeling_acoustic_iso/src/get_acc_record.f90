	subroutine get_acc_record(u, record_acc, order_1st, coe_1st,      &
							  nx_v, nx, nz_v, nz, nx_bound_l,         &
                              nz_bound_u, nrz0, nrx0, nt, it, dz, dx, &
                              order_2nd,nsx,offset_min                &
                             )

        implicit none

        !Dummy variables
        integer::currshot_range, currshot_range_all, &
                 nx_v, nx, nz_v, nz, nx_bound_l,     &
                 nz_bound_u, nrz0, nrx0, nt, it,     &
                 order_1st, order_2nd, nsx
        real::dz, dx, offset_min
        real::u(-(order_2nd/2)+1:nx+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2))
        !real::record_acc(nt, nx_v)
        real::record_acc(nt, nz_v)
        real::coe_1st((order_1st+1) / 2)

        !Local variables
        integer::i, j, ixu, izu, ixl, i_FD
        real::sum_z_u_d1, sum_x_l_d1

        izu = nrz0 + nz_bound_u
        ixl = nrx0 + nx_bound_l + (abs(int(offset_min/dx))-nsx)

        do i = 1, nz_v

            sum_x_l_d1 = 0.0
            do i_FD = 1, order_2nd/2
                sum_x_l_d1 = sum_x_l_d1 +                                         &
                             (                                                    &
                              coe_1st(i_FD) *                                     &
                              (u(ixl+i_FD,i+nz_bound_u)-u(ixl-i_FD,i+nz_bound_u)) &
                             )
            enddo
            sum_x_l_d1 = sum_x_l_d1 / dx

            record_acc(it, i) = sum_x_l_d1

        enddo
!        do i = 1, nx_v
!
!            sum_z_u_d1 = 0.0
!            do i_FD = 1, order_2nd/2
!                sum_z_u_d1 = sum_z_u_d1 +                                         &
!                             (                                                    &
!                              coe_1st(i_FD) *                                     &
!                              (u(i+nx_bound_l,izu+i_FD)-u(i+nx_bound_l,izu-i_FD)) &
!                             )
!            enddo
!            sum_z_u_d1 = sum_z_u_d1 / dz
!
!            record_acc(it, i) = sum_z_u_d1
!
!        enddo

        return

	end subroutine get_acc_record
