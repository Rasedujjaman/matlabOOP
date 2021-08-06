%%% This function will close and delet the object 
%%% Befor doing so, we will set the exposure time and sensor size to 
%%% the default values


function closeDevices(obj)
        disp('Acquisition complete');

        %%%% Set the camera parameters to its default values
        obj = setDefaultParameters(obj);
        
        
        %%% delete the object and clear the object
        delete(obj)
        clear  obj

        imaqreset;
        disp('Camera shutdown');
            
end