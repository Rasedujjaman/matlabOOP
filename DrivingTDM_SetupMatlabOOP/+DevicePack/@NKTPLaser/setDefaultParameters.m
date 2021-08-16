
%%% This function will set the Laser out put to its default values


function obj = setDefaultParameters(obj)

             %%% Set the power level to default             
             setPowerLevel(obj, obj.defaultPowerLevel);
             
             %%% Set the wavelength to default
             obj.bandWidth = obj.defaultBandWidth; %% to the default bandwidth
             setWavelength(obj, obj.defaultWaveLength); %% to the default wavelength
end
            