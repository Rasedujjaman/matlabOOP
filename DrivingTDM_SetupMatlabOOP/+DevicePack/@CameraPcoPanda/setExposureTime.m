


  % Set Exposure Time in ms
function setExposureTime(obj, ExpoTime)

    

    %% Check if the exposure time is in permissible range
    if(ExpoTime > obj.ExpoTimeMax)
        disp('Exposure time exceeds the Maximum limit');
        disp('Chose exposrue time less than 5000 ms');
    else
        if(obj.IsCaptureON == 1)
            StopCapture(obj);  %% Stop the capture mode of the camera
        end
        
        
        obj.src.E2ExposureTime = ExpoTime;
        obj.ExposureTime = ExpoTime;
        disp('Exposure time is set properly');
    end
end