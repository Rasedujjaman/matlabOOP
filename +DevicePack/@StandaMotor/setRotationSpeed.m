 function obj = setRotationSpeed(obj, speed, motor_id)
             if nargin == 2
                motor_id = obj.device_id(2);
             end

            speedinstep = 0.8*speed;
            ximc_set_speed(motor_id, speedinstep, 0);

        end