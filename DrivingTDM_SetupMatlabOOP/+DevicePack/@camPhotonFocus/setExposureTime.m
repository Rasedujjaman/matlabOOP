%%%% This function will set the exposure time of the camera
%%%% for photon focus camera the allowed range of exposure time 
%%%% (1 to 350 ms)

    function obj = setExposureTime(obj, ExpoTime)
            
           
            if(ExpoTime >=1 && ExpoTime <= 350)
            
                obj.vid.ExposureTimeAbs = ExpoTime; %% vid is the camera handle variable

                obj.exposuretime = ExpoTime;  %% update the new exposure time to the class property 'exposuretime'
                disp('Exposure time is set properly');
            else
                disp('Exposure time should be 1 to 350');
            end
        end