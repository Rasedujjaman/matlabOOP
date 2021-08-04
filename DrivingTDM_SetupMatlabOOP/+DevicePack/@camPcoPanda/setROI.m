%%% The function will set the ROI for the pco.panda camera
function obj = setROI(obj, this_width, this_height)
        
         %%%% Here we always select the central part of the camera sensor
         %%%% of the given size of (this_width x this_height)
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%% Check the argument of the function setROI
         
            if nargin == 2
                this_height = this_width;
            end
            if nargin == 1
                disp('Chose a new ROI');
                return;  %% function setROI will be stopped
                        
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
% %          sensorOffsetTotal_alongWidth :  total sensor offset (left and
% %                                          right to the selected sensor width)
% %          sensorOffsetTotal_alongHeight : total sensor offset (top and
% %                                          bottom to the selected sensor height)
% %          
      
         
         sensorOffsetTotal_alongWidth =  obj.sensorWidthMax-this_width;
         sensorOffsetTotal_alongHeight = obj.sensorHeightMax-this_height;
         
         
         %%%% Finding the starting coordinate (see the Sensor ROI in
         %%%% PCO.SDK manuals
% %          wRoiX0;       %% x position of top letf corner of the sensor
% %          wRoiY0;       %% y position of top letf corner of the sensor
% %          wRoiX1;      %% x position of bottom right corner of the sensor 
% %          wRoiY1;      %% y position of bottom right corner of the sensor
        
         obj.wRoiX0 = floor(sensorOffsetTotal_alongWidth/2)+1;
         obj.wRoiY0 = floor(sensorOffsetTotal_alongHeight/2)+1;
         
         
         
         obj.wRoiX1 = 2048  - floor(sensorOffsetTotal_alongWidth/2);
         obj.wRoiY1 = 2048  - floor(sensorOffsetTotal_alongHeight/2);
         
         
% %          disp([obj.wRoiX0 obj.wRoiY0  obj.wRoiX1,  obj.wRoiY1]); 

         
         [errorCode_1] = calllib('PCO_CAM_SDK', 'PCO_SetROI', obj.out_ptr,...
             obj.wRoiX0, obj.wRoiY0, obj.wRoiX1, obj.wRoiY1);
        
% %            disp(errorCode_1);
         
        
         
         flags=2; %IMAGEPARAMETERS_READ_WHILE_RECORDING;
         errorCode_2 = calllib('PCO_CAM_SDK', 'PCO_SetImageParameters', obj.out_ptr, this_width, this_height, flags,[],0);
         
% %         disp(errorCode_2);
    
% %         
        errorCode_3 = calllib('PCO_CAM_SDK', 'PCO_ArmCamera', obj.out_ptr);
% %          disp(errorCode_3); 
         
         if (errorCode_1 == 0 && errorCode_2 == 0 && errorCode_3 == 0 )
            disp('ROI is set properly');
         else
            disp('Someting went wrong, check the supported HARDWARE ROI values');
         end
         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %             %glvar.do_libunload: 1 unload lib at end
% % %             %glvar.do_close:     1 close camera SDK at end
% % %             %glvar.camera_open:  open status of camera SDK
% % %             %glvar.out_ptr:      libpointer to camera SDK handle

% %             disp('The glvar parameters');
% %             disp(obj.glvar.do_libunload);
% %             disp(obj.glvar.do_close);
% %             disp(obj.glvar.camera_open);
% %             disp(obj.glvar.out_ptr);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%% Set the Current sensor size to the camera object 
            
            obj.sensorWidthActive  = this_width;
            obj.sensorHeightActive = this_height;
            

end
     