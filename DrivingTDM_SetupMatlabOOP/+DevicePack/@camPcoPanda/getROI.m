        
%%% The function will return the ROI for the pco.panda camera
function stringROI = getROI(obj)
     

         [errorCode] = calllib('PCO_CAM_SDK', 'PCO_GetROI', obj.out_ptr,...
             obj.wRoiX0, obj.wRoiY0, obj.wRoiX1, obj.wRoiY1);
        
        if (errorCode == 0)
        
           h = obj.wRoiX1 - obj.wRoiX0;  %% the horizontal width of the sensor
           v = obj.wRoiY1 - obj.wRoiY0;  %% the vertical width of the sensor
      
        
            stringROI = [num2str(h+1), ' X ', num2str(v+1)];
            disp(stringROI);
        else
            disp('Someting went wrong, check the getROI method');
        end
        

end
        