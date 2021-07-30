    


function obj = goHome(obj)
     for ii = 1:obj.devices_count
        calllib('libximc','command_move',  obj.device_id(ii), 0 ,0);   %% set the motor position at zero (home position)
    end
end
        