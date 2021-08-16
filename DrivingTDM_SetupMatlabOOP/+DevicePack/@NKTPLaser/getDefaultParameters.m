

%%% This function will display all the default parameters of the laser
%%% source

function obj = getDefaultParameters(obj)

    disp(['Default output power: ', num2str(obj.defaultPowerLevel), '%']);
    disp(['Default wavelength: ', num2str(obj.defaultWaveLength), 'nm']);
    disp(['Default spectral bandwidth: ', num2str(obj.defaultBandWidth), 'nm']);
    
end