classdef CameraPcoPanda < handle
   
    % CAMPCOPANDA is a class used to control the sCMOS pco.panda camera
    % from PCO
    % Before use, make sure you downloaded the 'pcocameraadaptor_r2019a' adaptor and
    % registered it as a third party adaptor into the Matlab Image Acquitsition Toolbox
    
    
    
    
      properties (Constant = true)
        AdaptorVersion = 'pcocameraadaptor_r2019a'; % Do not change, required to identify the camera
        CameraType   = 'USB 3.1 Gen 1'; % Do not change, required to identify the camera
        SensorWidth  = 2048; % Sensor size
        SensorHeight = 2048;
        
        
        ExpoTimeMax = 5000;   %% Maximum permissible exposure time in (ms)
        Authorized_Trigger = {'immediate','manual', 'hardware'};
            % 'immediate' : software controlled
            % 'hardware' : TLL on the TRIG IN input
    
      end
    
      
      properties (GetAccess = public, SetAccess = public)
        vid; % Created when connecting the camera
        src; % Created when connecting the camera
        SavePath; % Folder with date of the day ("root")
        SaveFolder; % Folder of the acquisition
        SaveName; % Name of the image
        ImageNumber = 0; % Image Number for snapshots
        ImageNumberMany = 0; % Image Number for sequence acquisition
        AcqNumber = 0; % Acquisition Number
        ROIWidth =  2048; % ROI Size
        ROIHeight = 2048;
        ExposureTime_unit = 'ms';  %% mili second 
                                %%% other possible unit ('ns', 'um');
        ExposureTime = 10; %Exposure Time
        Movie;
        Image;    %%% Store the image captured
        IsLiveON = 0;
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

            %Set default settings
% %             obj.SetDefaultParameters()
% %             obj.SetDatePath()
        end
        
        
    %% Function prototype to set the exposure time
    obj = setExposureTime(obj, ExpoTime);
        
        
	%% Function prototype to make the camera ready for image capture
	obj = StartCapture(obj)
    
    %% Function prototype to stop the Camera from image capture
	obj = StopCapture(obj)
        
    %%
    %%% Setting the Region of interest (ROI)
	obj = setROI(obj, width, height);   %% Function prototype for setting the ROI

     %%
    %%% Getting Region of interest (ROI)
	obj = getROI(obj)

      
    %%% getting the image Frame width
	obj = getImageWidth(obj);



    %%% getting the image Frame height
	obj = getImageHeight(obj);    

	%%
	%%% This function will return the Captured image frame

	obj = getImageFrame(obj);  %% function prototype for image capture
    
    
    %% Show preview
    obj = showPreview(obj);
    %% Stop preview
    obj = stopPreview(obj);
    
    %%
    %%% Get the height of the camera sensor
    obj = getSensorHeightMax(obj);

    %%% Get the width of the camera sensor
    obj = getSensorWidthMax(obj);
    
	%% Close the device 
	closeDevices(obj);

    end
end

