        
%%% The function will return the ROI for the pco.panda camera
function stringROI = getROI(obj)
     


    h = obj.ROIWidth;   %% the horizontal width of the sensor
    v = obj.ROIHeight;  %% the vertical width of the sensor
    stringROI = [num2str(h), ' X ', num2str(v)];
    disp(stringROI);
       
        

end
        