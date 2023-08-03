    subroutine get_currshot_parameters(vz, currshot_vz, nx_v, nz_v,        &
                                       currshot_range, currshot_range_all, &
                                       currshot_xmin, currshot_xmax,       &
                                       nz, nx_bound_l, nx_bound_r,         &
                                       nz_bound_u, nz_bound_d, nsx, nsz0,  &
                                       currshot_nsx, currshot_nsz,         &
                                       order_2nd                           &
                                      )

        use module_constant
        implicit none

        !Dummy variables
        real,intent(in)::vz(nx_v, nz_v)
        integer,intent(in)::nx_v, nz_v, currshot_range, &
							currshot_range_all, nz,     &
							nx_bound_l, nx_bound_r,     &
							nz_bound_u, nz_bound_d,     &
							nsx, nsz0, currshot_xmin,   &
							currshot_xmax, order_2nd
        real,intent(in out)::currshot_vz(-(order_2nd/2)+1:currshot_range_all+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2))
        integer,intent(in out)::currshot_nsx, currshot_nsz

        !Local variables
        integer::i, j, ka, i_ori

        !Compute current shot source_position
        currshot_nsx = nsx - currshot_xmin + nx_bound_l
        currshot_nsz = nsz0 + nz_bound_u

        !Assign and pad the parameters
        do i = 1, currshot_range
            i_ori = i + currshot_xmin
            if(i_ori < 1) i_ori = 1
            if(i_ori > nx_v) i_ori = nx_v
            currshot_vz(i+nx_bound_l, nz_bound_u+1:nz_v+nz_bound_u) = vz(i_ori, 1:nz_v)
        enddo

        !Use a simpler way to velocity
        do j = -(order_2nd/2)+1, nz_bound_u
            do i = -(order_2nd/2)+1, currshot_range_all+(order_2nd/2)
                currshot_vz(i, j) = currshot_vz(i, nz_bound_u+1)
            enddo
        enddo

        do j = nz_bound_u+nz_v+1, nz+(order_2nd/2)
            do i = -(order_2nd/2)+1, currshot_range_all+(order_2nd/2)
                currshot_vz(i, j) = currshot_vz(i, nz_bound_u+nz_v)
            enddo
        enddo

        do j = -(order_2nd/2)+1, nz+(order_2nd/2)
            do i = -(order_2nd/2)+1, nx_bound_l
                currshot_vz(i, j) = currshot_vz(nx_bound_l+1, j)
            enddo
        enddo

        do j = -(order_2nd/2)+1, nz+(order_2nd/2)
            do i = nx_bound_l+currshot_range+1, currshot_range_all+(order_2nd/2)
                currshot_vz(i, j) = currshot_vz(nx_bound_l+currshot_range, j)
            enddo
        enddo

        return

    end subroutine get_currshot_parameters
