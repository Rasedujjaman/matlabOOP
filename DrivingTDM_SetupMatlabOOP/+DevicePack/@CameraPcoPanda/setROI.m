    

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


    %%% Check if the camera is in capture mode
    %%% When the camera is in capture, ROI can not be set
    if(obj.IsCaptureON == 1)
        StopCapture(obj);  %% Stop the capture mode of the camera
    end
    
    deltaX = floor(obj.SensorWidth - Width)/2;
    deltaY = floor(obj.SensorHeight - Height)/2;
    obj.vid.ROIPosition = [deltaX deltaY Width Height];
    obj.ROIWidth = Width;
    obj.ROIHeight = Height;
    
    disp('ROI is set properly');
end