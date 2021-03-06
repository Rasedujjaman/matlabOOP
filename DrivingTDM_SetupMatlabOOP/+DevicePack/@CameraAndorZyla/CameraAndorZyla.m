

classdef CameraAndorZyla < handle
   
 % CameraAndorZyla class is intended for use with AndorZyla camera
   
    
    properties (Constant = true)
        CameraName   = 'Zyla';
        CameraModel  = 'DG-152V-C1E-FI';
        CameraSerial = 'VSC-00714';

        ExpoTimeMax  = 50;  %% Maximum permissible exposure time in (ms)


        SensorWidth  = 2560; % Sensor size (maximum number of active pixel along the width)
        SensorHeight = 2160; % Sensor size (maximum number of active pixel along the height)
        PixelSize = 6.5;     % Square pixel of 6.5um x 6.5um 
        
       
        Authorized_Trigger = {'Internal','Software', 'External'};
            % For more details see Andor SDK3 booklet
            % 'External' : TLL on the TRIG IN input
        
        
    end
    
    
    
    properties (Access = public)
        
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% ROI parameters
        width       %% sensor width
        height      %% sensor height 
        top         %% sensor top 
        left        %% sensor left
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
       
        stride          %% This value is used by the function AT_ConvertMono16ToMatrix
        exposuretime = 0.01;  %% exposure time of the camera (default is set to 10ms)
        ReadoutTime
        
        
        hndl    %% the camera handle 
        Image;  %% The captured image
        imageSize       %% image size in byte
        IsLiveON = 0; 
        
       
    end
    
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        methods
            
            %%% The constructor
        function obj = CameraAndorZyla()
            [rc] = AT_InitialiseLibrary();
            AT_CheckError(rc);
          
            [rc,obj.hndl] = AT_Open(0);
            AT_CheckError(rc);
            disp('Camera initialized');
            [rc] = AT_SetFloat(obj.hndl,'ExposureTime',0.01);
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(obj.hndl,'CycleMode','Continuous');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(obj.hndl,'TriggerMode','Software');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(obj.hndl,'SimplePreAmpGainControl','16-bit (low noise & high well capacity)');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(obj.hndl,'PixelEncoding','Mono16');
            AT_CheckWarning(rc);
            
            [rc,obj.imageSize] = AT_GetInt(obj.hndl,'ImageSizeBytes');
            AT_CheckWarning(rc);
            [rc,obj.height] = AT_GetInt(obj.hndl,'AOIHeight');
            AT_CheckWarning(rc);
            [rc,obj.width] = AT_GetInt(obj.hndl,'AOIWidth');
            AT_CheckWarning(rc);
            
            [rc,obj.top] = AT_GetInt(obj.hndl,'AOITop');
            AT_CheckWarning(rc);
            [rc,obj.left] = AT_GetInt(obj.hndl,'AOILeft');
            AT_CheckWarning(rc);
            
            [rc,obj.stride] = AT_GetInt(obj.hndl,'AOIStride'); 
            AT_CheckWarning(rc);
            
            disp('Starting acquisition...');
            [rc] = AT_Command(obj.hndl,'AcquisitionStart');
            AT_CheckWarning(rc);
            
            
        end
        
        %%% Setting the exposure time of the camera
        obj = setExposureTime(obj, ExpoTime); %% Function prototype to set the exposure time

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Set the ROI (region of interest) 
        %%% check the sdk guide for AndorZyla camera for the supported values of ROI

        obj = setROI(obj, width, height);   %% Function prototype for setting the ROI

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Get the ROI of the camera
        obj = getROI(obj);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %%% This function will return the image size
        obj = getImageSize(obj);


        %%% This function will return the image frame 

        obj = getImageFrame(obj);  %% function prototype for image capture


        %%% getting the exposure time of the camera
        obj = getExposureTime(obj);
        %%% getting the ReadoutTime of the camera
        obj = getReadoutTime(obj);

        %%% getting the image Frame width
        obj = getImageWidth(obj);



        %%% getting the image Frame height
        obj = getImageHeight(obj);

      
        %%% Set the default ROI of the camera
        obj = setROIdefault(obj); %%% Function prototype to set the default ROI of the camera
          
        
        %%% This is a dummy function 
        obj = stopCapture(obj)

        %%% Get the height of the camera sensor
        obj = getSensorHeightMax(obj);

        %%% Get the width of the camera sensor
        obj = getSensorWidthMax(obj); 

        
        %%% Get the divice informations
        obj = getDeviceInfos(obj);  %% will be implemented later
        
        %%% Close the camera
        closeDevices(obj);   %% function signature to close the camera
      

    end
end

