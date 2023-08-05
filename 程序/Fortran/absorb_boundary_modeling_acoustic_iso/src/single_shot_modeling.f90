    subroutine single_shot_modeling(vz, currshot_xmin, currshot_xmax,  &
                                    nsx, nsz0, nrz0, nx_v, nz_v, dx,   &
                                    dz, nt, dt, f0, nx_bound_l,        &
                                    nx_bound_r, nz_bound_u,nz_bound_d, &
                                    order_2nd, order_1st, shot_fn1,    &
                                    shot_fn2, shot_fn3, shot_fn4,      &
                                    currshot_name, currshot_num,       &
                                    offset_min, offset_max,            &
                                    myid                               &
                                   )

        use module_constant
        implicit none

        !Dummy variables
        real::vz(nx_v, nz_v)
        integer::nsx, nsz0, nrz0
        integer::currshot_xmin, currshot_xmax
        integer::nx_v, nz_v, nt,         &
                 nx_bound_l, nx_bound_r, &
                 nz_bound_u, nz_bound_d
        integer::order_2nd, order_1st
        integer::myid
        real::dx, dz, dt, f0
        integer::currshot_num
        real::offset_min, offset_max
        character(len=256)::shot_fn1
        character(len=256)::shot_fn2
        character(len=256)::shot_fn3
        character(len=256)::shot_fn4
        character(len=256)::currshot_name

        !Local variables
        !*Buffers for finite_difference*
        real,allocatable::u1(:,:)
        real,allocatable::u2(:,:)
        real,allocatable::u2_snapshot(:,:)

        real,allocatable::record(:,:)
        real,allocatable::record_acc(:,:)

        real,allocatable::coe_2nd_10(:)
        real,allocatable::coe_2nd_8(:)
        real,allocatable::coe_2nd_6(:)
        real,allocatable::coe_2nd_4(:)
        real,allocatable::coe_2nd_2(:)
        real,allocatable::coe_1st(:)

        real,allocatable::currshot_vz(:,:)

        real,allocatable::top(:,:)
        real,allocatable::bot(:,:)
        real,allocatable::lef(:,:)
        real,allocatable::rig(:,:)

        real,allocatable::u3(:,:)
        real,allocatable::u4(:,:)

		integer::ix, iz

        !*Buffers for PML wavefield*
        !**Buffers for P wave**
        real,allocatable::u1_1_x(:,:), u1_2_x(:,:), &
                          u2_1_x(:,:), u2_2_x(:,:), &
                          u2_tmp_1_x(:,:),          &
                          u2_tmp_2_x(:,:),          &
                          u3_1_x(:,:), u3_2_x(:,:), &
                          u1_1_z(:,:), u1_2_z(:,:), &
                          u2_1_z(:,:), u2_2_z(:,:), &
                          u2_tmp_1_z(:,:),          &
                          u2_tmp_2_z(:,:),          &
                          u3_1_z(:,:), u3_2_z(:,:)

        !*Variables for wavefield extrapolation*
        integer::currshot_range, currshot_range_all, &
                 nz, currshot_nsx, currshot_nsz

        !*Other local variables*
        integer::i, i_ori, j, k, it, iit, err
        integer::nwt, decay
		character(len=256)::currt, currtsnap
		character(len=256)::snap_fn1 = &
		'/mnt/work/百度网盘下载/博士后/数据/福州地铁2号线延伸段下穿三江口大桥北立交桥梁安全监测初步方案/synthetic_data/2D/snapshot/1/iso_P_wave_snapshot_2_times_'
		character(len=256)::snap_fn2 = &
        '/mnt/work/百度网盘下载/博士后/数据/福州地铁2号线延伸段下穿三江口大桥北立交桥梁安全监测初步方案/synthetic_data/2D/snapshot/2/iso_'
		character(len=256)::snap_fn3 = &
        '/mnt/work/百度网盘下载/博士后/数据/福州地铁2号线延伸段下穿三江口大桥北立交桥梁安全监测初步方案/synthetic_data/2D/snapshot/3/iso_'
		character(len=256)::snap_fn4 = &
        '/mnt/work/百度网盘下载/博士后/数据/福州地铁2号线延伸段下穿三江口大桥北立交桥梁安全监测初步方案/synthetic_data/2D/snapshot/4/iso_'

        integer::counter=1

        !Computing currshot range
        currshot_range = (currshot_xmax - currshot_xmin) + 1
        !currshot_range_all = currshot_range + (nx_bound_l + nx_bound_r) - 2
        currshot_range_all = currshot_range + (nx_bound_l + nx_bound_r)
        nz = nz_v + (nz_bound_u + nz_bound_d)
        !nz = nz_v + (nz_bound_u + nz_bound_d) - 2

        !compute the length of wavelet in time dimension
        nwt = 2 * nint(1.0 / (f0 * dt))
		write(*,*) 'currshot_range', currshot_range
		write(*,*) 'currshot_range_all', currshot_range_all
		write(*,*) 'nz_v=', nz_v, 'nz=', nz

        !Allocate memories for buffers
        allocate(u1(-(order_2nd/2)+1:currshot_range_all+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), STAT=err)
        allocate(u2(-(order_2nd/2)+1:currshot_range_all+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), STAT=err)
        allocate(u2_snapshot(1:nx_v, 1:nz_v), STAT=err)

        allocate(record(nt, currshot_range), STAT=err)
        allocate(record_acc(nt, currshot_range), STAT=err)
        allocate(coe_2nd_10(order_2nd / 2), STAT=err) !表示 10 阶和更高阶的有限差分
        allocate(coe_2nd_8(4), STAT=err)
        allocate(coe_2nd_6(3), STAT=err)
        allocate(coe_2nd_4(2), STAT=err)
        allocate(coe_2nd_2(1), STAT=err)

        allocate(coe_1st((order_1st + 1) / 2), STAT=err)
        allocate(currshot_vz(currshot_range_all + order_2nd,nz + order_2nd))

        allocate(top(currshot_range, nt))
        allocate(bot(currshot_range, nt))
        allocate(lef(nz_v, nt))
        allocate(rig(nz_v, nt))

        allocate(u3(-(order_2nd/2)+1:currshot_range_all+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), STAT=err)
        allocate(u4(-(order_2nd/2)+1:currshot_range_all+(order_2nd/2), -(order_2nd/2)+1:nz+(order_2nd/2)), STAT=err)

        !*Buffers for PML wavefield*
        !**Buffers for P wave**
        !***X direction***
