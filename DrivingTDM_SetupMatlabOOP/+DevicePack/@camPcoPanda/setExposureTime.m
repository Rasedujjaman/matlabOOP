

function obj = setExposureTime(obj, expoTime)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here


                subfunc=pco_camera_subfunction();
                err = subfunc.fh_set_exposure_times(obj.out_ptr,expoTime,2,0,2);  %% function to set exposure time
                if(err == 0)
                     disp('Exposure time is set properly');
                end
                
end
            