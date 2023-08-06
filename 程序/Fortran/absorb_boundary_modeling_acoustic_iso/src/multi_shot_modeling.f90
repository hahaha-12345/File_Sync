    subroutine multi_shot_modeling(par_fn)

        use mpi
        use module_constant
        implicit none

        !Dummy variables
        !*Parameter_card_name*
        character(len=256)::par_fn
        !*Read from parameter_card*
        character(len=256)::vz_fn
        character(len=256)::shot_fn1
        character(len=256)::shot_fn2
        character(len=256)::shot_fn3
        character(len=256)::shot_fn4
        integer::nx_v,nz_v
        integer::nt
        integer::order_1st
        integer::order_2nd
        integer::nshot
        real::offset_min, offset_max
        real::dx_v,dz_v
        real::x_bound_l, x_bound_r
        real::z_bound_u, z_bound_d
        real::sx0, sz0, rz0 ! 单位: m
        real::dsx           ! 单位: m
        real::f0            ! 单位: Hz
        real::dt            ! 单位: s

        !*Dummy variables (other)*
        integer::nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d
        integer::nsx0, nsz0, nrz0
        integer::currshot_xmin, currshot_xmax
        integer::ndsx, nsx
        integer::currshot_num
        character(len=256)::currshot_name
        real,allocatable::vz(:,:)

        !Local variables
        !*Variables for MPI interface*
        integer::myid,nproc,ierr
        integer::status(MPI_STATUS_SIZE)
        !*Other local variables*
        integer::ishot, j, k, err

        !Initialization of MPI interface
        call MPI_init(ierr)
        call MPI_comm_rank(MPI_COMM_WORLD, myid, ierr)
        call MPI_comm_size(MPI_COMM_WORLD, nproc, ierr)
        call MPI_barrier(MPI_COMM_WORLD, ierr)

        !Read parameter_card
        call read_par(par_fn, vz_fn, shot_fn1, shot_fn2, shot_fn3, shot_fn4, &
                      nshot, offset_min, offset_max, sx0, sz0, rz0, dsx,     &
                      nx_v, nz_v, dx_v, dz_v, nt, dt, f0, x_bound_l,         &
                      x_bound_r, z_bound_u, z_bound_d, order_2nd, order_1st  &
                     )


        allocate(vz(nx_v, nz_v),STAT=err)

        !Initialization
        vz=0.0

        !*Transfrom coordinates to grid_number for the conveniency of computation*!
        nx_bound_l = nint(x_bound_l / dx_v)
        nx_bound_r = nint(x_bound_r / dx_v)
        nz_bound_u = nint(z_bound_u / dz_v)
        nz_bound_d = nint(z_bound_d / dz_v)

        write(*,*) 'nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d'
        write(*,*)  nx_bound_l, nx_bound_r, nz_bound_u, nz_bound_d

        nsx0 = nint(sx0 / dx_v) + 1
        nsz0 = nint(sz0 / dz_v) + 1

        nrz0 = nint(rz0 / dz_v) + 1

        !*Read parameters from files*!
        call read_data(vz_fn, vz, nx_v, nz_v, myid)


        !Multishot modeling
        if(myid == 0) then
            write(*,*) '========== 2D Iso acoustic modeling begin =========='
        endif

        do ishot = 1+myid, nshot, nproc

            nsx = nsx0 + nint((ishot-1)*dsx/dx_v)
            currshot_xmin = nsx + nint(offset_min/dx_v)
            currshot_xmax = nsx + nint(offset_max/dx_v)
            currshot_num = ishot

            write(currshot_name, '(I4)') ishot

            call single_shot_modeling(vz, currshot_xmin, currshot_xmax,   &
                                      nsx, nsz0, nrz0, nx_v, nz_v,        &
                                      dx_v, dz_v, nt, dt, f0,nx_bound_l,  &
                                      nx_bound_r, nz_bound_u, nz_bound_d, &
                                      order_2nd, order_1st, shot_fn1,     &
                                      shot_fn2, shot_fn3, shot_fn4,       &
                                      currshot_name, currshot_num,        &
                                      offset_min, offset_max,             &
                                      myid   &
                                     )

        enddo

        call MPI_barrier(MPI_COMM_WORLD,ierr)

        if(myid==0)then
            write(*,*) 'Now merging shot_record files begin'
            call merge_shot_files(nshot, shot_fn1, shot_fn2,    &
                                  shot_fn3, shot_fn4,           &
                                  currshot_xmin, currshot_xmax, &
                                  nt, nz_v                      &
                                 )
            write(*,*) '========== 2D Iso acoustic modeling end =========='
        endif

        call MPI_finalize(ierr)

        deallocate(vz,STAT=err)

        return

    end subroutine multi_shot_modeling
