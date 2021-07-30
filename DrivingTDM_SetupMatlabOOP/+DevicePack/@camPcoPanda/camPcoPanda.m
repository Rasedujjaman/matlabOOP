classdef camPcoPanda  < handle
    %CAMPCOPANDA Summary of this class goes here
    %   Detailed explanation goes here
    
     properties (Access = private)
        exposure_time = 10;  %% exposure time (default value 10ms)
        triggermode = 0;   %% default value
        reduce_display_size = 1;
     end
     
     
     
     properties (Access = public)
        glvar=struct('do_libunload',0,'do_close',0,'camera_open',0,'out_ptr',[]); 
        out_ptr   %% the camera handle 
     end
     
     
     
     methods
        function obj = camPcoPanda()
            %CAMPCOPANDA Construct an instance of this class
            %   Detailed explanation goes here
            
            % % load all the necessary header, dll and functions
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/bin64/'));   
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/include/'));
            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/runtime/lib64/'));  

            addpath(fullfile(pwd,'/headerAndFunctionsPcoPanda/scripts/'));  
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
        
        
        
         
         %%% Function prototype for closing the devices
         closeDevices(obj);
        
        
        

     end
     
end


