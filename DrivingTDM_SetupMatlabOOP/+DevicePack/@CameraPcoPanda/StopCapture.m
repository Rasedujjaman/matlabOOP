    
        
%% This function will make the camera stop from capturing image 

function stopCapture(obj)
	if(obj.IsCaptureON == 1)
        stop(obj.vid);
        obj.IsCaptureON = 0; 
	else
        disp('The camera is already in stop capture mode');
	end
end