    !The basic version of extrapolation function
    !   and much modification need to be applied to it

    subroutine  extrapolation_one_step(vz, nsx, nsz0, nrz0, nx_v, nz_v, nx, nz, dx, dz,            &
                                       nt, dt, f0, nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d, &
                                       order_2nd, order_1st, u1, u2, coe_2nd_10,                   &
                                       coe_2nd_8, coe_2nd_6, coe_2nd_4, coe_2nd_2, coe_1st,        &
                                       u1_1_x, u1_2_x, u2_1_x, u2_2_x,                             &
                                       u2_tmp_1_x, u2_tmp_2_x, u3_1_x, u3_2_x,                     &
                                       u1_1_z, u1_2_z, u2_1_z, u2_2_z,                             &
                                       u2_tmp_1_z, u2_tmp_2_z, u3_1_z, u3_2_z                      &
                                      )

        use module_constant
        implicit none

        !Dummy variables
        integer::nsx, nsz0, nrz0
        integer::nx_v, nz_v, nx, nz, nt
        integer::nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d
        integer::order_2nd, order_1st
        real::dx, dz, dt, f0
        real::vz(-(order_2nd/2)+1:nx+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2))
        real::u1(-(order_2nd/2)+1:nx+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), u2(-(order_2nd/2)+1:nx+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2))
        real::coe_2nd_10(order_2nd / 2)
        real::coe_2nd_8(4)
        real::coe_2nd_6(3)
        real::coe_2nd_4(2)
        real::coe_2nd_2(1)
        real::coe_1st((order_1st+1) / 2)

        real::u1_1_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u1_2_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u2_1_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u2_2_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u2_tmp_1_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u2_tmp_2_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u3_1_x(1:nx_bound_l+nx_bound_r, 1:nz)
        real::u3_2_x(1:nx_bound_l+nx_bound_r, 1:nz)

        real::u1_1_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u1_2_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u2_1_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u2_2_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u2_tmp_1_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u2_tmp_2_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u3_1_z(1:nx, 1:nz_bound_u+nz_bound_d)
        real::u3_2_z(1:nx, 1:nz_bound_u+nz_bound_d)

        !Local variables
        integer::ix, iz, k, ierr, i_FD

        !*Local variables for PML wavefield*
        integer::grid_x_positive_pml, grid_x_negative_pml, &
                 grid_z_positive_pml, grid_z_negative_pml
        real::axis_x_positive_pml,  axis_x_thickness_pml, &
              axis_x_negative_pml,  axis_z_positive_pml,  &
              axis_z_thickness_pml, axis_z_negative_pml
        real::d_attenuation_x_present, deri_d_attenuation_x, &
              d_attenuation_z_present, deri_d_attenuation_z
        real::sum_x_u_d1, sum_x_u_d2, sum_z_u_d2, sum_z_u_d1


        !$OMP PARALLEL PRIVATE(sum_x_u_d2, sum_z_u_d2, sum_x_u_d1, sum_z_u_d1, &
        !$OMP                  d_attenuation_x_present, deri_d_attenuation_x,  &
        !$OMP                  d_attenuation_z_present, deri_d_attenuation_z,  &
        !$OMP                  axis_x_negative_pml, axis_x_thickness_pml,      &
        !$OMP                  grid_x_negative_pml,                            &
        !$OMP                  axis_x_positive_pml, grid_x_positive_pml,       &
        !$OMP                  axis_z_negative_pml, axis_z_thickness_pml,      &
        !$OMP                  grid_z_negative_pml,                            &
        !$OMP                  axis_z_positive_pml, grid_z_positive_pml        &
        !$OMP                 )
        !$OMP DO

        do iz = 1, nz
            do ix = 1, nx

                sum_x_u_d2 = 0.0
                do i_FD = 1, order_2nd/2
			        sum_x_u_d2 = sum_x_u_d2 +                                 &
                                 (                                            &
                                  coe_2nd_10(i_FD) *                          &
	                		      (u2(ix+i_FD,iz)+u2(ix-i_FD,iz)-2*u2(ix,iz)) &
                                 )
                enddo
                sum_x_u_d2 = sum_x_u_d2 / dx**2


                sum_z_u_d2 = 0.0
                do i_FD = 1, order_2nd/2
                    sum_z_u_d2 = sum_z_u_d2 +                                 &
                                 (                                            &
                                  coe_2nd_10(i_FD) *                          &
                                  (u2(ix,iz+i_FD)+u2(ix,iz-i_FD)-2*u2(ix,iz)) &
                                 )
                enddo
                sum_z_u_d2 = sum_z_u_d2 / dz**2


			    if(ix >= nx_bound_l+1  .and.  ix <= nx-nx_bound_r  .and.  &
           		   iz >= nz_bound_u+1  .and.  iz <= nz-nz_bound_d) then

        			u1(ix,iz) = 2*u2(ix,iz) - u1(ix,iz) + dt**2*vz(ix,iz)**2*(sum_x_u_d2+sum_z_u_d2)


                !PML wavefield extrapolation
	            else if(ix <= nx_bound_l) then

	                sum_x_u_d1 = 0.0
                    do i_FD = 1, order_2nd/2
                        sum_x_u_d1 = sum_x_u_d1 +               &
                                     (                          &
                                      coe_1st(i_FD) *           &
	                                  (u2(ix+1,iz)-u2(ix-1,iz)) &
                                     )
                    enddo
                    sum_x_u_d1 = sum_x_u_d1 / dx

                    axis_x_negative_pml  = real(ix-(nx_bound_l+1))*dx
                    axis_x_thickness_pml = real(nx_bound_l)*dx
                    grid_x_negative_pml  = ix

                    !For test
                    d_attenuation_x_present = (3.0*vz(ix,iz)/(2.0*axis_x_thickness_pml)) &
                                              *(axis_x_negative_pml/axis_x_thickness_pml)**2*log(1/R)

                    deri_d_attenuation_x = (3.0*vz(ix,iz)/(2.0*(axis_x_thickness_pml)))* &
                                           (2.0*axis_x_negative_pml/axis_x_thickness_pml**2)*log(1/R)

                    u1_1_x(ix,iz) = (u1_2_x(ix,iz)*(2*dx**2+2*d_attenuation_x_present*dt*dx**2- &
                                    d_attenuation_x_present**2*dx**2*dt**2)-                    &
                                    dx**2*u1_1_x(ix,iz)+vz(ix,iz)**2*dt**2*(sum_x_u_d2*dx**2))/ &
                                    (dx**2+2*d_attenuation_x_present*dt*dx**2)

                    u2_tmp_1_x(ix,iz) = (u2_tmp_2_x(ix,iz)*(2*dx+2*d_attenuation_x_present*dt*dx-  &
                                        dt**2*dx*d_attenuation_x_present**2)-dx*u2_tmp_1_x(ix,iz)- &
                                        vz(ix,iz)**2*dt**2*deri_d_attenuation_x*(sum_x_u_d1*dx))/  &
                                        (dx+2*d_attenuation_x_present*dt*dx)

                    u2_1_x(ix,iz) = u2_2_x(ix,iz)*(1-d_attenuation_x_present*dt)+u2_tmp_1_x(ix,iz)*dt

                    u3_1_x(ix,iz) = 2*u3_2_x(ix,iz)-u3_1_x(ix,iz)+vz(ix,iz)**2*dt**2*(sum_z_u_d2*dz**2)/dz**2

                    u1(ix,iz) = u1_1_x(ix,iz) + u2_1_x(ix,iz) + u3_1_x(ix,iz)


                else if(ix >= nx-nx_bound_r+1) then

                    sum_x_u_d1 = 0.0
                    do i_FD = 0, order_2nd/2
                        sum_x_u_d1 = sum_x_u_d1 +                     &
                                     (                                &
                                      coe_1st(i_FD) *                 &
                                      (u2(ix+i_FD,iz)-u2(ix-i_FD,iz)) &
                                     )
                    enddo
                    sum_x_u_d1 = sum_x_u_d1 / dx

                    axis_x_positive_pml  = real(ix-(nx-nx_bound_r))*dx
                    axis_x_thickness_pml = real(nx_bound_r)*dx
                    grid_x_positive_pml  = ix-(nx-nx_bound_r)+nx_bound_l

                    d_attenuation_x_present = (3.0*vz(ix,iz)/(2.0*axis_x_thickness_pml))* &
                                              (axis_x_positive_pml/axis_x_thickness_pml)**2*log(1/R)

                    deri_d_attenuation_x = (3.0*vz(ix,iz)/(2.0*axis_x_thickness_pml))* &
                                           (2.0*axis_x_positive_pml/axis_x_thickness_pml**2)*log(1/R)

                    u1_1_x(grid_x_positive_pml,iz) = (u1_2_x(grid_x_positive_pml,iz)*             &
                                                     (2*dx**2+2*d_attenuation_x_present*dt*dx**2- &
                                                     d_attenuation_x_present**2*dx**2*dt**2)-     &
                                                     dx**2*u1_1_x(grid_x_positive_pml,iz)+        &
                                                     vz(ix,iz)**2*dt**2*(sum_x_u_d2*dx**2))/      &
                                                     (dx**2+2*d_attenuation_x_present*dt*dx**2)

                    u2_tmp_1_x(grid_x_positive_pml,iz) = (u2_tmp_2_x(grid_x_positive_pml,iz)*   &
                                                         (2*dx+2*d_attenuation_x_present*dt*dx- &
                                                         dt**2*dx*d_attenuation_x_present**2)-  &
                                                         dx*u2_tmp_1_x(grid_x_positive_pml,iz)- &
                                                         vz(ix,iz)**2*dt**2*                    &
                                                         deri_d_attenuation_x*(sum_x_u_d1*dx))/ &
                                                         (dx+2*d_attenuation_x_present*dt*dx)

                    u2_1_x(grid_x_positive_pml,iz) = u2_2_x(grid_x_positive_pml,iz)* &
                                                     (1-d_attenuation_x_present*dt)+ &
                                                     u2_tmp_1_x(grid_x_positive_pml,iz)*dt

                    !Pay attenuation to the subscripts of vz
                    u3_1_x(grid_x_positive_pml,iz) = 2*u3_2_x(grid_x_positive_pml,iz)- &
                                                     u3_1_x(grid_x_positive_pml,iz)+   &
                                                     vz(ix,iz)**2*dt**2*(sum_z_u_d2*dz**2)/dz**2

                    u1(ix,iz) = u1_1_x(grid_x_positive_pml,iz)+ &
                                u2_1_x(grid_x_positive_pml,iz)+ &
                                u3_1_x(grid_x_positive_pml,iz)


                else if(iz <= nz_bound_u) then

                    sum_z_u_d1 = 0.0
                    do i_FD = 1, order_2nd/2
                        sum_z_u_d1 = sum_z_u_d1 +                     &
                                     (                                &
                                      coe_1st(i_FD) *                 &
                                      (u2(ix,iz+i_FD)-u2(ix,iz-i_FD)) &
                                     )
                    enddo
                    sum_z_u_d1 = sum_z_u_d1 / dx

                    axis_z_negative_pml  = real(iz-(nz_bound_u+1))*dz
                    axis_z_thickness_pml = real(nz_bound_u)*dz
                    grid_z_negative_pml  = iz

                    d_attenuation_z_present = (3.0*vz(ix,iz)/(2.0*axis_z_thickness_pml)) &
                                              *(axis_z_negative_pml/axis_z_thickness_pml)**2*log(1/R)

                    deri_d_attenuation_z = (3.0*vz(ix,iz)/(2.0*(axis_z_thickness_pml)))* &
                                           (2.0*axis_z_negative_pml/axis_z_thickness_pml**2)*log(1/R)

                    u1_1_z(ix,iz) = (u1_2_z(ix,iz)*(2*dz**2+2*d_attenuation_z_present*dt*dz**2- &
                                    d_attenuation_z_present**2*dz**2*dt**2)-                    &
                                    dz**2*u1_1_z(ix,iz)+vz(ix,iz)**2*dt**2*(sum_z_u_d2*dz**2))/ &
                                    (dz**2+2*d_attenuation_z_present*dt*dz**2)

                    u2_tmp_1_z(ix,iz) = (u2_tmp_2_z(ix,iz)*(2*dz+2*d_attenuation_z_present*dt*dz- &
                                        dt**2*dz*d_attenuation_z_present**2)-                     &
                                        dz*u2_tmp_1_z(ix,iz)-vz(ix,iz)**2*dt**2*                  &
                                        deri_d_attenuation_z*(sum_z_u_d1*dz))/                    &
                                        (dz+2*d_attenuation_z_present*dt*dz)

                    u2_1_z(ix,iz) = u2_2_z(ix,iz)*(1-d_attenuation_z_present*dt)+u2_tmp_1_z(ix,iz)*dt

                    u3_1_z(ix,iz) = 2*u3_2_z(ix,iz)-u3_1_z(ix,iz)+vz(ix,iz)**2*dt**2*sum_x_u_d2

                    u1(ix,iz) = u1_1_z(ix,iz) + u2_1_z(ix,iz) + u3_1_z(ix,iz)


                else if(iz>=nz-nz_bound_d+1)then

                    sum_z_u_d1 = 0.0
                    do i_FD = 1, order_2nd/2
                        sum_z_u_d1 = sum_z_u_d1 +                     &
                                     (                                &
                                      coe_1st(i_FD) *                 &
                                      (u2(ix,iz+i_FD)-u2(ix,iz-i_FD)) &
                                     )
                    enddo
                    sum_z_u_d1 = sum_z_u_d1 / dz

                    axis_z_positive_pml  = real(iz-(nz-nz_bound_d))*dz
                    axis_z_thickness_pml = real(nz_bound_d)*dz
                    grid_z_positive_pml  = iz-(nz-nz_bound_d)+nz_bound_u

                    d_attenuation_z_present = (3.0*vz(ix,iz)/(2.0*axis_z_thickness_pml))* &
                                              (axis_z_positive_pml/axis_z_thickness_pml)**2*log(1/R)

                    deri_d_attenuation_z = (3.0*vz(ix,iz)/(2.0*(axis_z_thickness_pml)))* &
                                           (2.0*axis_z_positive_pml/axis_z_thickness_pml**2)*log(1/R)

                    u1_1_z(ix,grid_z_positive_pml) = (u1_2_z(ix,grid_z_positive_pml)*             &
                                                     (2*dz**2+2*d_attenuation_z_present*dt*dz**2- &
                                                     d_attenuation_z_present**2*dz**2*dt**2)-     &
                                                     dz**2*u1_1_z(ix,grid_z_positive_pml)+        &
                                                     vz(ix,iz)**2*dt**2*(sum_z_u_d2*dz**2))/      &
                                                     (dz**2+2*d_attenuation_z_present*dt*dz**2)

                    u2_tmp_1_z(ix,grid_z_positive_pml) = (u2_tmp_2_z(ix,grid_z_positive_pml)*   &
                                                         (2*dz+2*d_attenuation_z_present*dt*dz- &
                                                         dt**2*dz*d_attenuation_z_present**2)-  &
                                                         dz*u2_tmp_1_z(ix,grid_z_positive_pml)- &
                                                         vz(ix,iz)**2*dt**2*                    &
                                                         deri_d_attenuation_z*(sum_z_u_d1*dz))/ &
                                                         (dz+2*d_attenuation_z_present*dt*dz)

                    u2_1_z(ix,grid_z_positive_pml) = u2_2_z(ix,grid_z_positive_pml)* &
                                                     (1-d_attenuation_z_present*dt)+ &
                                                     u2_tmp_1_z(ix,grid_z_positive_pml)*dt

                    u3_1_z(ix,grid_z_positive_pml) = 2*u3_2_z(ix,grid_z_positive_pml)- &
                                                     u3_1_z(ix,grid_z_positive_pml)+   &
                                                     vz(ix,iz)**2*dt**2*sum_x_u_d2

                    u1(ix,iz) = u1_1_z(ix,grid_z_positive_pml) + u2_1_z(ix,grid_z_positive_pml) + &
                                u3_1_z(ix,grid_z_positive_pml)


                endif

            enddo
        enddo

        !$OMP END DO
        !$OMP END PARALLEL

    end subroutine extrapolation_one_step
