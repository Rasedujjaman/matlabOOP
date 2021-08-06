%%% This function will set the camera sensor size for the image to be captured
%%% 

function obj = setROI(obj, width, height)
            
           
            if((width >= 896 && width <= obj.sensorWidthMax) && (height >=1 && height <= obj.sensorHeightMax...
                    && mod(width, 32)==0))
                obj.vid.Width = width;
                obj.vid.Height = height;
                
                %%% Update the value of active sensor size
                obj.sensorWidthActive = width;
                obj.sensorHeightActive = height;

                disp('ROI is set properly')

            else
                disp('ROI not supported');
                disp('Choose from the list below: ');
                disp('Supported ROI width 896 to 1312 and must be divisible by 32');
                disp('Supported ROI height 1 to 1082');       
            end
            
              %%% Set the ROI with new values
            
              
 end