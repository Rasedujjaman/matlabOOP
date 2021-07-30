        
%%% The function will return the ROI for the AndorZyla camera
function stringROI = getROI(obj)
     stringROI = [num2str(obj.width), ' X ', num2str(obj.height)];
end
        