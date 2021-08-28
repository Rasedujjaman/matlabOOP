function obj = setDefaultParameters(obj)

    %%% Set the exposure time to default
    
    obj.vid.ExposureTimeAbs = 10;
    
% %     obj = setExposureTime(obj, 10);
    %%%% Set the sensor size to the default
    obj.vid.Width = obj.SensorWidth;
    obj.vid.Height = obj.SensorHeight;
    
% %     obj = setROI(obj, obj.sensorWidthMax, obj.sensorHeightMax);
    %%% Setting the pixel format to the defaul value 
    obj.vid.PixelFormat = 'Mono8';  %% set the pixel format



end