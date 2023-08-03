    subroutine merge_shot_files(nshot, shot_fn1, shotall_fn1, shot_fn2,       &
                                shotall_fn2, currshot_xmin, currshot_xmax, nt &
                               )

        implicit none

        !Dummy variables
        character(len=256)::shot_fn1, shotall_fn1, shot_fn2, shotall_fn2
        integer::nshot, currshot_xmin, currshot_xmax, nt

        !Local variables
        real,allocatable::record(:, :)
        integer::currshot_ran_x, is, i, j, k, ierr
        character(len=256)::currshot_noc
        character(len=256)::currshot_name

        !Initialization
        currshot_ran_x = (currshot_xmax-currshot_xmin)+1
        allocate(record(nt+60, currshot_ran_x), STAT=ierr)
        record = 0.0

		!================merge No.1 shot files=====================
        open(11, file=trim(adjustl(shotall_fn1))//'.su', access='direct', form='unformatted', &
             action='write', status='replace', recl=currshot_ran_x*(nt+60))

        do is = 1, nshot
            record = 0.0
            write(currshot_noc, '(I4)') is
            !Need some test here
            write(currshot_name, *) trim(adjustl(shot_fn1))//trim(adjustl(currshot_noc))//'.su'
            write(*, *) trim(currshot_name), ' is bening merged'

            open(10, file=currshot_name, access='direct', form='unformatted', &
                 action='read', recl=currshot_ran_x*(nt+60))

            !Try to read in this way for better efficiency
            read(10, rec=1) ((record(k,i),k=1,nt+60),i=1,currshot_ran_x)
            close(10, status='delete')
!            close (10)

            write(11, rec=is) ((record(k,i),k=1,nt+60),i=1,currshot_ran_x)
        enddo

        close(11)

		!================merge No.2 shot files=====================

        open(11, file=trim(adjustl(shotall_fn2))//'.su', access='direct', form='unformatted', &
             action='write', status='replace', recl=currshot_ran_x*(nt+60))

        do is = 1, nshot
            record = 0.0
            write(currshot_noc, '(I4)') is
            !Need some test here
            write(currshot_name, *) trim(adjustl(shot_fn2))//trim(adjustl(currshot_noc))//'.su'
            write(*, *) trim(currshot_name), ' is bening merged'

            open(10, file=currshot_name, access='direct', form='unformatted', &
                 action='read', recl=currshot_ran_x*(nt+60))

            !Try to read in this way for better efficiency
            read(10, rec=1) ((record(k,i),k=1,nt+60),i=1,currshot_ran_x)
            close(10,status='delete')
!            close (10)

            write(11, rec=is) ((record(k,i),k=1,nt+60),i=1,currshot_ran_x)
        enddo

        close(11)

        deallocate(record, STAT=ierr)

        return

    end subroutine merge_shot_files
