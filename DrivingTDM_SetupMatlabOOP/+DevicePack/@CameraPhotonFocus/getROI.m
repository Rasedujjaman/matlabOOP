        
%%% The function will return the ROI for the pco.panda camera
function stringROI = getROI(obj)
     

    
        
           h = obj.vid.Width;  %% the horizontal width of the sensor
           v = obj.vid.Height;  %% the vertical width of the sensor
      
        
            stringROI = ['Width X Height = ', num2str(h), ' X ', num2str(v)];
            disp(stringROI);
        

end
        