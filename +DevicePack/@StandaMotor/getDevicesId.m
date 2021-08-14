


  function obj = getDevicesId(obj)
            for ii = 1:obj.devices_count
% %             obj.device_id(ii) = calllib('libximc','open_device', obj.device_names{ii});
            disp(['ID of device [',num2str(ii),'] = ', num2str(obj.device_id(ii))]);
            end
  end