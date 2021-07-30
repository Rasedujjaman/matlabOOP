    function obj = setExposureTime(obj, ExpoTime)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.exposuretime = ExpoTime;
            [rc] = AT_SetFloat(obj.hndl,'ExposureTime', ExpoTime);
            AT_CheckWarning(rc);
            disp('Exposure time is set properly');
        end