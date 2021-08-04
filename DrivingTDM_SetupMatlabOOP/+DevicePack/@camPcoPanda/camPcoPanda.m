classdef camPcoPanda  < handle
    %CAMPCOPANDA Summary of this class goes here
    %   Detailed explanation goes here
    
     properties (Access = private)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% ROI parameters (see the description of ROI in the SKD of PCO camera)
        
        sensorWidthMax  = 2048;
        sensorHeightMax = 2048;  
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% These four values are initialized with default value
         wRoiX0 = 1;       %% x position of top letf corner of the sensor
         wRoiY0 = 1;       %% y position of top letf corner of the sensor
         wRoiX1 = 2048;       %% x position of bottom right corner of the sensor 
         wRoiY1 = 2048;      %% y position of bottom right corner of the sensor
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        %%%%%% These two parameters define the actual size of the acquired
        %%%%%% image
        sensorWidthActive       %% sensor width
        sensorHeightActive      %% sensor height 
      
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
        exposure_time = 10;  %% exposure time (default value 10ms)
        triggermode = 0;     %% default value
        
        
     end
     
     
     
     properties (Access = public)
        % %% %    glvar :structure to hold status infos of the camera
        %glvar.do_libunload: 1 unload lib at end
        %glvar.do_close:     1 close camera SDK at end
        %glvar.camera_open:  open status of camera SDK
        %glvar.out_ptr:      libpointer to camera SDK handle
        
        glvar=struct('do_libunload',0,'do_close',0,'camera_open',0,'out_ptr',[]); 
        out_ptr   %% the camera handle 
     end
     
     
     
     methods
        function obj = camPcoPanda()
            %CAMPCOPANDA Construct an instance of this class
            %   Detailed explanation goes here
            % % % When a object is instantiated by calling camPcoPanda()
            %%%% All the necessary dll files and matlab script will be
            %%%% loaded and a camera variable will be created that is
            %%%% associated with the pco.panda camera.
            %%%% Once the camra variable is created then all the methods 
            %%%% associated with this camera object will be activated
            %%%% 
            %%%% Example code:
            %%%% camPanda = camPcoPanda; %% Instantiate a camera object
            %%%% camPanda.setROI(1024, 1024); %% set the ROI
            
            %%%% img = camPanda.getImageFrame();  %% will grab a single
            %%%%  image
            
            %%%% camPanda.closeDevices(); %% device will be closed 
            
            
            
            
            
            
            % % load all the necessary header, dll and functions
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/bin64/'));   
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/include/'));
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/lib64/'));  

            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/scripts/'));  %% useful to use predefined functions
                                                                             
            
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/scripts/ver_8/')); 
            
            pco_camera_create_deffile();   %% run only onece 
            
            
            
            %%%%%%%%%%%%
            %%%% Initialize the camera
            
            
            pco_camera_load_defines();
            subfunc=pco_camera_subfunction();
            subfunc.fh_lasterr(0);

            [errorCode, obj.glvar]=pco_camera_open_close(obj.glvar);
            pco_errdisp('pco_camera_setup',errorCode); 
            disp(['camera_open should be 1 is ',int2str(obj.glvar.camera_open)]);
            if(errorCode~=PCO_NOERROR)
            commandwindow;
            return;
            end 

            obj.out_ptr=obj.glvar.out_ptr;

       
% %         try
        subfunc.fh_stop_camera(obj.out_ptr);

        cam_desc=libstruct('PCO_Description');
        set(cam_desc,'wSize',cam_desc.structsize);
        [errorCode,~,cam_desc] = calllib('PCO_CAM_SDK', 'PCO_GetCameraDescription', obj.out_ptr,cam_desc);
        pco_errdisp('PCO_GetCameraDescription',errorCode);   

        if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_NO_TIMESTAMP)==0)
         subfunc.fh_enable_timestamp(obj.out_ptr,TIMESTAMP_MODE_BINARYANDASCII);
        end 

        %enable MetaData if available
        if(bitand(cam_desc.dwGeneralCapsDESC1,GENERALCAPS1_METADATA))
         subfunc.fh_set_metadata_mode(obj.out_ptr,1);
        end

        subfunc.fh_set_exposure_times(obj.out_ptr,obj.exposure_time,2,0,2)  %% function to set exposure time
        subfunc.fh_set_triggermode(obj.out_ptr,obj.triggermode);   %% function to set trigger mode

        %if PCO_ArmCamera does fail no images can be grabbed

        errorCode = calllib('PCO_CAM_SDK', 'PCO_ArmCamera', obj.out_ptr);
        if(errorCode~=PCO_NOERROR)
         pco_errdisp('PCO_ArmCamera',errorCode);   
         ME = MException('PCO_ERROR:ArmCamera','Cannot continue script with not armed camera');
         subfunc.fh_lasterr(errorCode);
         throw(ME);   
        end 

        %adjust transfer parameter if necessary
        subfunc.fh_set_transferparameter(obj.out_ptr);
        subfunc.fh_get_triggermode(obj.out_ptr);
        subfunc.fh_show_frametime(obj.out_ptr);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        
        
       
        
         %%% Setting the exposure time of the camera
         obj = setExposureTime(obj, ExpoTime); %% Function prototype to set the exposure time
         
 
         %%% Getting the exposure time
         obj = getExposureTime(obj);
        
        
        
        %%% This function will return the image frame 
        
         obj = getImageFrame(obj);  %% function prototype for image capture
        
        
         
         %%% Getting Region of interest (ROI)
         obj = getROI(obj)
         
         %%% Setting the Region of interest (ROI)
         obj = setROI(obj, width, height);   %% Function prototype for setting the ROI
         
         %%% Get the triggermode
         obj = getTrigerMode(obj)
         
         %%% Function prototype for closing the devices
         closeDevices(obj);
        
        
        

     end
     
end


