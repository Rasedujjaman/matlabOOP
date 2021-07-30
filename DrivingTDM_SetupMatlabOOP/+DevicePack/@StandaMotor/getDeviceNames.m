 


function obj = getDeviceNames(obj)
            if obj.devices_count == 0
                disp('No devices found')
                return
            end
            for i=1:obj.devices_count
                disp(['Found device: ', obj.device_names{1,i}]);
            end

end
        