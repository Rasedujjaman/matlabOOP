  function obj = initializeDevices(obj)
            probe_flags = 1 + 4; % ENUMERATE_PROBE and ENUMERATE_NETWORK flags used
            enum_hints = 'addr=192.168.1.1,172.16.2.3';
            % enum_hints = 'addr='; % Use this hint string for broadcast enumeration

            obj.device_names = ximc_enumerate_devices_wrap(probe_flags, enum_hints);
            obj.devices_count = size(obj.device_names,2);
            if obj.devices_count == 0
                disp('No devices found')
                return
            end
            for i=1:obj.devices_count
                disp(['Found device: ', obj.device_names{1,i}]);
            end
            
            for ii = 1:obj.devices_count
            obj.device_id(ii) = calllib('libximc','open_device', obj.device_names{ii});
% %             disp(['Using device id ', num2str(obj.device_id)]);
            end
            disp('Devices are initialized');
end
        