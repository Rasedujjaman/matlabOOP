classdef camPhotonFocus < handle
    %camPhotonFocus Summary of this class goes here
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Before using this class Read this carefully
    %%% This class is for the camera with the following details
    %%% Camera manufacturer: Photonfocus AG
    %%% Camera Model: MV1-D1312-100-GB-12
    %%% SerialNumber: 022300009708
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% It is assumed that the matlab image aquisition toolbox is installed
    %%% and the adaptor, 'gige' is configured and registered properly. This
    %%% adaptor is a third pary software that establish connection between
    %%% the camera and the  image aquistion toolbox. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% How this class works? 
    %%% By this class, we instantiate an object which basically connect
    %%% through the image aquisition toolbox under the hood. i.e. We will not
    %%% see the image aquition toolbox. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
     properties (Constant = true)
        adaptorVersion = 'gige';       % Do not change, required to identify the camera
        cameraType = 'Photonfocus AG_MV1-D1312-100-GB-12'; 
        sensorWidthMax  = 1312;  % Width of the sensor
        sensorHeightMax = 1082; % Height of the sensor
        authorized_pixelFormat = {'Mono8',  'Mono10',  'Mono12'};
        authorized_Trigger = {'immediate','manual', 'hardware'}; %% Reserved (not used)
        ExpoTimeMax = 335;   %% Maximum permissible exposure time in (ms)
     
    end
    
    
    
    
    
    properties (Access = public)
        vid;   % Created when connecting the camera (camera handle variable)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ROI parameters
        sensorWidthActive = 1312       %% sensor width
        sensorHeightActive = 1082     %% sensor height 
       
        exposuretime = 10; % Exposure Time (the default value is 10ms)
        readoutTime = 14.59; % Readout Time (the default value is 14.59ms)
        
        IsLiveON = 1;
        pixelFormat = 'Mono8'; %% the default pixel format
        packetDelayTime   %% packet delay time
    
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% The constructor of the camPhotonFocus camera
        function obj = camPhotonFocus(pixel_format) 
            %camPhotonFocus Construct an instance of this class
            %   Detailed explanation goes here
         addpath(fullfile(pwd,'/headerAndFunctionsPhotonFocus/scripts/'));   
        
        %%%% Overloaded constructor
         if nargin == 1
             
             %%% Check if the given pixel_format is a valid one
             %Check if ReadoutMode is valid
            isValidString = strcmp(pixel_format, obj.authorized_pixelFormat);
            [~,idx] = find(isValidString == 1);
            if isempty(idx) %Invalid pixel format is given
                disp('Invalid pixel format')
                obj.vid = gigecam(1, 'PixelFormat', obj.pixelFormat);
                % Change the Packet Size (GevSCPSPacketSize) property
                % The value must not exceed the Jumbo Packet value (set to 9014)
                obj.vid.GevSCPSPacketSize  = 8000;

              
              obj.packetDelayTime = obj.getPacketDelay(25);
              % % % Set the Packet Delay (GevSCPD) property
              obj.vid.GevSCPD =  obj.packetDelayTime;
              

                
            else %Valid pixel format
                obj.pixelFormat = pixel_format;
                obj.vid = gigecam(1, 'PixelFormat', obj.pixelFormat);
                % Change the Packet Size (GevSCPSPacketSize) property
                % The value must not exceed the Jumbo Packet value (set to 9014)
                obj.vid.GevSCPSPacketSize  = 8000;

              
              
              obj.packetDelayTime = obj.getPacketDelay(25);
              % % % Set the Packet Delay (GevSCPD) property
              obj.vid.GevSCPD =  obj.packetDelayTime;
              
            end
            
    
        else	%% If no parameter is passed to the constructor
             
            obj.vid = gigecam(1, 'PixelFormat', obj.pixelFormat);
            % Change the Packet Size (GevSCPSPacketSize) property
            % The value must not exceed the Jumbo Packet value (set to 9014)
            obj.vid.GevSCPSPacketSize  = 8000;

              
              
            obj.packetDelayTime = obj.getPacketDelay(25);
            % % % Set the Packet Delay (GevSCPD) property
            obj.vid.GevSCPD =  obj.packetDelayTime;
        end
        end
             
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        obj = setDefaultParameters(obj);  %% This function will be reset the values of the camera to default
         
         
         
        obj = setPixelFormat(obj, pixel_format)  %% This function will set the pixel format of the sensor
        
        
       
        
        %%% Setting the exposure time of the camera
        obj = setExposureTime(obj, ExpoTime); %% Function prototype to set the exposure time
 
        %%% Setting the ROI of the camera
        obj = setROI(obj, width, height);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% All getter functions (methods)
         
        obj = getPacketDelay(obj, fps);
        %%%%%%%%%%%%%%%%%%%%% Display the informations about the devices
        getDevicesInfos(obj);
        
        
        %%% This function will return the image frame 
        
        obj = getImageFrame(obj);  %% function prototype for image capture
        
        %%%% This function will retun the current pixel format
        [pixel_format] = getPixelFormat(obj); %% This will return the pixel format of the camera sensor
        
         
        obj =  getDefaultParameters(obj);  %%% This will return the default parameter of the camera
         
         
        %%% getting the exposure time of the camera
        obj = getExposureTime(obj);
        
        %%% Get the readout time
        obj = getReadoutTime(obj);
        
        %%%%%%% Getting the Current ROI
        stringROI = getROI(obj);
        
          
        %%%%Get the image height
        obj = getImageHeight(obj);
          
        %%% Get the image width
        obj = getImageWidth(obj);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        obj = StopCapture(obj)
        
        %%% Get the height of the camera sensor
        obj = getSensorHeightMax(obj);
        
        %%% Get the width of the camera sensor
        obj = getSensorWidthMax(obj);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        %%% Close the camera
        % % % % % % Close the devices
        closeDevices(obj);   %% function signature to close the camera
      
        
        
    end
end

