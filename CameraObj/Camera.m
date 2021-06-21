

classdef Camera < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% ROI parameters
        width       %% sensor width
        height      %% sensor height 
        top         %% sensor top 
        left      %% sensor left
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        imageSize       %% image size in byte
        stride          %% This value is used by the function AT_ConvertMono16ToMatrix
        exposuretime = 0.01;  %% exposure time of the camera (default is set to 10ms)
       
    end
    
    properties (Access = public)
    
     hndl   %% the camera handle 
    end
    
    methods
        function obj = Camera()
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
        function obj = setExposureTime(obj, ExpoTime)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.exposuretime = ExpoTime;
            [rc] = AT_SetFloat(obj.hndl,'ExposureTime', ExpoTime);
            AT_CheckWarning(rc);
            disp('Exposure time is set properly');
        end
        
        
        
            
      
        
        
        
        %%% Set the ROI (region of interest)
        
        function obj = setROI(obj, width, height)
                
            if(width == 2560 && height == 2160)
                obj.left = 1; 
                obj.top = 1;
            elseif(width == 1776 && height == 1760)
                obj.left = 409;
                obj.top = 201;
                obj.width = 1776;
                obj.height = 1760;
                
            elseif(width == 1392 && height == 1040)
                obj.left = 601;
                obj.top = 561;
                obj.width = 1392;
                obj.height = 1040;
                
            elseif(width == 528 && height == 512)
                obj.left = 1033;
                obj.top = 825;
                obj.width = 528;
                obj.height = 512;
           
            else
                disp('ROI not supported');
            
            end
            
            
            
            %%% Set the ROI
            
            [rc] = AT_SetInt(obj.hndl,'AOIWidth',width);
%             AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOILeft',obj.left);
%             AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOIHeight',height);
%             AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOITop',obj.top);
%             AT_CheckWarning(rc);
% %             [rc, obj.imagesize] = AT_GetInt(obj.hndl,'ImageSizeBytes'); 
             % % Eech time you set ROI, you must update the image size                                                           
                                                                                                                               
% %             AT_CheckWarning(rc);
            
            
            
        end

        %%% This function will return the image size
        function outPutImageSize = getImageSize(obj)
            [rc, outPutImageSize] = AT_GetInt(obj.hndl,'ImageSizeBytes');
             AT_CheckWarning(rc);
        end
        
        
        %%% This function will return the image frame 
        
        function outImageFrame = getImageFrame(obj)
% %             [rc,imagesize] = AT_GetInt(obj.hndl,'ImageSizeBytes');
% %             AT_CheckWarning(rc);
            [rc] = AT_QueueBuffer(obj.hndl, obj.imageSize);
            AT_CheckWarning(rc);
            [rc] = AT_Command(obj.hndl,'SoftwareTrigger');
            AT_CheckWarning(rc);
            
            [rc, buf] = AT_WaitBuffer(obj.hndl,1000);
            AT_CheckWarning(rc);
% %             disp('Toto');
            [rc,outImageFrame] = AT_ConvertMono16ToMatrix(buf,obj.height,obj.width, obj.stride);
             AT_CheckWarning(rc);
            
        end
        
        
        
            %%% getting the exposure time of the camera
        function ExpoTime = getExposureTime(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
             ExpoTime = obj.exposuretime;
            
        end
        
        %%% getting the image Frame width
        function imgFrameWidth = getImageWidth(obj)
            imgFrameWidth = obj.width;
        end
        
        
           %%% getting the image Frame height
        function imgFrameHeight = getImageHeight(obj)
            imgFrameHeight = obj.height;
        end
        
        
   
        
        
        
        
        %%% Close the camera
        
        function shutDownCamera(obj)
            disp('Acquisition complete');
            [rc] = AT_Command(obj.hndl,'AcquisitionStop');
            AT_CheckWarning(rc);
            [rc] = AT_Flush(obj.hndl);
            AT_CheckWarning(rc);
            [rc] = AT_Close(obj.hndl);
            AT_CheckWarning(rc);
            [rc] = AT_FinaliseLibrary();
            AT_CheckWarning(rc);
            disp('Camera shutdown');
            
        end

        
        
    
        
        
    end
end

