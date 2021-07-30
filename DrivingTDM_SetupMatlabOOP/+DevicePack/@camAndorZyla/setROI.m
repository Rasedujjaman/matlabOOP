%%% This function will set the camera sensor size for the image to be captured
%%% Andor zyla camera support only limited number of width and height
%%% combination for the ROI.
%%% If invalid widht and height are asked to set it will not work and 
%%% give you the supported ROI for this specific camera

function obj = setROI(obj, width, height)
            [rc] = AT_Command(obj.hndl,'AcquisitionStop');
            AT_CheckWarning(rc);
            
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
                disp('Choose from the list below: ');
                disp([num2str(2560), ' X ', num2str(2160)]);
                disp([num2str(2560), ' X ', num2str(2160)]);
                disp([num2str(1392), ' X ', num2str(1040)]);
                disp([num2str(528), ' X ', num2str(512)]);
            
          
            end
            
              %%% Set the ROI with new values
            
            [rc] = AT_SetInt(obj.hndl,'AOIWidth',width);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOILeft',obj.left);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOIHeight',height);
            AT_CheckWarning(rc);
            [rc] = AT_SetInt(obj.hndl,'AOITop',obj.top);
            AT_CheckWarning(rc);                                                                                                          
     
           disp('ROI is set properly')
           [rc] = AT_Command(obj.hndl,'AcquisitionStart');
            AT_CheckWarning(rc);
            
            %%%% Refresh all the paramerters related to the size of the image 
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
 end