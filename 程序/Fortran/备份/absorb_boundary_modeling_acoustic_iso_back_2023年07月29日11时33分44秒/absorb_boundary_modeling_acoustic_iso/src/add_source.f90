	subroutine add_source(vz, u1, currshot_nsx, currshot_nsz, nx, nz, &
						  f0, it, dt)

        use constant
        implicit none

        !Dummy variables
        real::u1(-4:nx+5, -4:nz+5)
        real::vz(-4:nx+5, -4:nz+5)
        real::f0, dt
        integer::currshot_nsx, currshot_nsz, nx, nz, it

        !Local variables
        integer::i, j, k, hw, idx1, idx2, m, n, ierr
        integer,parameter::n1 = 20, n2 = 20
        real,parameter::alpha = 0.5
        real::wavelet, atten


        !hw=ceiling((n1+1)/2.0)
        !wavelet=exp(-(pi*f0*((it)*dt-1.0/f0))**2)*(-3.0+2.0*(pi*f0*((it)*dt-1.0/f0))**2)*2*f0*f0*pi*pi*((it)*dt-1.0/f0)
        wavelet = exp(-(pi*f0*(it*dt-1.0/f0))**2)*(1-2*(pi*f0*(it*dt-1.0/f0))**2)
        !wavelet=(-6.0*((pi*f0)**2)*(it*dt-1.0/f0)+4.0*((pi*f0)**4)*((it*dt-1.0/f0)**3))/(exp((pi*f0*(it*dt-1.0/f0))**2))
        !wavelet=sin(2*pi*f0*(it*dt-1.0/f0))*EXP(-((2*pi*f0/6)**2)*(it*dt-1.0/f0)**2)

    	!write(*,*)'currshotnsx=,currshotnsz=',currshot_nsx,currshot_nsz

    	!u1(currshot_nsx,currshot_nsz)=wavelet+u1(currshot_nsx,currshot_nsz)
        u1(currshot_nsx, currshot_nsz) = u1(currshot_nsx, currshot_nsz) + &
                                         wavelet
                                         !wavelet*dt**2*vz(currshot_nsx,currshot_nsz)**2


        !do m = currshot_nsz-hw, currshot_nsz+hw
            !do n = currshot_nsx-hw, currshot_nsx+hw
                !idx1  = m - currshot_nsz
                !idx2  = n - currshot_nsx
                !atten = exp(-1.0*alpha*(idx1**2+idx2**2))

                !if(m >= -4  .and.  m <= nz+5  .and.  n >= -4  .and  .n <= nx+5) then
                    !u1(n, m) = wavelet * atten + u1(n, m)
    			!endif

            !enddo
        !enddo


        return

	end subroutine add_source
