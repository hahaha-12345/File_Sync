    subroutine read_data(vz_fn, vz, nx_v, nz_v, myid)

        use constant
        implicit none

        !Dummy variables
        character(len=256)::vz_fn
        real::vz(nx_v, nz_v)
        integer::nx_v, nz_v
        integer::myid

        !Local variables
        integer::i

        !Read data from files
        open(10, file=vz_fn, action='read', form='unformatted', &
             access='direct', status='old', recl=nz_v)
        do i=1, nx_v
          read(10,rec=i) vz(i, :)
        enddo
        close (10)

!        open(10,file='vz_test',action='write',&
!        form='unformatted',access='direct',status='replace',recl=nz_v)
!        do i=1,nx_v
!          write(10,rec=i)vz(i,:)
!        enddo
!        close (10)

        return

    end subroutine read_data
