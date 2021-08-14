 

function obj = rotationRelative(obj, degres, motor_id, clockwise)

            if nargin == 3
                clockwise = true;
            else
                clockwise = false;
            end
            
            if nargin == 2
                motor_id = obj.device_id(2);
                clockwise = true;
            end

            state_rot = ximc_get_status(motor_id);
            current_position = state_rot.CurPosition;
            
            step = (600/360)*degres;  %% one full rotation is 600 steps
            
            if clockwise
                calllib('libximc','command_move', motor_id,current_position+step,0);
            else
                calllib('libximc','command_move', motor_id,current_position-step,0);

            end
end