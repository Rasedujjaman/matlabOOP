

classdef CameraPcoPanda < handle
   
    % CAMERAPCOPANDA is a class used to control the "sCMOS pco.panda 4.2" camera from PCO
    % Before using this class, make sure you downloaded the 'pcocameraadaptor_r2019a' adaptor and
    % registered it as a third party adaptor into the Matlab Image
    % Acquitsition Toolbox and finally tested the camera by Image
    % acquistion toolbox
    
    
    
    
      properties (Constant = true)
        CameraName = 'pco.panda 4.2';
        CameraModel = 'M-USB-BLU-P';
        CameraSerial = '14401698';
        AdaptorVersion = 'pcocameraadaptor_r2019a'; % Do not change, required to identify the camera
        CameraType   = 'USB 3.1 Gen 1'; % Do not change, required to identify the camera
        SensorWidth  = 2048; % Sensor size (maximum number of active pixel along the width)
        SensorHeight = 2048; % Sensor size (maximum number of active pixel along the height)
        PixelSize = 6.5;     % Square pixel of 6.5um x 6.5um 
        
        ExpoTimeMax = 5000;  % Maximum permissible exposure time in (ms)
        Authorized_Trigger = {'immediate','manual', 'hardware'};
            % 'immediate' : software controlled
            % 'hardware' : TLL on the TRIG IN input
    
      end
    
      
      properties (GetAccess = public, SetAccess = public)
        vid; % Created when connecting the camera
        src; % Created when connecting the camera
        ROIWidth =  2048; % ROI Size
        ROIHeight = 2048;
        ExposureTime_unit = 'ms';  %% mili second 
                                %%% other possible unit ('ns', 'um');
        ExposureTime = 10;  % Exposure Time
        Movie;              % Reserved property
        Image;              % Store the image captured
        IsLiveON = 0;       % IsLiveON: 1 (Camera Live)
        IsCaptureON = 0;
      end
      
     
      
      
	methods
         %Construct and initialise the camera
        function obj = CameraPcoPanda() %Constructor
            obj.vid = videoinput(obj.AdaptorVersion, 0, obj.CameraType);
            obj.src = getselectedsource(obj.vid);
            obj.vid.FramesPerTrigger = 1;
            obj.vid.TriggerRepeat = 1;
            
            obj.src.E1ExposureTime_unit = 'ms';
            triggerconfig(obj.vid, 'manual');
            % Save video onto RAM, unless asked to write on the disk
            obj.vid.LoggingMode = 'memory';
            obj.setExposureTime(obj.ExposureTime);
        end
        
        
        %%% Function prototype to set the exposure time
        obj = setExposureTime(obj, ExpoTime);


        %%% Function prototype to make the camera ready for image capture
        obj = startCapture(obj)

        %%% Function prototype to stop the Camera from image capture
        obj = stopCapture(obj)


        %%% Setting the Region of interest (ROI)
        obj = setROI(obj, width, height);   %% Function prototype for setting the ROI


        %%% Setting the default parameters 
        obj = setDefaultParameters(obj);  %% Will be implemented later 

        %%% Getting Region of interest (ROI)
        obj = getROI(obj)


        %%% getting the image Frame width
        obj = getImageWidth(obj);



        %%% getting the image Frame height
        obj = getImageHeight(obj);    


        %%% This function will return the Captured image frame

        obj = getImageFrame(obj);  %% function prototype for image capture


        %%% Show preview
        obj = showPreview(obj);
        %%% Stop preview
        obj = stopPreview(obj);


        %%% Get the height of the camera sensor
        obj = getSensorHeightMax(obj);

        %%% Get the width of the camera sensor
        obj = getSensorWidthMax(obj);

        %%% Get the divice informations
        obj = getDeviceInfos(obj);  %% will be implemented later

        %%% Close the device 
        closeDevices(obj);

    end
end

