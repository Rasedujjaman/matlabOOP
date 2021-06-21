

classdef Camera
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
% %         widthImageFrame
% %         heightImageFrame
% %         exposureTime = 0.01;
% %         outImageFrame
        
        hndl   %% the camera handle 
        imagesize   %% size of the image in byte
       %%%%% ROI parameters
        width       %% sensor width
        height      %% sensor height 
        top         %% sensor top 
        left        %% sensor left
        
        stride
        exposuretime = 0.01;  %% exposure time of the camera (default is set to 10ms)
        
    end
    
    methods
        function obj = Camera()
            [rc] = AT_InitialiseLibrary();
            AT_CheckError(rc);
            [rc,hndl] = AT_Open(0);
            AT_CheckError(rc);
            %disp('Camera initialized');
            [rc] = AT_SetFloat(hndl,'ExposureTime',exposureTime);
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(hndl,'CycleMode','Continuous');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(hndl,'TriggerMode','Software');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl','16-bit (low noise & high well capacity)');
            AT_CheckWarning(rc);
            [rc] = AT_SetEnumString(hndl,'PixelEncoding','Mono16');
            AT_CheckWarning(rc);
            
            [rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
            AT_CheckWarning(rc);
            [rc,height] = AT_GetInt(hndl,'AOIHeight');
            AT_CheckWarning(rc);
            [rc,width] = AT_GetInt(hndl,'AOIWidth');
            AT_CheckWarning(rc);
            [rc,stride] = AT_GetInt(hndl,'AOIStride'); 
            AT_CheckWarning(rc);
            
        end
        
        %%% Setting the exposure time of the camera
        function obj = setExposureTime(obj, ExpoTime)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.exposuretime = ExpoTime;
            [rc] = AT_SetFloat(obj.hndl,'ExposureTime', obj.exposuretime);
            AT_CheckWarning(rc);
        end
        
        %%% Set the ROI (region of interest)
        
        function obj = setROI(obj, width, height)
            if(withd == 2560 && height == 2160)
                obj.left = 1; 
                obj.top = 1;
            elseif(width == 1776 && height == 1760)
                obj.left = 409;
                obj.top = 201;
                
            elseif(width == 1392 && height == 1040)
                obj.left = 601;
                obj.top = 561;
                
            elseif(width == 528 && height == 512)
                obj.left = 1033;
                obj.top = 825;
           
            else
                disp('ROI not supported');
            
            end
            
            
            
            %%% Set the ROI
            
            [rc] = AT_SetInt(obj.hndl,'AOIWidth',width);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOILeft',obj.left);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOIHeight',height);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOITop',obj.top);
            AT_CheckWarning(rc);
            [rc, obj.imagesize] = AT_GetInt(obj.hndl,'ImageSizeBytes'); 
             % % Eech time you set ROI, you must update the image size                                                           
                                                                                                                               
            AT_CheckWarning(rc);
            
            
        end

        %%% This function will return the image size
        function outPutImageSize = getImageSize(obj)
            [rc, outPutImageSize] = AT_GetInt(obj.hndl,'ImageSizeBytes');
             AT_CheckWarning(rc);
        end
        
        
        %%% This function will return the image frame 
        
        function outImageFrame = getImageFrame(obj)
            [rc] = AT_QueueBuffer(obj.hndl, obj.imagesize);
            AT_CheckWarning(rc);
            [rc] = AT_Command(obj.hndl,'SoftwareTrigger');
            AT_CheckWarning(rc);
            [rc,buf] = AT_WaitBuffer(obj.hndl,1000);
            AT_CheckWarning(rc);
            [rc,outImageFrame] = AT_ConvertMono16ToMatrix(buf,obj.height,obj.width, obj.stride);
            outImageFrame = outImageFrame';
             AT_CheckWarning(rc);
            
        end
        
        
        
    end
end