!        allocate(u1_1_x(1:nx_bound_l+nx_bound_r,1:nz))
        allocate(u1_1_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u1_2_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u2_1_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u2_2_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u2_tmp_1_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u2_tmp_2_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u3_1_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        allocate(u3_2_x(1:nx_bound_l+nx_bound_r, 1:nz), STAT=err)
        !***Z direction***
        allocate(u1_1_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u1_2_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u2_1_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u2_2_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u2_tmp_1_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u2_tmp_2_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u3_1_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)
        allocate(u3_2_z(1:currshot_range_all, 1:nz_bound_u+nz_bound_d), STAT=err)

        if(err .ne. 0)then
            write(*,*) 'Allocate memories fail, please check'
            stop
        endif

        !Initializations
        !*'Zeros' the buffers*
        u1 = 0.0
        u2 = 0.0
        u2_snapshot = 0.0
        record = 0.0
        record_acc = 0.0

        u1_1_x = 0.0
        u1_2_x = 0.0
        u2_1_x = 0.0
        u2_2_x = 0.0
        u2_tmp_1_x = 0.0
        u2_tmp_2_x = 0.0
        u3_1_x = 0.0
        u3_2_x = 0.0

        u1_1_z = 0.0
        u1_2_z = 0.0
        u2_1_z = 0.0
        u2_2_z = 0.0
        u2_tmp_1_z = 0.0
        u2_tmp_2_z = 0.0
        u3_1_z = 0.0
        u3_2_z = 0.0

        coe_2nd_10 = 0.0
        coe_2nd_8 = 0.0
        coe_2nd_6 = 0.0
        coe_2nd_4 = 0.0
        coe_2nd_2 = 0.0

        coe_1st = 0.0

        currshot_vz = 0.0

		top = 0.0
		bot = 0.0
		lef = 0.0
		rig = 0.0

		u3 = 0.0
		u4 = 0.0

        !Obtain the coefficients for explicit FD extrapolation
        call coefficient_2nd(order_2nd, coe_2nd_10)
        call coefficient_2nd(8,coe_2nd_8)
        call coefficient_2nd(6,coe_2nd_6)
        call coefficient_2nd(4,coe_2nd_4)
        call coefficient_2nd(2,coe_2nd_2)

        call coefficient_1st(order_1st,coe_1st)

        !Get currshot velocity
        call get_currshot_parameters(vz, currshot_vz, nx_v, nz_v,        &
                                     currshot_range, currshot_range_all, &
                                     currshot_xmin, currshot_xmax,       &
                                     nz, nx_bound_l, nx_bound_r,         &
                                     nz_bound_u, nz_bound_d, nsx, nsz0,  &
                                     currshot_nsx, currshot_nsz,         &
                                     order_2nd                           &
                                    )

        !Test
        if(myid==0)then
            write(*,*) 'currshot_range, currshot_range_all, currshot_nsx, nz, nsz0'
            write(*,*)  currshot_range, currshot_range_all, currshot_nsx, nz, nsz0
        endif

!		decay=nint((order_2nd*dz/currshot_vz(1,1))/dt)+nwt/2
		decay = nint(nwt / 2.0)
		print*, 'decay = ', decay

        !do it=1,nt+decay
        do it = 1,nt
            if(modulo(it, 2) == 1)then

			    call add_source(currshot_vz, u2, currshot_nsx,    &
                                currshot_nsz, currshot_range_all, &
                                nz,	f0, it, dt, order_2nd         &
                               )

                call extrapolation_one_step(currshot_vz, currshot_nsx, &
                                            nsz0, nrz0,currshot_range, &
                                            nz_v, currshot_range_all,  &
                                            nz, dx, dz, nt, dt, f0,    &
                                            nx_bound_l, nx_bound_r,    &
                                            nz_bound_u, nz_bound_d,    &
                                            order_2nd, order_1st,      &
                                            u1, u2,                    &
				    						coe_2nd_10, coe_2nd_8,     &
                                            coe_2nd_6, coe_2nd_4,      &
                                            coe_2nd_2, coe_1st,        &
                                            u1_1_x, u1_2_x,            &
                                            u2_1_x, u2_2_x,            &
                                            u2_tmp_1_x, u2_tmp_2_x,    &
                                            u3_1_x, u3_2_x,            &
                                            u1_1_z, u1_2_z,            &
                                            u2_1_z, u2_2_z,            &
                                            u2_tmp_1_z, u2_tmp_2_z,    &
                                            u3_1_z, u3_2_z             &
                                           )

                !iit=it-decay
                iit=it

			    if(iit >= 1)then
				    do ix = 1, currshot_range
				        top(ix, iit) = u1(nx_bound_l+ix, nz_bound_u+1)
					    bot(ix, iit) = u1(nx_bound_l+ix, nz_bound_u+nz_v)
				    enddo
				    do iz = 1, nz_v
				        lef(iz, iit) = u1(nx_bound_l+1, nrz0+nz_bound_u+iz)
					    rig(iz, iit) = u1(nx_bound_l+currshot_range, nrz0+nz_bound_u+iz)
				    enddo

                    !地表接收
                    record(iit, 1:currshot_range) = &
                        u1(nx_bound_l+1:currshot_range+nx_bound_l, nrz0+nz_bound_u)

				    call get_acc_record(u1, record_acc, order_1st, coe_1st,   &
					    				currshot_range, currshot_range_all,   &
                                        nz_v, nz,                             &
							    		nx_bound_l,nz_bound_u,nrz0,nt,iit,dz, &
                                        order_2nd                             &
                                       )

                endif

            else

			    call add_source(currshot_vz, u1, currshot_nsx,    &
                                currshot_nsz, currshot_range_all, &
                                nz,	f0, it, dt, order_2nd         &
                               )

                call extrapolation_one_step(currshot_vz, currshot_nsx,   &
                                             nsz0, nrz0, currshot_range, &
                                             nz_v, currshot_range_all,   &
                                             nz, dx, dz, nt, dt, f0,     &
                                             nx_bound_l, nx_bound_r,     &
                                             nz_bound_u, nz_bound_d,     &
                                             order_2nd, order_1st,       &
                                             u2, u1,                     &
	    									 coe_2nd_10, coe_2nd_8,      &
                                             coe_2nd_6, coe_2nd_4,       &
                                             coe_2nd_2, coe_1st,         &
                                             u1_2_x, u1_1_x,             &
                                             u2_2_x, u2_1_x,             &
                                             u2_tmp_2_x, u2_tmp_1_x,     &
                                             u3_2_x, u3_1_x,             &
                                             u1_2_z, u1_1_z,             &
                                             u2_2_z, u2_1_z,             &
                                             u2_tmp_2_z, u2_tmp_1_z,     &
                                             u3_2_z, u3_1_z              &
                                            )

 			    !iit=it-decay
                iit=it

			    if(iit >= 1)then
				    do ix=1, currshot_range
				        !top(ix,iit)=u1(nx_bound_l+ix,nrz0+nz_bound_u+1)
				        top(ix, iit) = u2(nx_bound_l+ix, nz_bound_u+1)
					    bot(ix, iit) = u2(nx_bound_l+ix, nz_bound_u+nz_v)
				    enddo
				    do iz=1, nz_v
				        lef(iz, iit) = u2(nx_bound_l+1, nrz0+nz_bound_u+iz)
					    rig(iz, iit) = u2(nx_bound_l+currshot_range, nrz0+nz_bound_u+iz)
				    enddo

				    record(iit,1:currshot_range) = &
                        u2(nx_bound_l+1:currshot_range+nx_bound_l, nrz0+nz_bound_u)

				    call get_acc_record(u2, record_acc, order_1st, coe_1st, &
					    			    currshot_range, currshot_range_all, &
                                        nz_v, nz,                           &
							    		nx_bound_l, nz_bound_u, nrz0, nt,   &
                                        iit, dz, order_2nd                  &
                                       )
			    endif

            endif

 		    if(myid == 0)then

          	    if(modulo(it, 1) == 0) then

                    write(*,*) 'shot is', trim(currshot_name), '  myid=', myid, 'nt=', nt, 'it=', it

                    write(currt, '(I6)') it
				    write(currtsnap, *) trim(adjustl(snap_fn1)), trim(adjustl(currt)), '.dat'

				    open(unit=18, file=currtsnap, form='unformatted', access='direct',&
				         status='replace',recl=nz_v)

                    !如果是中间放炮,两边接收的情况
                    if(abs(offset_min/dx) >= nsx) then

                        do i = 1, nx_v
                            do j = 1, nz_v
                                u2_snapshot(i, j) = u2(i+(abs(int(offset_min/dx))-nsx)+nx_bound_l, j+nz_bound_u)
                            enddo
                            write(18,rec=i) u2_snapshot(i, 1:nz_v)
				        enddo

                    endif

                    close(unit=18)

                endif

 		    endif

	    enddo


!********************************************************************************

        write(*,*) 'shot  ', trim(adjustl(currshot_name)), &
                   '  extrapolation finished,and now is writing disk'

        call write_currshot_disk(record,shot_fn1, record_acc, shot_fn3,    &
								 currshot_name, currshot_num,              &
                                 nsx, nsz0, currshot_range, currshot_xmin, &
                                 currshot_xmax, nt, dx, dz, dt             &
                                )

        write(*,*) 'shot  ', trim(adjustl(currshot_name)), '  is done'

        deallocate(u1, STAT=err)
        deallocate(u2, STAT=err)
        deallocate(u2_snapshot, STAT=err)
        deallocate(coe_2nd_10, STAT=err)
        deallocate(coe_2nd_8, STAT=err)
        deallocate(coe_2nd_6, STAT=err)
        deallocate(coe_2nd_4, STAT=err)
        deallocate(coe_2nd_2, STAT=err)
        deallocate(coe_1st, STAT=err)
        deallocate(record, STAT=err)
        deallocate(record_acc, STAT=err)
        deallocate(u1_1_x, STAT=err)
        deallocate(u1_2_x, STAT=err)
        deallocate(u2_1_x, STAT=err)
        deallocate(u2_2_x, STAT=err)
        deallocate(u2_tmp_1_x, STAT=err)
        deallocate(u2_tmp_2_x, STAT=err)
        deallocate(u3_1_x, STAT=err)
        deallocate(u3_2_x, STAT=err)
        deallocate(u1_1_z, STAT=err)
        deallocate(u1_2_z, STAT=err)
        deallocate(u2_1_z, STAT=err)
        deallocate(u2_2_z, STAT=err)
        deallocate(u2_tmp_1_z, STAT=err)
        deallocate(u2_tmp_2_z, STAT=err)
        deallocate(u3_1_z, STAT=err)
        deallocate(u3_2_z, STAT=err)
        deallocate(currshot_vz, STAT=err)

        deallocate(u3, STAT=err)
        deallocate(u4, STAT=err)
        deallocate(top, STAT=err)
        deallocate(bot, STAT=err)
        deallocate(lef, STAT=err)
        deallocate(rig, STAT=err)

        if(err .ne. 0)then
            write(*,*) 'Deallocate memories fail, please check'
            stop
        endif

        return

    end subroutine single_shot_modeling
