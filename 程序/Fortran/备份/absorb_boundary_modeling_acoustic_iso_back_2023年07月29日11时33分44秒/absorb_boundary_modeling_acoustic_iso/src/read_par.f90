    subroutine read_par(par_fn, vz_fn, shot_fn1, shot_fn2, shot_fn3, shot_fn4, nshot, &
                        offset_min, offset_max, sx0, sz0, rz0, dsx, nx_v, nz_v, dx_v, &
                        dz_v, nt, dt, f0, bound_x_l, bound_x_r, bound_z_u, bound_z_d, &
                        order_2nd, order_1st                                          &
                       )

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
        integer::nx_v, nz_v
        integer::nt
        integer::order_2nd
        integer::order_1st
        integer::nshot
        real::offset_min, offset_max
        real::dx_v, dz_v
!        real::pml_thick ! 单位: m
        real::bound_x_l, bound_x_r, &
              bound_z_u, bound_z_d !单位: m
        real::sx0, sz0, rz0 !单位: m
        real::dsx !单位: m
        real::f0 !单位: Hz
        real::dt !单位: s

        !*Variables of MPI interface*
        integer::myid

        !Local variables
        integer::i, j, ierr
        character(len=256)::par_jumpper


        open(10, file=par_fn, action='read', status='old', form='formatted', &
             access='sequential')

        read(10, '(A)') par_jumpper
        read(10, '(A)') vz_fn

        read(10, '(A)') par_jumpper
        read(10, '(A)') shot_fn1

        read(10, '(A)') par_jumpper
        read(10, '(A)') shot_fn2

        read(10, '(A)') par_jumpper
        read(10, '(A)') shot_fn3

        read(10, '(A)') par_jumpper
        read(10, '(A)') shot_fn4

        read(10, '(A)') par_jumpper
        read(10, *)     nshot

        read(10, '(A)') par_jumpper
        read(10, *)     offset_min, offset_max

        read(10, '(A)') par_jumpper
        read(10, *)     sx0, sz0, rz0

        read(10, '(A)') par_jumpper
        read(10, '(F)') dsx

        read(10, '(A)') par_jumpper
        read(10, *)     nx_v, nz_v

        read(10, '(A)') par_jumpper
        read(10, *)     dx_v, dz_v

        read(10, '(A)') par_jumpper
        read(10, '(I)') nt

        read(10, '(A)') par_jumpper
        read(10, '(F)') dt

        read(10, '(A)') par_jumpper
        read(10, '(F)') f0

        read(10, '(A)') par_jumpper
        read(10, *)     bound_x_l, bound_x_r

        read(10, '(A)') par_jumpper
        read(10, *)     bound_z_u, bound_z_d

        read(10, '(A)') par_jumpper
        read(10, '(I)') order_2nd

        read(10, '(A)') par_jumpper
        read(10, '(I)') order_1st

        close(10)

		return

    end subroutine read_par
