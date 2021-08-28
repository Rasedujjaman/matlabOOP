

%% Capture many images, one by one but the image will not be returned in the matlab workspace
function startCapture(obj)
	if (obj.IsCaptureON == 0)
    % Tell the camera it will have to acquire many images
        obj.vid.TriggerRepeat = Inf;
        % Each image will be software triggered
        triggerconfig(obj.vid, 'manual');
        % Save video onto RAM, unless asked to write on the disk
        obj.vid.LoggingMode = 'memory';

        % Get Camera ready
        start(obj.vid)
        obj.IsCaptureON = 1; 
    else
       disp('The Camera is already in capture mode'); 
	end

end
