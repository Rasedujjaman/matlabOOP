function closeDevices(obj)
	disp('Acquisition complete');      
        
%% Release the camera
	if (obj.IsCaptureON == 1)
        StopCapture(obj);
	end

	delete(obj)
	clear obj
    
    imaqreset;  %% IT WILL RELEASE THE CAMEAR FROM MATLAB FORCEFULLY
    disp('Camera shutdown');
            
end