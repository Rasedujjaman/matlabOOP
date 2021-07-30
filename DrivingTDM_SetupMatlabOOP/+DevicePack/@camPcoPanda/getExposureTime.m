

function ExpoTime = getExposureTime(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here

            del_time=uint32(0);
            exp_time=uint32(0);
            del_base=uint16(0);
            exp_base=uint16(0);
             
             
             [errorCode,~,del_time,obj.exposure_time,del_base,exp_base] = calllib('PCO_CAM_SDK', 'PCO_GetDelayExposureTime', obj.out_ptr,del_time,exp_time,del_base,exp_base);
              
             ExpoTime = obj.exposure_time;
             disp(ExpoTime);
             pco_errdisp('PCO_GetDelayExposureTime',errorCode);
            
end