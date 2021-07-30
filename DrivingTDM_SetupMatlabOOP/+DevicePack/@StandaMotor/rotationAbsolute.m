 


function obj = rotationAbsolute(obj, degres)
             step = (600/360)*degres;  %% one full rotation is 600 steps
             
             %%% motor_id = obj.device_id(2);
             calllib('libximc','command_move', obj.motor_id, step,0);
end
        