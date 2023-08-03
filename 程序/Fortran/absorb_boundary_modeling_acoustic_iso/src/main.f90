    !Modified to conduct Aperture_control during forward modeling
    !Modified to add su head to shot_gather
    !Modified to add acceleration signal
    !Modified to a new source implementation
    !Modified to a acoustic for multiple simlution
    !Correct the famous 'negative' to 'positive' mistake
    !    in pml positive direction of extrapolation
    !Add shear wave for better stablity

    program Iso_fd_qacoustic_modeling

        implicit none

        character(len=256)::par_fn = &
                  './par/iso_2d_modeling_Fujian_bridge_pier.par'

        call multi_shot_modeling(par_fn)

    end program Iso_fd_qacoustic_modeling
