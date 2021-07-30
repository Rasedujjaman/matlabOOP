function obj = setROIdefault(obj)
%%% Set the ROI with default value

         width = 2560;
         height = 2160;
         obj.left = 1; 
         obj.top = 1;

            [rc] = AT_Command(obj.hndl,'AcquisitionStop');
             AT_CheckWarning(rc);
            
           
     
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