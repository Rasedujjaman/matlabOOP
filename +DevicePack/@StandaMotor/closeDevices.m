  % % % Close the devices
        
        function  closeDevices(obj)
            for ii = 1:obj.devices_count
                device_id_ptr(ii) = libpointer('int32Ptr', obj.device_id(ii));
                calllib('libximc','command_move',  obj.device_id(ii), 0 ,0);   %% set the motor position at zero (home position)
                calllib('libximc','close_device', device_id_ptr(ii));
                disp(['Device[', num2str(ii),'] is are closed']);
            end
        end