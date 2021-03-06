    

%Set ROI
% This function will always chose the central part of the sensor
function setROI(obj,Width,Height)
    
     %%%%% Check the argument of the function setROI
         
    if nargin == 2
        Height = Width;
    end
    if nargin == 1
        disp('Chose a new ROI');
        return;  %% function setROI will be stopped
    end

    %%% Check if the given ROI value is permitted by the camera
    if(mod(Width, 32) == 0 && Width <= obj.SensorWidth &&...
       mod(Height, 32) == 0 && Height <= obj.SensorHeight)
        
    

        %%% Check if the camera is in capture mode
        %%% When the camera is in capture, ROI can not be set
        if(obj.IsCaptureON == 1)
            stopCapture(obj);  %% Stop the capture mode of the camera
        end

        deltaX = floor(obj.SensorWidth - Width)/2;
        deltaY = floor(obj.SensorHeight - Height)/2;
        obj.vid.ROIPosition = [deltaX deltaY Width Height];
        obj.ROIWidth = Width;
        obj.ROIHeight = Height;

        disp('ROI is set properly');
    else
        disp('Check correct ROI value');
    end
    
end