    subroutine write_currshot_disk(record, shot_fn1, record_acc, shot_fn3,   &
                                   currshot_name, currshot_num,              &
                                   nsx, nsz0, currshot_range, currshot_xmin, &
                                   currshot_xmax, nt, dx_v, dz_v, dt         &
                                  )

        use header
        implicit none

        !Dummy variables
        integer::currshot_num, nsx, nsz0,       &
                 currshot_range, currshot_xmin, &
                 currshot_xmax, nt
        real::record(nt, currshot_range)
        real::record_acc(nt, currshot_range)
        character(len=256)::shot_fn1
        character(len=256)::shot_fn3
        character(len=256)::currshot_name
        real::dx_v, dz_v, dt

        !Local variables
        type(segy)::su_head
        real::offx_tmp, offy_tmp
        integer::i, j, k, irec

        !Initialization of the su_head
        su_head=segy(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    &
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0     &
                    )

        su_head%fldr  = currshot_num !shot_num
!        su_head%tracl = currshot_range !number of traces per shot in inline direction
        su_head%trid = 1 !data_type
        su_head%sx   = (nsx - 1) * dx_v
        su_head%ns   = nt
        su_head%dt   = dt*1.0E6 !use SEG standard
!        su_head%d1   = dx_v !self defined
!        su_head%f1   = 0.0
!        su_head%d2   = dz_v


		!Pressure
        open(unit=8, file=trim(adjustl(shot_fn1))//trim(adjustl(currshot_name))//'.su', &
             form='unformatted', access='direct', status='replace', recl=nt+60)


		!Acceleration
        open(unit=9, file=trim(adjustl(shot_fn3))//trim(adjustl(currshot_name))//'.su', &
             form='unformatted', access='direct', status='replace', recl=nt+60)


        do i = 1, currshot_range

            su_head%gx     = (currshot_xmin-1+i-1)*dx_v
            su_head%offset = su_head%gx-su_head%sx

            write(8,rec=i) su_head, (record(k,i),k=1,nt)
            write(9,rec=i) su_head, (record_acc(k,i),k=1,nt)

        enddo

        close(unit=8)
        close(unit=9)


        return

    end subroutine write_currshot_disk
