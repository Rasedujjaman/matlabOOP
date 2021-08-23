    function obj = setExposureTime(obj, ExpoTime)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.exposuretime = ExpoTime/1000;
            [rc] = AT_SetFloat(obj.hndl,'ExposureTime', obj.exposuretime);
            AT_CheckWarning(rc);
            disp('Exposure time is set properly');
        end